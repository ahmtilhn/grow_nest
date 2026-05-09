import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../app/app_controller.dart';
import '../../firebase_options.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class PushNotificationBridge {
  PushNotificationBridge({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  String? _lastToken;
  String? _lastSyncedFamilyId;
  bool? _lastSyncedEnabled;

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
