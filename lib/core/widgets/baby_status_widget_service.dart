import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../../app/app_controller.dart';
import '../firebase/email_verification_service.dart';
import '../firebase/firebase_auth_gateway.dart';
import '../firebase/firebase_sync_service.dart';
import '../../data/local/app_database.dart' hide TrackerRecord;
import '../../data/repositories/app_repository.dart';
import '../../domain/entities/app_entities.dart';
import '../../firebase_options.dart';

const _androidWidgetName = 'BabyStatusWidgetProvider';
const _iosWidgetName = 'BabyStatusWidget';
const _appGroupId = 'group.com.miniadimlar.app.widgets';
const defaultWidgetFeedingMlOptions = [60, 90, 120];

enum BabyWidgetAction { feeding, diaper, sleepToggle }

class BabyWidgetActionRequest {
  const BabyWidgetActionRequest({
    required this.action,
    this.feedingMl,
    this.diaperValue,
  });

  final BabyWidgetAction action;
  final int? feedingMl;
  final String? diaperValue;
}

enum WidgetPinResult { requested, unsupported, iosManual }

class BabyStatusWidgetService {
  const BabyStatusWidgetService._();

  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);
      await HomeWidget.registerInteractivityCallback(babyStatusWidgetCallback);
    } catch (error) {
      debugPrint('Baby widget initialization skipped: $error');
    }
  }

  static Future<void> syncSnapshot(
    AppSnapshot snapshot, {
    List<int> feedingMlOptions = defaultWidgetFeedingMlOptions,
  }) async {
    final payload = BabyWidgetPayload.fromSnapshot(
      snapshot,
      feedingMlOptions: feedingMlOptions,
    );
    await _savePayload(payload);
    await refresh();
  }

  static Future<void> refresh() async {
    try {
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
        iOSName: _iosWidgetName,
      );
    } catch (error) {
      debugPrint('Baby widget refresh skipped: $error');
    }
  }

  static Future<WidgetPinResult> requestHomeWidgetPin() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return WidgetPinResult.iosManual;
    }
    final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
    if (!supported) return WidgetPinResult.unsupported;
    await HomeWidget.requestPinWidget(
      name: _androidWidgetName,
      androidName: _androidWidgetName,
    );
    return WidgetPinResult.requested;
  }

  static Future<void> _savePayload(BabyWidgetPayload payload) async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<bool>('hasSession', payload.hasSession),
        HomeWidget.saveWidgetData<String>('babyName', payload.babyName),
        HomeWidget.saveWidgetData<String>('emptyMessage', payload.emptyMessage),
        HomeWidget.saveWidgetData<String>(
          'feedingAt',
          (payload.feedingAt?.millisecondsSinceEpoch ?? 0).toString(),
        ),
        HomeWidget.saveWidgetData<String>(
          'feedingDetail',
          payload.feedingDetail,
        ),
        HomeWidget.saveWidgetData<int>(
          'feedOption1',
          payload.feedingMlOptions[0],
        ),
        HomeWidget.saveWidgetData<int>(
          'feedOption2',
          payload.feedingMlOptions[1],
        ),
        HomeWidget.saveWidgetData<int>(
          'feedOption3',
          payload.feedingMlOptions[2],
        ),
        HomeWidget.saveWidgetData<String>(
          'diaperAt',
          (payload.diaperAt?.millisecondsSinceEpoch ?? 0).toString(),
        ),
        HomeWidget.saveWidgetData<String>('diaperDetail', payload.diaperDetail),
        HomeWidget.saveWidgetData<String>(
          'sleepAt',
          (payload.sleepAt?.millisecondsSinceEpoch ?? 0).toString(),
        ),
        HomeWidget.saveWidgetData<String>('sleepDetail', payload.sleepDetail),
        HomeWidget.saveWidgetData<int>('sleepMinutes', payload.sleepMinutes),
        HomeWidget.saveWidgetData<int>(
          'sleepGoalMinutes',
          payload.sleepGoalMinutes,
        ),
        HomeWidget.saveWidgetData<bool>('isSleeping', payload.isSleeping),
        HomeWidget.saveWidgetData<bool>('canAddFeeding', payload.canAddFeeding),
        HomeWidget.saveWidgetData<bool>('canAddDiaper', payload.canAddDiaper),
        HomeWidget.saveWidgetData<bool>(
          'canManageSleep',
          payload.canManageSleep,
        ),
        HomeWidget.saveWidgetData<int>(
          'updatedAt',
          DateTime.now().millisecondsSinceEpoch,
        ),
      ]);
    } catch (error) {
      debugPrint('Baby widget data save skipped: $error');
    }
  }

  static Future<void> performAction(BabyWidgetActionRequest request) async {
    WidgetsFlutterBinding.ensureInitialized();
    await _ensureFirebase();

    final database = AppDatabase.open();
    AppController? controller;
    try {
      final repository = AppRepository(database);
      await repository.seedContent();

      final auth = firebase_auth.FirebaseAuth.instance;
      controller = AppController(
        repository,
        authGateway: FirebaseAuthGateway(auth: auth),
        emailVerificationService: FirebaseEmailVerificationService(auth: auth),
        syncService: FirebaseFirestoreSyncService(auth: auth),
      );

      await controller.load(syncLiveFamily: false);

      await performActionWithController(controller, request, syncRemote: false);
      await syncSnapshot(
        controller.snapshot,
        feedingMlOptions: controller.widgetFeedingMlOptions,
      );
      await controller.syncPendingTrackerRecords();
      await syncSnapshot(
        controller.snapshot,
        feedingMlOptions: controller.widgetFeedingMlOptions,
      );
    } finally {
      controller?.dispose();
      await database.close();
    }
  }

  static Future<StreamSubscription<Uri?>?> bindForegroundActions(
    AppController controller,
  ) async {
    try {
      final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      unawaited(handleForegroundUri(controller, initialUri));
    } catch (error) {
      debugPrint('Initial baby widget launch handling skipped: $error');
    }
    try {
      return HomeWidget.widgetClicked.listen(
        (uri) => unawaited(handleForegroundUri(controller, uri)),
        onError: (Object error) {
          debugPrint('Baby widget click handling skipped: $error');
        },
      );
    } catch (error) {
      debugPrint('Baby widget click listener skipped: $error');
      return null;
    }
  }

  @visibleForTesting
  static Future<void> handleForegroundUri(
    AppController controller,
    Uri? uri,
  ) async {
    if (uri == null) return;
    final request = parseActionUri(uri);
    if (request == null) {
      await controller.refreshAfterExternalChange(refreshRemote: true);
      return;
    }
    await performActionWithController(controller, request, syncRemote: false);
    await syncSnapshot(
      controller.snapshot,
      feedingMlOptions: controller.widgetFeedingMlOptions,
    );
    await controller.syncPendingTrackerRecords();
    await syncSnapshot(
      controller.snapshot,
      feedingMlOptions: controller.widgetFeedingMlOptions,
    );
  }

  @visibleForTesting
  static Future<void> performActionWithController(
    AppController controller,
    BabyWidgetActionRequest request, {
    bool syncRemote = true,
  }) async {
    switch (request.action) {
      case BabyWidgetAction.feeding:
        final amount = request.feedingMl;
        if (amount == null) return;
        await controller.addRecord(
          type: RecordType.feeding,
          title: 'Beslenme',
          value: '$amount ml',
          syncRemote: syncRemote,
        );
      case BabyWidgetAction.diaper:
        final diaperValue = request.diaperValue;
        if (diaperValue == null) return;
        await controller.addRecord(
          type: RecordType.diaper,
          title: 'Bez Değişimi',
          value: diaperValue,
          syncRemote: syncRemote,
        );
      case BabyWidgetAction.sleepToggle:
        final activeSleep = controller.activeSleepRecord;
        if (activeSleep == null) {
          await controller.startSleep(syncRemote: syncRemote);
        } else {
          await controller.finishSleep(activeSleep, syncRemote: syncRemote);
        }
    }
  }

  @visibleForTesting
  static BabyWidgetActionRequest? parseActionUri(Uri? uri) {
    final host = uri?.host;
    if (host == 'feeding') {
      final amount = int.tryParse(uri?.queryParameters['ml'] ?? '');
      if (amount == null || amount <= 0) return null;
      return BabyWidgetActionRequest(
        action: BabyWidgetAction.feeding,
        feedingMl: amount,
      );
    }
    if (host == 'diaper') {
      final diaperValue = _diaperValueFromQuery(uri?.queryParameters['type']);
      if (diaperValue == null) return null;
      return BabyWidgetActionRequest(
        action: BabyWidgetAction.diaper,
        diaperValue: diaperValue,
      );
    }
    if (host == 'sleep') {
      return const BabyWidgetActionRequest(
        action: BabyWidgetAction.sleepToggle,
      );
    }
    return null;
  }

  static Future<void> _ensureFirebase() async {
    if (Firebase.apps.isNotEmpty) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

@pragma('vm:entry-point')
Future<void> babyStatusWidgetCallback(Uri? uri) async {
  final request = BabyStatusWidgetService.parseActionUri(uri);
  if (request == null) return;
  try {
    await BabyStatusWidgetService.performAction(request);
  } catch (error, stackTrace) {
    debugPrint('Baby widget action failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    unawaited(BabyStatusWidgetService.refresh());
  }
}

String? _diaperValueFromQuery(String? value) {
  return switch (value?.trim().toLowerCase()) {
    'wet' => 'Islak',
    'dirty' => 'Kirli',
    'both' => 'Karışık',
    _ => null,
  };
}

@visibleForTesting
class BabyWidgetPayload {
  const BabyWidgetPayload({
    required this.hasSession,
    required this.babyName,
    required this.emptyMessage,
    required this.feedingAt,
    required this.feedingDetail,
    required this.feedingMlOptions,
    required this.diaperAt,
    required this.diaperDetail,
    required this.sleepAt,
    required this.sleepDetail,
    required this.sleepMinutes,
    required this.sleepGoalMinutes,
    required this.isSleeping,
    required this.canAddFeeding,
    required this.canAddDiaper,
    required this.canManageSleep,
  });

  final bool hasSession;
  final String babyName;
  final String emptyMessage;
  final DateTime? feedingAt;
  final String feedingDetail;
  final List<int> feedingMlOptions;
  final DateTime? diaperAt;
  final String diaperDetail;
  final DateTime? sleepAt;
  final String sleepDetail;
  final int sleepMinutes;
  final int sleepGoalMinutes;
  final bool isSleeping;
  final bool canAddFeeding;
  final bool canAddDiaper;
  final bool canManageSleep;

  factory BabyWidgetPayload.fromSnapshot(
    AppSnapshot snapshot, {
    List<int> feedingMlOptions = defaultWidgetFeedingMlOptions,
  }) {
    final normalizedFeedingMlOptions = _normalizeFeedingOptions(
      feedingMlOptions,
    );
    final hasSession = snapshot.user != null && snapshot.baby != null;
    if (!hasSession) {
      return BabyWidgetPayload(
        hasSession: false,
        babyName: '',
        emptyMessage: 'Uygulamayı açın',
        feedingAt: null,
        feedingDetail: '',
        feedingMlOptions: normalizedFeedingMlOptions,
        diaperAt: null,
        diaperDetail: '',
        sleepAt: null,
        sleepDetail: '',
        sleepMinutes: 0,
        sleepGoalMinutes: 14 * 60,
        isSleeping: false,
        canAddFeeding: false,
        canAddDiaper: false,
        canManageSleep: false,
      );
    }

    final feeding = _latest(snapshot.records, RecordType.feeding);
    final diaper = _latest(snapshot.records, RecordType.diaper);
    final sleep = _latest(snapshot.records, RecordType.sleep);
    final permissions = _permissions(snapshot);
    final isSleeping = sleep?.value == 'active';
    final sleepMinutes = _sleepMinutesLastDay(snapshot.records);
    final sleepGoalMinutes = _sleepGoalMinutes(snapshot.baby?.birthDate);

    return BabyWidgetPayload(
      hasSession: true,
      babyName: snapshot.baby?.name ?? 'Bebek',
      emptyMessage: '',
      feedingAt: feeding?.occurredAt,
      feedingDetail: _recordDetail(feeding),
      feedingMlOptions: normalizedFeedingMlOptions,
      diaperAt: diaper?.occurredAt,
      diaperDetail: _diaperDetail(diaper),
      sleepAt: sleep?.occurredAt,
      sleepDetail: isSleeping ? 'Uyuyor' : _recordDetail(sleep),
      sleepMinutes: sleepMinutes,
      sleepGoalMinutes: sleepGoalMinutes,
      isSleeping: isSleeping,
      canAddFeeding: permissions.contains(FamilyPermission.addFeeding),
      canAddDiaper: permissions.contains(FamilyPermission.addDiaper),
      canManageSleep: permissions.contains(FamilyPermission.manageSleep),
    );
  }

  static TrackerRecord? _latest(List<TrackerRecord> records, RecordType type) {
    for (final record in records) {
      if (record.type == type) return record;
    }
    return null;
  }

  static List<int> _normalizeFeedingOptions(List<int> options) {
    final normalized = <int>[];
    for (final option in options) {
      final value = option.clamp(10, 300).toInt();
      if (!normalized.contains(value)) normalized.add(value);
      if (normalized.length == 3) break;
    }
    for (final option in defaultWidgetFeedingMlOptions) {
      if (!normalized.contains(option)) normalized.add(option);
      if (normalized.length == 3) break;
    }
    return List<int>.unmodifiable(normalized.take(3));
  }

  static String _recordDetail(TrackerRecord? record) {
    final value = record?.value?.trim();
    if (value == null || value.isEmpty || value == 'active') return '';
    return value;
  }

  static String _diaperDetail(TrackerRecord? record) {
    final value = _recordDetail(record);
    return switch (value.toLowerCase()) {
      'wet' || 'islak' => 'Islak',
      'dirty' || 'kirli' => 'Kirli',
      'both' || 'karışık' || 'karisik' => 'Karışık',
      _ => value,
    };
  }

  static int _sleepMinutesLastDay(List<TrackerRecord> records) {
    final since = DateTime.now().subtract(const Duration(hours: 24));
    var total = 0;
    for (final record in records) {
      if (record.type != RecordType.sleep ||
          record.occurredAt.isBefore(since)) {
        continue;
      }
      final match = RegExp(r'(\d+)\s*dk').firstMatch(record.value ?? '');
      if (match != null) total += int.parse(match.group(1)!);
    }
    return total;
  }

  static int _sleepGoalMinutes(DateTime? birthDate) {
    if (birthDate == null) return 14 * 60;
    final ageMonths = DateTime.now().difference(birthDate).inDays ~/ 30;
    if (ageMonths < 4) return 14 * 60;
    if (ageMonths < 12) return 12 * 60;
    if (ageMonths < 24) return 11 * 60;
    return 10 * 60;
  }

  static List<FamilyPermission> _permissions(AppSnapshot snapshot) {
    final family = snapshot.family;
    final user = snapshot.user;
    if (family == null || user == null) return FamilyPermissionSets.owner;
    if (family.ownerUserId == user.id) return FamilyPermissionSets.owner;
    final normalizedEmail = user.email.trim().toLowerCase();
    for (final invite in snapshot.invites) {
      if (invite.familyId != family.id) continue;
      if (invite.status != FamilyInviteStatus.accepted) continue;
      final uidMatches = invite.acceptedUserId == user.id;
      final emailMatches =
          invite.invitedEmail.trim().toLowerCase() == normalizedEmail;
      if (uidMatches || emailMatches) return invite.permissions;
    }
    return const [];
  }
}
