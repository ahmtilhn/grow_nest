import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/ai/ai_analysis_service.dart';
import '../core/calendar/calendar_sync_service.dart';
import '../core/firebase/email_verification_service.dart';
import '../core/firebase/firebase_auth_gateway.dart';
import '../core/firebase/firebase_sync_service.dart';
import '../core/notifications/notification_service.dart';
import '../core/sync/remote_sync_models.dart';
import '../core/sync/sync_queue.dart';
import '../core/utils/app_calculators.dart';
import '../core/widgets/baby_status_widget_service.dart';
import '../data/repositories/app_repository.dart';
import '../domain/entities/app_entities.dart';
import '../domain/services/family_permission_policy.dart';

final appControllerProvider = Provider<AppController>(
  (ref) => throw UnimplementedError(),
);

final appControllerRevisionProvider =
    NotifierProvider<AppControllerRevision, int>(AppControllerRevision.new);

class AppControllerRevision extends Notifier<int> {
  @override
  int build() {
    final controller = ref.watch(appControllerProvider);
    void listener() => state += 1;

    controller.addListener(listener);
    ref.onDispose(() => controller.removeListener(listener));
    return 0;
  }
}

final appSnapshotProvider = Provider<AppSnapshot>((ref) {
  ref.watch(appControllerRevisionProvider);
  return ref.watch(appControllerProvider).snapshot;
});

class AppController extends ChangeNotifier {
  AppController(
    this._repository, {
    AuthGateway? authGateway,
    EmailVerificationService? emailVerificationService,
    RemoteSyncService? syncService,
    NotificationService? notificationService,
    CalendarSyncService? calendarSyncService,
  }) : ai = MockAiAnalysisService(),
       auth = authGateway ?? LocalAuthGateway(),
       emailVerification =
           emailVerificationService ?? const NoopEmailVerificationService(),
       remoteSync = syncService ?? const NoopRemoteSyncService(),
       notifications = notificationService ?? InMemoryNotificationService(),
       calendarSync = calendarSyncService ?? const NoopCalendarSyncService();

  final AppRepository _repository;
  final AiAnalysisService ai;
  final AuthGateway auth;
  final EmailVerificationService emailVerification;
  final RemoteSyncService remoteSync;
  final NotificationService notifications;
  final CalendarSyncService calendarSync;

  AppSnapshot snapshot = const AppSnapshot();
  bool isLoading = true;
  bool lockScreenSummaryEnabled = false;
  bool deviceCalendarSyncEnabled = false;
  List<int> widgetFeedingMlOptions = const [60, 90, 120];
  String? lastError;
  StreamSubscription<RemoteFamilySummary>? _familySubscription;
  String? _subscribedFamilyId;
  bool _applyingRemoteFamily = false;
  int _liveFamilyUpdatePauseDepth = 0;
  RemoteFamilySummary? _deferredLiveFamily;
  Future<void>? _pendingTrackerSyncInFlight;

  bool get isAuthenticated => snapshot.user != null;
  bool get onboardingComplete => snapshot.onboardingComplete;
  Locale get locale => Locale(snapshot.localeCode);
  bool get isFamilyOwner =>
      snapshot.user != null &&
      snapshot.family?.ownerUserId == snapshot.user!.id;
  static const _remoteRefreshCooldown = Duration(seconds: 45);
  DateTime? _lastInviteRefreshAt;
  DateTime? _lastRemoteFamilyRefreshAt;
  Future<void>? _inviteRefreshInFlight;
  Future<void>? _remoteFamilyRefreshInFlight;

  @override
  void dispose() {
    _familySubscription?.cancel();
    super.dispose();
  }

  Future<void> load({bool syncLiveFamily = true}) async {
    isLoading = true;
    notifyListeners();
    snapshot = await _repository.loadSnapshot();
    lockScreenSummaryEnabled = await _repository.lockScreenSummaryEnabled();
    deviceCalendarSyncEnabled = await _repository.deviceCalendarSyncEnabled();
    widgetFeedingMlOptions = await _repository.widgetFeedingMlOptions();
    isLoading = false;
    notifyListeners();
    unawaited(
      BabyStatusWidgetService.syncSnapshot(
        snapshot,
        feedingMlOptions: widgetFeedingMlOptions,
      ),
    );
    unawaited(_syncLockScreenSummary());
    if (syncLiveFamily) {
      await _syncLiveFamilySubscription();
      unawaited(_syncPendingTrackerRecords());
    }
  }

  Future<void> _refreshSnapshotAfterMutation({
    bool syncLiveFamily = true,
  }) async {
    snapshot = await _repository.loadSnapshot();
    lockScreenSummaryEnabled = await _repository.lockScreenSummaryEnabled();
    deviceCalendarSyncEnabled = await _repository.deviceCalendarSyncEnabled();
    widgetFeedingMlOptions = await _repository.widgetFeedingMlOptions();
    notifyListeners();
    unawaited(
      BabyStatusWidgetService.syncSnapshot(
        snapshot,
        feedingMlOptions: widgetFeedingMlOptions,
      ),
    );
    unawaited(_syncLockScreenSummary());
    if (syncLiveFamily) {
      await _syncLiveFamilySubscription();
    }
  }

  Future<void> refreshAfterExternalChange({bool refreshRemote = true}) async {
    await _refreshSnapshotAfterMutation();
    unawaited(_syncPendingTrackerRecords());
    if (!refreshRemote) return;
    unawaited(
      refreshFamilyInvites(showDeviceNotification: false, force: false),
    );
    unawaited(
      refreshRemoteFamilies(showDeviceNotification: false, force: false),
    );
  }

