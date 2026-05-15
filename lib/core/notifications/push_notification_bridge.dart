import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_controller.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/app_repository.dart';
import '../../firebase_options.dart';
import '../firebase/email_verification_service.dart';
import '../firebase/firebase_auth_gateway.dart';
import '../firebase/firebase_sync_service.dart';
import '../widgets/baby_status_widget_service.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['syncOnly'] != 'true') return;
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await _refreshWidgetFromBackgroundPush(message.data['familyId']);
}

Future<void> _refreshWidgetFromBackgroundPush(String? familyId) async {
  final auth = firebase_auth.FirebaseAuth.instance;
  if (auth.currentUser == null) return;

  final database = AppDatabase.open();
  AppController? controller;
  try {
    await BabyStatusWidgetService.initialize();
    final repository = AppRepository(database);
    await repository.seedContent();
    controller = AppController(
      repository,
      authGateway: FirebaseAuthGateway(auth: auth),
      emailVerificationService: FirebaseEmailVerificationService(auth: auth),
      syncService: FirebaseFirestoreSyncService(
        firestoreInstance: firestore.FirebaseFirestore.instance,
        auth: auth,
      ),
      notificationService: InMemoryNotificationService(),
    );
    await controller.load(syncLiveFamily: false);
    await controller.syncPendingTrackerRecords();
    final activeFamilyId = controller.snapshot.family?.id;
    if (familyId != null &&
        familyId.isNotEmpty &&
        activeFamilyId != null &&
        activeFamilyId != familyId) {
      return;
    }
    await _refreshWidgetRecordsFromPush(controller, familyId);
  } catch (error, stackTrace) {
    debugPrint('Background widget refresh skipped: $error');
    debugPrintStack(stackTrace: stackTrace);
  } finally {
    controller?.dispose();
    await database.close();
  }
}

class PushNotificationBridge {
  PushNotificationBridge({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  String? _lastToken;
  String? _lastSyncedFamilyId;
  bool? _lastSyncedEnabled;
  String? _lastTrackerRecordSyncKey;
  DateTime? _lastTrackerRecordSyncAt;

  Future<void> bind(AppController controller) async {
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } catch (error) {
      debugPrint('Firebase background messaging registration skipped: $error');
    }
    await _trySetForegroundPresentationOptions();
    await _tryRequestPermission();
    FirebaseMessaging.onMessage.listen((message) async {
      await _showForegroundNotificationOnAndroid(controller, message);
      if (_isTrackerRecordMessage(message)) {
        if (_shouldSkipDuplicateTrackerSync(message)) return;
        await _refreshWidgetRecordsFromPush(
          controller,
          message.data['familyId'],
        );
        return;
      }
      await controller.refreshRemoteFamilies(force: true);
    });
    final token = await _tryGetToken();
    if (token != null) {
      _lastToken = token;
      await _syncTokenIfNeeded(controller);
    }
    controller.addListener(() {
      unawaited(_syncTokenIfNeeded(controller));
    });
    _messaging.onTokenRefresh.listen(
      (token) async {
        _lastToken = token;
        _lastSyncedFamilyId = null;
        await _syncTokenIfNeeded(controller);
      },
      onError: (Object error) {
        debugPrint('Push notification token refresh skipped: $error');
      },
    );
  }

  Future<void> _syncTokenIfNeeded(AppController controller) async {
    final token = _lastToken;
    if (token == null || controller.snapshot.user == null) return;
    final familyId = controller.snapshot.family?.id;
    final enabled = controller.snapshot.notificationsEnabled;
    if (_lastSyncedFamilyId == familyId && _lastSyncedEnabled == enabled) {
      return;
    }
    await controller.syncNotificationToken(
      token: token,
      platform: _platformLabel,
    );
    _lastSyncedFamilyId = familyId;
    _lastSyncedEnabled = enabled;
  }

  Future<void> _showForegroundNotificationOnAndroid(
    AppController controller,
    RemoteMessage message,
  ) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    if (!controller.snapshot.notificationsEnabled) return;
    if (message.data['category'] == 'family' &&
        !controller.snapshot.familyNotificationsEnabled) {
      return;
    }
    final notification = message.notification;
    final title = notification?.title;
    final body = notification?.body;
    if (title == null || body == null) return;
    await controller.notifications.show(
      ScheduledNotification(
        id:
            message.messageId ??
            'push-${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        body: body,
        scheduledAt: DateTime.now(),
      ),
    );
  }

  Future<void> _trySetForegroundPresentationOptions() async {
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (error) {
      debugPrint('Foreground notification presentation skipped: $error');
    }
  }

  Future<void> _tryRequestPermission() async {
    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (error) {
      debugPrint('Push notification permission request skipped: $error');
    }
  }

  Future<String?> _tryGetToken() async {
    try {
      return await _messaging.getToken();
    } catch (error) {
      debugPrint('Push notification token unavailable: $error');
      return null;
    }
  }

  bool _shouldSkipDuplicateTrackerSync(RemoteMessage message) {
    final key =
        (message.data['notificationId'] as String?)?.trim() ??
        message.messageId;
    if (key == null || key.isEmpty) return false;
    final now = DateTime.now();
    final lastSyncAt = _lastTrackerRecordSyncAt;
    if (_lastTrackerRecordSyncKey == key &&
        lastSyncAt != null &&
        now.difference(lastSyncAt) < const Duration(seconds: 20)) {
      return true;
    }
    _lastTrackerRecordSyncKey = key;
    _lastTrackerRecordSyncAt = now;
    return false;
  }

  String get _platformLabel {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };
  }
}

Future<void> _refreshWidgetRecordsFromPush(
  AppController controller,
  String? familyId,
) async {
  final activeFamilyId = controller.snapshot.family?.id;
  final targetFamilyId = familyId?.trim().isNotEmpty == true
      ? familyId!.trim()
      : activeFamilyId;
  if (targetFamilyId == null || targetFamilyId.isEmpty) return;
  if (activeFamilyId != null &&
      activeFamilyId.isNotEmpty &&
      activeFamilyId != targetFamilyId) {
    return;
  }
  await controller.refreshRemoteWidgetRecords(familyId: targetFamilyId);
  await BabyStatusWidgetService.syncSnapshot(
    controller.snapshot,
    feedingMlOptions: controller.widgetFeedingMlOptions,
  );
}

bool _isTrackerRecordMessage(RemoteMessage message) {
  if (message.data['syncOnly'] == 'true') return true;
  return switch (message.data['type']) {
    'family_record' ||
    'family_record_update' ||
    'family_record_deleted' => true,
    _ => false,
  };
}