  void refreshTimeSensitiveViews() {
    if (isLoading) return;
    notifyListeners();
    unawaited(BabyStatusWidgetService.refresh());
    unawaited(_syncLockScreenSummary());
  }

  void pauseLiveFamilyUpdates() {
    _liveFamilyUpdatePauseDepth += 1;
  }

  Future<bool> resumeLiveFamilyUpdates({bool applyDeferred = true}) async {
    if (_liveFamilyUpdatePauseDepth == 0) return false;
    _liveFamilyUpdatePauseDepth -= 1;
    if (_liveFamilyUpdatePauseDepth > 0) return false;
    final family = _deferredLiveFamily;
    _deferredLiveFamily = null;
    if (!applyDeferred || family == null) return false;
    await _applyRemoteFamily(family);
    return true;
  }

  Future<void> refreshSnapshotAfterMutation({bool syncLiveFamily = true}) {
    return _refreshSnapshotAfterMutation(syncLiveFamily: syncLiveFamily);
  }

  Future<void> loginLocal(String email, String password) async {
    if (password.length < 6) {
      throw ArgumentError('Şifre en az 6 karakter olmalı.');
    }
    final normalized = email.trim().toLowerCase();
    final identity = await auth.signInWithEmail(normalized, password);
    if (identity == null) {
      await _repository.loginLocal(normalized, password);
    } else {
      await _repository.upsertAuthenticatedUser(
        id: identity.id,
        email: identity.email,
        displayName: identity.displayName,
        emailVerified: identity.emailVerified,
        avatarUrl: identity.avatarUrl,
        phone: identity.phone,
      );
    }
    await load();
    if (identity != null && !identity.emailVerified) {
      await _syncCurrentUser();
      await _requestVerificationCodeSafely();
      return;
    }
    await _syncCareState();
    await refreshFamilyInvites(force: true);
    await refreshRemoteFamilies(force: true);
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!ValidationUtils.validEmail(email)) {
      throw ArgumentError('Geçerli bir e-posta girin.');
    }
    if (password.length < 6) {
      throw ArgumentError('Şifre en az 6 karakter olmalı.');
    }
    final normalizedEmail = email.trim().toLowerCase();
    final identity = await auth.createWithEmail(normalizedEmail, password);
    if (identity == null) {
      await _repository.loginLocal(normalizedEmail, password);
    } else {
      await _repository.upsertAuthenticatedUser(
        id: identity.id,
        email: identity.email,
        displayName: name.trim().isEmpty ? identity.displayName : name.trim(),
        emailVerified: identity.emailVerified,
        avatarUrl: identity.avatarUrl,
        phone: identity.phone,
      );
    }
    if (name.trim().isNotEmpty) {
      await _repository.updateUserProfile(
        name: name,
        email: normalizedEmail,
        role: 'Ebeveyn',
      );
    }
    await load();
    if (identity != null && !identity.emailVerified) {
      await _syncCurrentUser();
      await _requestVerificationCodeSafely();
      return;
    }
    await _syncCareState();
    await refreshFamilyInvites(force: true);
    await refreshRemoteFamilies(force: true);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!ValidationUtils.validEmail(email)) {
      throw ArgumentError('Geçerli bir e-posta girin.');
    }
    await auth.sendPasswordResetEmail(email.trim().toLowerCase());
  }

  Future<void> loginWithGoogle() async {
    final identity = await auth.signInWithGoogle();
    if (identity == null) {
      throw StateError('Google girişi tamamlanamadı.');
    }
    await _repository.upsertAuthenticatedUser(
      id: identity.id,
      email: identity.email,
      displayName: identity.displayName,
      emailVerified: identity.emailVerified,
      avatarUrl: identity.avatarUrl,
      phone: identity.phone,
    );
    await load();
    await _syncCareState();
    await refreshFamilyInvites(force: true);
    await refreshRemoteFamilies(force: true);
  }

  Future<void> loginWithApple() async {
    final identity = await auth.signInWithApple();
    if (identity == null) {
      throw StateError('Apple girişi tamamlanamadı.');
    }
    await _repository.upsertAuthenticatedUser(
      id: identity.id,
      email: identity.email,
      displayName: identity.displayName,
      emailVerified: identity.emailVerified,
      avatarUrl: identity.avatarUrl,
      phone: identity.phone,
    );
    await load();
    await _syncCareState();
    await refreshFamilyInvites(force: true);
    await refreshRemoteFamilies(force: true);
  }

  Future<void> resendEmailVerificationCode() async {
    _requireSignedInUser();
    final state = await emailVerification.requestCode();
    if (state.verified) {
      await _markEmailVerified();
    }
  }

  Future<bool> verifyEmailCode(String code) async {
    _requireSignedInUser();
    final state = await emailVerification.verifyCode(code);
    if (!state.verified) return false;
    await _markEmailVerified();
    await _syncCareState();
    await refreshFamilyInvites(force: true);
    await refreshRemoteFamilies(force: true);
    return true;
  }

  Future<void> setLocale(String code) async {
    await _repository.setLocale(code);
    await load();
    await _syncCurrentUser();
  }

  Future<void> setThemeMode(bool dark) async {
    await _repository.setTheme(dark ? 'dark' : 'light');
    await load();
    await _syncCurrentUser();
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    DateTime? birthDate,
    String? phone,
    String? role,
  }) async {
    if (!ValidationUtils.validEmail(email)) {
      throw ArgumentError('Geçerli bir e-posta girin.');
    }
    await _repository.updateUserProfile(
      name: name,
      email: email,
      birthDate: birthDate,
      phone: phone,
      role: role,
    );
    await load();
    await _syncCurrentUser();
  }

  Future<void> updateNotificationPreferences({
    required bool notificationsEnabled,
    required bool healthEnabled,
    required bool familyEnabled,
    required bool reminderEnabled,
    required String sound,
  }) async {
    await _repository.setNotificationPreferences(
      notificationsEnabled: notificationsEnabled,
      healthEnabled: healthEnabled,
      familyEnabled: familyEnabled,
      reminderEnabled: reminderEnabled,
      sound: sound,
    );
    await load();
  }

  Future<void> setLockScreenSummaryEnabled(bool enabled) async {
    if (enabled) {
      final allowed = await notifications.requestPermission();
      if (!allowed) {
        throw const AppControllerException(
          'Kilit ekranı özeti için bildirim izni gerekli.',
        );
      }
    }
    await _repository.setLockScreenSummaryEnabled(enabled);
    lockScreenSummaryEnabled = enabled;
    notifyListeners();
    await _syncLockScreenSummary();
  }

  Future<void> setWidgetFeedingMlOptions(List<int> options) async {
    await _repository.setWidgetFeedingMlOptions(options);
    widgetFeedingMlOptions = await _repository.widgetFeedingMlOptions();
    notifyListeners();
    await BabyStatusWidgetService.syncSnapshot(
      snapshot,
      feedingMlOptions: widgetFeedingMlOptions,
    );
  }

  Future<void> setDeviceCalendarSyncEnabled(bool enabled) async {
    _requireVerifiedAccount();
    if (enabled) {
      final allowed = await calendarSync.requestAccess();
      if (!allowed) {
        throw const AppControllerException(
          'Telefon takvimi izni alınamadı. İzin ekranından tekrar deneyin.',
        );
      }
    } else {
      await _deleteAllDeviceCalendarReminderEvents();
    }
    await _repository.setDeviceCalendarSyncEnabled(enabled);
    deviceCalendarSyncEnabled = enabled;
    notifyListeners();
    if (enabled) {
      await _syncAllActiveRemindersToDeviceCalendar();
    }
  }

  Future<void> syncNotificationToken({
    required String token,
    required String platform,
  }) async {
    await _syncSafely(
      () => remoteSync.syncNotificationToken(
        token: token,
        platform: platform,
        familyId: snapshot.family?.id,
        notificationsEnabled: snapshot.notificationsEnabled,
      ),
    );
  }

  Future<void> completePregnancyOnboarding({
    required String parentName,
    required DateTime dueDate,
  }) async {
    _requireVerifiedAccount();
    await _repository.completePregnancyOnboarding(
      parentName: parentName.trim().isEmpty ? 'Ebeveyn' : parentName,
      dueDate: dueDate,
    );
    await load();
    await _syncCareState();
  }

  Future<void> completePlanningOnboarding({required String parentName}) async {
    _requireVerifiedAccount();
    await _repository.completePlanningOnboarding(
      parentName: parentName.trim().isEmpty ? 'MiniAdımlar' : parentName.trim(),
    );
    await load();
    await _syncCurrentUser();
  }

  Future<void> completeBabyOnboarding({
    required String parentName,
    required String babyName,
    required DateTime birthDate,
    double? weight,
    double? height,
    double? headCircumference,
  }) async {
    _requireVerifiedAccount();
    await _repository.completeBabyOnboarding(
      parentName: parentName.trim().isEmpty ? 'Ebeveyn' : parentName,
      babyName: babyName.trim().isEmpty ? 'Bebek' : babyName,
      birthDate: birthDate,
      weight: weight,
      height: height,
      headCircumference: headCircumference,
    );
    await load();
    await _syncCareState();
  }

  Future<TrackerRecord> addRecord({
    required RecordType type,
    required String title,
    String? value,
    String? note,
    DateTime? occurredAt,
    bool syncRemote = true,
  }) async {
    _requireVerifiedAccount();
    _requireRecordPermission(type, isEdit: false);
    final now = DateTime.now();
    final record = TrackerRecord(
      id: 'record-${now.microsecondsSinceEpoch}',
      type: type,
      title: title.trim(),
      value: value?.trim(),
      note: note?.trim(),
      familyId: snapshot.family?.id,
      babyId: snapshot.baby?.id,
      createdByUserId: snapshot.user?.id,
      createdByName: snapshot.user?.name,
      updatedByUserId: snapshot.user?.id,
      updatedByName: snapshot.user?.name,
      occurredAt: occurredAt ?? now,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.addRecord(record);
    await _refreshSnapshotAfterMutation(syncLiveFamily: syncRemote);
    if (syncRemote) {
      await _syncTrackerRecordSafely(record);
    }
    return record;
  }

  Future<TrackerRecord> addGrowthRecord({
    double? weightKg,
    double? heightCm,
    double? headCm,
    DateTime? occurredAt,
  }) async {
    final parts = <String>[
      if (weightKg != null) 'weightKg=$weightKg',
      if (heightCm != null) 'heightCm=$heightCm',
      if (headCm != null) 'headCm=$headCm',
    ];
    final record = await addRecord(
      type: RecordType.growth,
      title: 'Ölçüm',
      value: parts.join(';'),
      occurredAt: occurredAt,
    );
    await _syncCurrentBaby();
    return record;
  }

  Future<TrackerRecord> startSleep({bool syncRemote = true}) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.manageSleep);
    final active = activeSleepRecord;
    if (active != null) {
      throw const AppControllerException(
        'Devam eden uyku kaydı var. Önce uyandırma işlemini tamamlayın.',
      );
    }
    return addRecord(
      type: RecordType.sleep,
      title: 'Uyku başladı',
      value: 'active',
      syncRemote: syncRemote,
    );
  }

  TrackerRecord? get activeSleepRecord {
    for (final record in snapshot.records) {
      if (record.type == RecordType.sleep && record.value == 'active') {
        return record;
      }
    }
    return null;
  }

  Future<void> finishSleep(
    TrackerRecord activeSleep, {
    bool syncRemote = true,
  }) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.manageSleep);
    final now = DateTime.now();
    final minutes = now
        .difference(activeSleep.occurredAt)
        .inMinutes
        .clamp(1, 24 * 60);
    final completed = activeSleep.copyWith(
      title: 'Uyku tamamlandı',
      value: '$minutes dk',
      note:
          'Başlangıç: ${activeSleep.occurredAt.hour.toString().padLeft(2, '0')}:${activeSleep.occurredAt.minute.toString().padLeft(2, '0')}',
      updatedByUserId: snapshot.user?.id,
      updatedByName: snapshot.user?.name,
      updatedAt: now,
    );
    await _repository.updateRecord(completed);
    await _refreshSnapshotAfterMutation(syncLiveFamily: syncRemote);
    if (syncRemote) {
      await _syncTrackerRecordSafely(completed);
    }
  }

  Future<void> syncPendingTrackerRecords() {
    return _syncPendingTrackerRecords();
  }

  Future<void> updateRecord(TrackerRecord record) async {
    _requireVerifiedAccount();
    _requireRecordPermission(record.type, isEdit: true);
    final updated = record.copyWith(
      updatedByUserId: snapshot.user?.id,
      updatedByName: snapshot.user?.name,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await _repository.updateRecord(updated);
    await load();
    await _syncTrackerRecordSafely(updated);
  }

  Future<void> deleteRecord(String recordId) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.deleteRecords);
    await _repository.deleteRecord(recordId);
    await load();
    await _syncSafely(() => remoteSync.deleteTrackerRecord(recordId));
  }

  Future<void> addFamilyPartner(
    String email, {
    String? displayName,
    String? roleLabel,
    List<FamilyPermission>? permissions,
  }) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.inviteUsers);
    if (!ValidationUtils.validEmail(email)) {
      throw ArgumentError('Geçerli bir e-posta girin.');
    }
    final user = snapshot.user;
    final family = snapshot.family;
    if (user == null) {
      throw const AppControllerException('Önce giriş yapmalısınız.');
    }
    if (family == null) {
      throw const AppControllerException(
        'Davet göndermek için önce aile hesabı oluşturmalısınız.',
      );
    }
    final normalized = email.trim().toLowerCase();
    if (user.email.trim().toLowerCase() == normalized) {
      throw ArgumentError('Kendi hesabınıza davet gönderemezsiniz.');
    }
    final existingInvite = _inviteForFamilyEmail(family.id, normalized);
    if (existingInvite != null) {
      if (existingInvite.status == FamilyInviteStatus.accepted) {
        throw const AppControllerException(
          'Bu kullanıcı zaten bu aileye eklenmiş.',
        );
      }
      if (existingInvite.status == FamilyInviteStatus.pending) {
        throw const AppControllerException(
          'Bu kullanıcı için bekleyen bir davet zaten var.',
        );
      }
    }
    if (remoteSync.isEnabled) {
      await _runRequiredFirebaseAction(
        () async {
          await _syncInvitePrerequisitesStrict();
          await remoteSync.addFamilyPartner(
            familyId: family.id,
            familyOwnerUserId: family.ownerUserId,
            email: normalized,
            invitedByName: user.name,
            invitedDisplayName: displayName,
            roleLabel: roleLabel,
            permissions:
                permissions ??
                FamilyPermissionSets.defaultsForRole(roleLabel ?? 'Ebeveyn'),
          );
        },
        'Davet karşı hesaba gönderilemedi. İnternet ve Firebase bağlantısını kontrol edip tekrar deneyin.',
      );
    }
    await _repository.addFamilyPartner(
      normalized,
      displayName: displayName,
      roleLabel: roleLabel,
      permissions: permissions,
    );
    await load();
  }

  Future<void> updateFamilyInvitePermissions({
    required String inviteId,
    String? displayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
    bool refreshSnapshot = true,
  }) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.manageUserPermissions);
    final invite = _inviteById(inviteId);
    if (invite == null) {
      throw const AppControllerException('Davet veya aile üyesi bulunamadı.');
    }
    if (remoteSync.isEnabled) {
      await _runRequiredFirebaseAction(() async {
        await _syncInvitePrerequisitesStrict();
        await remoteSync.updateFamilyInvitePermissions(
          invite: invite,
          invitedDisplayName: displayName,
          roleLabel: roleLabel,
          permissions: permissions,
        );
      }, 'Yetkiler Firebase ile güncellenemedi. Lütfen tekrar deneyin.');
    }
    await _repository.updateFamilyInvitePermissions(
      inviteId: inviteId,
      displayName: displayName,
      roleLabel: roleLabel,
      permissions: permissions,
    );
    if (refreshSnapshot) {
      await _refreshSnapshotAfterMutation();
    }
  }

  Future<void> removeFamilyMember(String inviteId) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.removeUsers);
    final invite = _inviteById(inviteId);
    if (invite == null) {
      throw const AppControllerException('Aile üyesi bulunamadı.');
    }
    if (invite.acceptedUserId == snapshot.user?.id) {
      throw const AppControllerException(
        'Kendi hesabınızı buradan çıkaramazsınız.',
      );
    }
    if (remoteSync.isEnabled) {
      await _runRequiredFirebaseAction(
        () => remoteSync.removeFamilyMember(invite),
        'Aile üyesi Firebase üzerinden kaldırılamadı. Lütfen tekrar deneyin.',
      );
    }
    await _repository.removeFamilyMember(inviteId);
    await _refreshSnapshotAfterMutation();
  }

  Future<void> acceptFamilyInvite(String inviteId) async {
    _requireVerifiedAccount();
    final invite = _inviteById(inviteId);
    if (remoteSync.isEnabled) {
      if (invite == null) {
        throw const AppControllerException('Davet bulunamadı.');
      }
      await _runRequiredFirebaseAction(
        () => remoteSync.acceptFamilyInvite(invite),
        'Davet kabulü Firebase ile tamamlanamadı. Lütfen tekrar deneyin.',
      );
    }
    await _repository.acceptFamilyInvite(inviteId);
    await load();
    await refreshRemoteFamilies(force: true);
  }

  Future<void> declineFamilyInvite(String inviteId) async {
    final invite = _inviteById(inviteId);
    if (remoteSync.isEnabled) {
      if (invite == null) {
        throw const AppControllerException('Davet bulunamadı.');
      }
      await _runRequiredFirebaseAction(
        () => remoteSync.declineFamilyInvite(invite),
        'Davet reddi Firebase ile tamamlanamadı. Lütfen tekrar deneyin.',
      );
    }
    await _repository.declineFamilyInvite(inviteId);
    await load();
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _repository.markNotificationRead(notificationId);
    await _syncSafely(() => remoteSync.markNotificationRead(notificationId));
    await load();
  }

  Future<void> markAllNotificationsRead() async {
    final ids = await _repository.markNotificationsReadForCurrentUser();
    for (final id in ids) {
      await _syncSafely(() => remoteSync.markNotificationRead(id));
    }
    await load();
  }

  Future<void> updateBabyProfile({
    required String babyId,
    required String name,
    required DateTime birthDate,
    String? gender,
    double? birthWeight,
    double? birthHeight,
    double? birthHeadCircumference,
  }) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.editBaby);
    await _repository.updateBabyProfile(
      babyId: babyId,
      name: name,
      birthDate: birthDate,
      gender: gender,
      birthWeight: birthWeight,
      birthHeight: birthHeight,
      birthHeadCircumference: birthHeadCircumference,
    );
    await load();
    await _syncCurrentBaby();
  }

  Future<void> updatePregnancyProfile({
    required String pregnancyId,
    required DateTime dueDate,
  }) async {
    _requireVerifiedAccount();
    await _repository.updatePregnancyProfile(
      pregnancyId: pregnancyId,
      dueDate: dueDate,
    );
    await load();
    await _syncCurrentPregnancy();
  }

  Future<void> completeBirthFromPregnancy({
    required String babyName,
    required DateTime birthDate,
    double? weight,
    double? height,
    double? headCircumference,
  }) async {
    _requireVerifiedAccount();
    await _repository.completeBirthFromPregnancy(
      babyName: babyName.trim().isEmpty ? 'Bebek' : babyName.trim(),
      birthDate: birthDate,
      weight: weight,
      height: height,
      headCircumference: headCircumference,
    );
    await load();
    await _syncCareState();
  }

  Future<void> completeVaccine(String vaccineId, bool completed) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.addVaccine);
    await _repository.completeVaccine(vaccineId, completed);
    await load();
    final vaccine = snapshot.vaccines
        .where((item) => item.id == vaccineId)
        .cast<VaccineEvent?>()
        .firstWhere((item) => item != null, orElse: () => null);
    if (vaccine != null) {
      await _syncSafely(
        () => remoteSync.syncVaccineEvent(
          vaccine,
          updatedByName: snapshot.user?.name,
        ),
      );
    }
  }

  Future<void> addReminder({
    required ReminderCategory category,
    required String title,
    required DateTime time,
    String notes = '',
    String frequency = 'daily',
  }) async {
    _requireVerifiedAccount();
    _requireReminderPermission(category);
    final now = DateTime.now();
    final reminder = ReminderItem(
      id: 'reminder-${now.microsecondsSinceEpoch}',
      title: title,
      category: category,
      time: time,
      frequency: frequency,
      notes: notes,
      createdAt: now,
    );
    await _repository.addReminder(reminder);
    await _scheduleReminderNotifications(reminder);
    await _syncReminderToDeviceCalendar(reminder);
    if (snapshot.family != null) {
      await _syncSafely(
        () => remoteSync.syncReminder(
          reminder,
          familyId: snapshot.family!.id,
          createdByName: snapshot.user?.name,
        ),
      );
    }
    await load();
  }

  Future<void> updateReminder(ReminderItem reminder) async {
    _requireVerifiedAccount();
    _requireReminderPermission(reminder.category);
    await _cancelReminderNotifications(reminder.id);
    await _repository.updateReminder(reminder);
    await _scheduleReminderNotifications(reminder);
    await _syncReminderToDeviceCalendar(reminder);
    if (snapshot.family != null) {
      await _syncSafely(
        () => remoteSync.syncReminder(
          reminder,
          familyId: snapshot.family!.id,
          createdByName: snapshot.user?.name,
        ),
      );
    }
    await load();
  }

  Future<void> deleteReminder(String reminderId) async {
    _requireVerifiedAccount();
    _requirePermission(FamilyPermission.deleteRecords);
    await _cancelReminderNotifications(reminderId);
    await _deleteDeviceCalendarReminderEvents(reminderId);
    await _repository.deleteReminder(reminderId);
    if (snapshot.family != null) {
      await _syncSafely(() => remoteSync.deleteReminder(reminderId));
    }
    await load();
  }

  Future<void> toggleSavedArticle(String articleId) async {
    _requirePermission(FamilyPermission.saveArticle);
    await _repository.toggleSavedArticle(articleId);
    await load();
  }

  Future<void> reset() async {
    await auth.signOut();
    await _repository.reset();
    await load();
  }

  Future<void> logout() async {
    await auth.signOut();
    await _repository.clearCurrentSession();
    await load();
  }

  Future<void> deleteAccount() async {
    await auth.deleteCurrentUser();
    await _repository.reset();
    await load();
  }

  Future<void> refreshFamilyInvites({
    bool showDeviceNotification = true,
    bool force = true,
  }) {
    final inFlight = _inviteRefreshInFlight;
    if (!force && inFlight != null) return inFlight;
    if (!force && _isRemoteRefreshFresh(_lastInviteRefreshAt)) {
      return Future.value();
    }
    final future =
        _refreshFamilyInvitesNow(
          showDeviceNotification: showDeviceNotification,
        ).whenComplete(() {
          _lastInviteRefreshAt = DateTime.now();
          _inviteRefreshInFlight = null;
        });
    _inviteRefreshInFlight = future;
    return future;
  }

  Future<void> _refreshFamilyInvitesNow({
    required bool showDeviceNotification,
  }) async {
    final user = snapshot.user;
    if (user == null) return;
    if (remoteSync.isEnabled) {
      try {
        final invites = await remoteSync.fetchPendingFamilyInvites(user.email);
        for (final invite in invites) {
          await _repository.upsertRemotePendingInvite(invite);
        }
      } catch (_) {
        lastError = 'Firebase davet kontrolü beklemede.';
      }
    }

    final createdNotifications = await _repository
        .createPendingInviteNotificationsForCurrentUser();
    if (showDeviceNotification) {
      await _showFamilyNotifications(createdNotifications);
    }
    await load();
  }

  Future<void> refreshRemoteFamilies({
    bool showDeviceNotification = true,
    bool force = true,
  }) {
    final inFlight = _remoteFamilyRefreshInFlight;
    if (!force && inFlight != null) return inFlight;
    if (!force && _isRemoteRefreshFresh(_lastRemoteFamilyRefreshAt)) {
      return _syncLiveFamilySubscription();
    }
    final future =
        _refreshRemoteFamiliesNow(
          showDeviceNotification: showDeviceNotification,
        ).whenComplete(() {
          _lastRemoteFamilyRefreshAt = DateTime.now();
          _remoteFamilyRefreshInFlight = null;
        });
    _remoteFamilyRefreshInFlight = future;
    return future;
  }

  Future<void> refreshRemoteWidgetRecords({
    String? familyId,
    bool showDeviceNotification = false,
  }) async {
    final targetFamilyId = familyId ?? snapshot.family?.id;
    if (!remoteSync.isEnabled ||
        snapshot.user == null ||
        targetFamilyId == null ||
        targetFamilyId.isEmpty) {
      return;
    }
    try {
      final records = await remoteSync.fetchFamilyTrackerRecords(
        targetFamilyId,
        limit: 60,
      );
      final createdNotifications = await _repository.upsertRemoteTrackerRecords(
        familyId: targetFamilyId,
        records: records,
      );
      if (showDeviceNotification) {
        await _showFamilyNotifications(createdNotifications);
      }
      await load(syncLiveFamily: false);
    } catch (_) {
      lastError = 'Firebase widget synchronization is pending.';
    }
  }

  Future<void> _refreshRemoteFamiliesNow({
    required bool showDeviceNotification,
  }) async {
    if (!remoteSync.isEnabled || snapshot.user == null) return;
    try {
      final families = await remoteSync.fetchMyFamilies();
      for (final family in families) {
        final createdNotifications = await _repository.upsertRemoteFamily(
          family,
        );
        if (showDeviceNotification) {
          await _showFamilyNotifications(createdNotifications);
        }
      }
      await load();
      await _syncLiveFamilySubscription();
    } catch (_) {
      lastError = 'Firebase aile senkronizasyonu beklemede.';
    }
  }

  bool _isRemoteRefreshFresh(DateTime? lastRefreshAt) {
    if (lastRefreshAt == null) return false;
    return DateTime.now().difference(lastRefreshAt) < _remoteRefreshCooldown;
  }

  Future<void> _syncLiveFamilySubscription() async {
    if (!remoteSync.isEnabled || snapshot.family == null) {
      await _familySubscription?.cancel();
      _familySubscription = null;
      _subscribedFamilyId = null;
      return;
    }
    final familyId = snapshot.family!.id;
    if (_subscribedFamilyId == familyId && _familySubscription != null) {
      return;
    }
    await _familySubscription?.cancel();
    _subscribedFamilyId = familyId;
    _familySubscription = remoteSync
        .watchFamily(familyId)
        .listen(
          (family) async {
            if (_liveFamilyUpdatePauseDepth > 0) {
              _deferredLiveFamily = family;
              return;
            }
            await _applyRemoteFamily(family);
          },
          onError: (_) {
            lastError = 'Firebase canlı senkronizasyon beklemede.';
          },
        );
  }

  Future<void> _applyRemoteFamily(RemoteFamilySummary family) async {
    if (_applyingRemoteFamily) return;
    _applyingRemoteFamily = true;
    try {
      final createdNotifications = await _repository.upsertRemoteFamily(family);
      await _showFamilyNotifications(createdNotifications);
      await load(syncLiveFamily: false);
    } finally {
      _applyingRemoteFamily = false;
    }
  }

  Future<void> _syncCareState() async {
    await _syncCurrentUser();
    await _syncCurrentFamily();
    await _syncCurrentBaby();
    await _syncCurrentPregnancy();
  }

  Future<void> _syncInvitePrerequisitesStrict() async {
    final user = snapshot.user;
    if (user == null) return;
    await remoteSync.syncUser(user);
    final family = snapshot.family;
    if (family == null || family.ownerUserId != user.id) return;
    await remoteSync.syncFamily(family);
    final baby = snapshot.baby;
    if (baby != null) await remoteSync.syncBaby(baby);
  }

  Future<void> _syncCurrentUser() async {
    final user = snapshot.user;
    if (user == null) return;
    await _syncSafely(() => remoteSync.syncUser(user));
  }

  Future<void> _syncCurrentFamily() async {
    final family = snapshot.family;
    if (family == null) return;
    await _syncSafely(() => remoteSync.syncFamily(family));
  }

  Future<void> _syncCurrentBaby() async {
    final baby = snapshot.baby;
    if (baby == null) return;
    await _syncSafely(() => remoteSync.syncBaby(baby));
  }

  Future<void> _syncCurrentPregnancy() async {
    final pregnancy = snapshot.pregnancy;
    if (pregnancy == null) return;
    await _syncSafely(() => remoteSync.syncPregnancy(pregnancy));
  }

  Future<void> _showFamilyNotifications(
    List<AppNotification> appNotifications,
  ) async {
    if (appNotifications.isEmpty) return;
    if (!snapshot.notificationsEnabled ||
        !snapshot.familyNotificationsEnabled) {
      return;
    }
    final permission = await notifications.requestPermission();
    if (!permission) return;
    for (final notification in appNotifications) {
      await notifications.show(
        ScheduledNotification(
          id: 'family-${notification.id}',
          title: notification.title,
          body: notification.body,
          scheduledAt: DateTime.now(),
          sound: snapshot.notificationSound,
        ),
      );
    }
  }

  Future<void> _syncSafely(Future<void> Function() action) async {
    if (!remoteSync.isEnabled) return;
    try {
      await action();
    } catch (_) {
      lastError = 'Firebase senkronizasyonu beklemede.';
    }
  }

  Future<void> _syncLockScreenSummary() async {
    if (!lockScreenSummaryEnabled ||
        snapshot.user == null ||
        snapshot.baby == null) {
      await notifications.cancelLockScreenSummary();
      return;
    }
    final feeding = _latestRecord(RecordType.feeding);
    final diaper = _latestRecord(RecordType.diaper);
    final sleep = _latestRecord(RecordType.sleep);
    final sleepLabel = sleep?.value == 'active'
        ? 'Uyuyor'
        : _ago(sleep?.occurredAt);
    await notifications.showLockScreenSummary(
      title: 'MiniAdımlar günlük özet',
      body:
          'Beslenme ${_clock(feeding?.occurredAt)} (${_ago(feeding?.occurredAt)}) • '
          'Bez ${_clock(diaper?.occurredAt)} (${_ago(diaper?.occurredAt)}) • '
          'Uyku $sleepLabel',
    );
  }

  TrackerRecord? _latestRecord(RecordType type) {
    for (final record in snapshot.records) {
      if (record.type == type) return record;
    }
    return null;
  }

  String _clock(DateTime? value) {
    if (value == null) return '--';
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  String _ago(DateTime? value) {
    if (value == null) return '--';
    final minutes = DateTime.now().difference(value).inMinutes.clamp(0, 9999);
    if (minutes < 60) return '${minutes}dk önce';
    return '${minutes ~/ 60}s ${(minutes % 60).toString().padLeft(2, '0')}dk önce';
  }

  Future<void> _syncTrackerRecordSafely(TrackerRecord record) async {
    if (!remoteSync.isEnabled) return;
    try {
      await remoteSync.syncTrackerRecord(record);
      await _repository.markTrackerRecordSynced(record.id);
    } catch (_) {
      lastError = 'Firebase senkronizasyonu beklemede.';
    }
  }

  Future<void> _syncPendingTrackerRecords() {
    final inFlight = _pendingTrackerSyncInFlight;
    if (inFlight != null) return inFlight;
    final future = _syncPendingTrackerRecordsNow().whenComplete(() {
      _pendingTrackerSyncInFlight = null;
    });
    _pendingTrackerSyncInFlight = future;
    return future;
  }

  Future<void> _syncPendingTrackerRecordsNow() async {
    if (!remoteSync.isEnabled || snapshot.user == null) return;
    final pending = await _repository.pendingTrackerRecords();
    for (final record in pending) {
      await _syncTrackerRecordSafely(record);
    }
  }

  bool hasPermission(FamilyPermission permission) {
    return FamilyPermissionPolicy.hasPermission(
      family: snapshot.family,
      user: snapshot.user,
      invites: snapshot.invites,
      permission: permission,
    );
  }

  void _requirePermission(FamilyPermission permission) {
    if (hasPermission(permission)) return;
    throw const AppControllerException(
      'Bu işlem için aile profilinde yetkiniz yok.',
    );
  }

  void _requireRecordPermission(RecordType type, {required bool isEdit}) {
    if (isEdit) {
      _requirePermission(FamilyPermission.editRecords);
      return;
    }
    _requirePermission(FamilyPermissionPolicy.createPermissionForRecord(type));
  }

  void _requireReminderPermission(ReminderCategory category) {
    final permission = switch (category) {
      ReminderCategory.vaccine => FamilyPermission.addVaccine,
      ReminderCategory.appointment => FamilyPermission.addAppointment,
      _ => FamilyPermission.addAppointment,
    };
    _requirePermission(permission);
  }

  void _requireSignedInUser() {
    if (snapshot.user == null) {
      throw const AppControllerException('Önce giriş yapmalısınız.');
    }
  }

  void _requireVerifiedAccount() {
    final user = snapshot.user;
    if (user == null) {
      throw const AppControllerException('Önce giriş yapmalısınız.');
    }
    if (!user.emailVerified) {
      throw const AppControllerException(
        'Veri oluşturmadan önce e-posta doğrulamasını tamamlayın.',
      );
    }
  }

  Future<void> _requestVerificationCodeSafely() async {
    if (!emailVerification.isEnabled) return;
    try {
      await emailVerification.requestCode();
    } catch (_) {
      lastError = 'Doğrulama kodu gönderimi beklemede.';
    }
  }

  Future<void> _markEmailVerified() async {
    final identity = await auth.refreshCurrentUser();
    await _repository.setCurrentUserEmailVerified(true);
    if (identity != null) {
      await _repository.upsertAuthenticatedUser(
        id: identity.id,
        email: identity.email,
        displayName: identity.displayName,
        emailVerified: true,
        avatarUrl: identity.avatarUrl,
        phone: identity.phone,
      );
    }
    await load();
  }

  Future<void> _runRequiredFirebaseAction(
    Future<void> Function() action,
    String message,
  ) async {
    if (!remoteSync.isEnabled) return;
    try {
      await action();
    } catch (error) {
      final detailedMessage = '$message ${_remoteErrorSummary(error)}'.trim();
      debugPrint('Required Firebase action failed: $error');
      lastError = detailedMessage;
      throw AppControllerException(detailedMessage);
    }
  }

  String _remoteErrorSummary(Object error) {
    final text = error.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) return '';
    final shortText = text.length > 180 ? '${text.substring(0, 180)}...' : text;
    return 'Ayrıntı: $shortText';
  }

  Future<void> _cancelReminderNotifications(String reminderId) async {
    await notifications.cancel(reminderId);
    for (var index = 0; index < 32; index++) {
      await notifications.cancel('$reminderId-$index');
    }
  }

  Future<void> _syncAllActiveRemindersToDeviceCalendar() async {
    for (final reminder in snapshot.reminders.where((item) => item.isActive)) {
      await _syncReminderToDeviceCalendar(reminder);
    }
  }

  Future<void> _syncReminderToDeviceCalendar(ReminderItem reminder) async {
    if (!deviceCalendarSyncEnabled) return;
    try {
      final existingEventIds = await _repository.calendarEventIdsForReminder(
        reminder.id,
      );
      final eventIds = await calendarSync.replaceReminderEvents(
        reminder,
        existingEventIds: existingEventIds,
      );
      await _repository.setCalendarEventIdsForReminder(reminder.id, eventIds);
    } catch (error, stackTrace) {
      debugPrint('Device calendar reminder sync failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      lastError = 'Telefon takvimi eşitlemesi tamamlanamadı.';
      notifyListeners();
    }
  }

  Future<void> _deleteDeviceCalendarReminderEvents(String reminderId) async {
    try {
      final eventIds = await _repository.calendarEventIdsForReminder(
        reminderId,
      );
      await calendarSync.deleteReminderEvents(eventIds);
      await _repository.removeCalendarEventIdsForReminder(reminderId);
    } catch (error, stackTrace) {
      debugPrint('Device calendar reminder delete failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      lastError = 'Telefon takvimi eşitlemesi tamamlanamadı.';
      notifyListeners();
    }
  }

  Future<void> _deleteAllDeviceCalendarReminderEvents() async {
    final mapping = await _repository.calendarReminderEventIds();
    for (final reminderId in mapping.keys) {
      await _deleteDeviceCalendarReminderEvents(reminderId);
    }
    await _repository.clearCalendarReminderEventIds();
  }

  Future<void> _scheduleReminderNotifications(ReminderItem reminder) async {
    if (!reminder.isActive ||
        !snapshot.notificationsEnabled ||
        !snapshot.reminderNotificationsEnabled) {
      return;
    }
    final plan = ReminderPlan.tryParse(reminder.frequency);
    await ReminderScheduler(notifications).schedule(
      id: reminder.id,
      title: reminder.title,
      category: _reminderCategoryLabel(reminder.category),
      time: reminder.time,
      notes: reminder.notes ?? '',
      frequency: ReminderScheduler.frequencyFromStoredValue(reminder.frequency),
      plan: plan,
      sound: snapshot.notificationSound,
    );
  }

  String _reminderCategoryLabel(ReminderCategory category) {
    return switch (category) {
      ReminderCategory.health => 'Sağlık',
      ReminderCategory.water => 'Su',
      ReminderCategory.feeding => 'Beslenme',
      ReminderCategory.vaccine => 'Aşı',
      ReminderCategory.appointment => 'Randevu',
      ReminderCategory.vitamin => 'Vitamin',
      ReminderCategory.medicine => 'İlaç',
      ReminderCategory.sleep => 'Uyku',
      ReminderCategory.diaper => 'Bez',
      ReminderCategory.custom => 'Hatırlatıcı',
    };
  }

  FamilyInvite? _inviteById(String inviteId) {
    for (final invite in snapshot.invites) {
      if (invite.id == inviteId) return invite;
    }
    return null;
  }

  FamilyInvite? _inviteForFamilyEmail(String familyId, String email) {
    final normalized = email.trim().toLowerCase();
    for (final invite in snapshot.invites) {
      if (invite.familyId != familyId) continue;
      if (invite.invitedEmail.trim().toLowerCase() != normalized) continue;
      if (invite.status == FamilyInviteStatus.declined) continue;
      return invite;
    }
    return null;
  }
}

class AppControllerException implements Exception {
  const AppControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
