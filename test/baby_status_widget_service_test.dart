import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/app/app_controller.dart';
import 'package:grow_nest/core/firebase/firebase_sync_service.dart';
import 'package:grow_nest/core/sync/remote_sync_models.dart';
import 'package:grow_nest/core/widgets/baby_status_widget_service.dart';
import 'package:grow_nest/data/local/app_database.dart'
    hide Family, FamilyInvite, TrackerRecord, VaccineEvent;
import 'package:grow_nest/data/repositories/app_repository.dart';
import 'package:grow_nest/domain/entities/app_entities.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'widget action uris parse feeding amount, diaper type and sleep toggle',
    () {
      final feeding = BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://feeding?ml=90'),
      );
      expect(feeding?.action, BabyWidgetAction.feeding);
      expect(feeding?.feedingMl, 90);

      final diaper = BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://diaper?type=both'),
      );
      expect(diaper?.action, BabyWidgetAction.diaper);
      expect(diaper?.diaperValue, 'Karışık');

      final sleep = BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://sleep'),
      );
      expect(sleep?.action, BabyWidgetAction.sleepToggle);

      expect(
        BabyStatusWidgetService.parseActionUri(
          Uri.parse('grownestwidget://feeding'),
        ),
        isNull,
      );
      expect(
        BabyStatusWidgetService.parseActionUri(
          Uri.parse('grownestwidget://diaper'),
        ),
        isNull,
      );
    },
  );

  test('widget payload keeps custom feeding ml options', () {
    final payload = BabyWidgetPayload.fromSnapshot(
      const AppSnapshot(),
      feedingMlOptions: const [75, 105, 135],
    );

    expect(payload.feedingMlOptions, [75, 105, 135]);
  });

  test('widget quick actions create real records and sync them', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _WidgetRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('parent@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    remote.syncedRecords.clear();

    await BabyStatusWidgetService.performActionWithController(
      controller,
      BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://feeding?ml=90'),
      )!,
    );
    expect(controller.snapshot.records.first.type, RecordType.feeding);
    expect(controller.snapshot.records.first.value, '90 ml');
    expect(remote.syncedRecords.last.value, '90 ml');

    await BabyStatusWidgetService.performActionWithController(
      controller,
      BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://diaper?type=wet'),
      )!,
    );
    final diaperRecord = controller.snapshot.records.firstWhere(
      (record) => record.type == RecordType.diaper,
    );
    expect(diaperRecord.value, 'Islak');
    expect(remote.syncedRecords.last.value, 'Islak');

    await BabyStatusWidgetService.performActionWithController(
      controller,
      BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://sleep'),
      )!,
    );
    expect(controller.activeSleepRecord, isNotNull);
    expect(controller.activeSleepRecord?.value, 'active');
    expect(remote.syncedRecords.last.value, 'active');

    await Future<void>.delayed(const Duration(milliseconds: 2));
    await BabyStatusWidgetService.performActionWithController(
      controller,
      BabyStatusWidgetService.parseActionUri(
        Uri.parse('grownestwidget://sleep'),
      )!,
    );
    expect(controller.activeSleepRecord, isNull);
    final completedSleep = controller.snapshot.records.firstWhere(
      (record) => record.type == RecordType.sleep && record.value != 'active',
    );
    expect(completedSleep.value, contains('dk'));
    expect(remote.syncedRecords.last.value, contains('dk'));
  });

  test(
    'widget quick action can defer remote sync until after local refresh',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _WidgetRemoteSyncService();
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('parent@example.com', '123456');
      await controller.completeBabyOnboarding(
        parentName: 'Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );
      remote.syncedRecords.clear();

      await BabyStatusWidgetService.performActionWithController(
        controller,
        BabyStatusWidgetService.parseActionUri(
          Uri.parse('grownestwidget://feeding?ml=120'),
        )!,
        syncRemote: false,
      );

      expect(controller.snapshot.records.first.type, RecordType.feeding);
      expect(controller.snapshot.records.first.value, '120 ml');
      expect(remote.syncedRecords, isEmpty);

      await controller.syncPendingTrackerRecords();
      expect(remote.syncedRecords.last.value, '120 ml');
    },
  );

  test(
    'foreground widget action refreshes the running app controller',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _WidgetRemoteSyncService();
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('parent@example.com', '123456');
      await controller.completeBabyOnboarding(
        parentName: 'Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );
      remote.syncedRecords.clear();

      await BabyStatusWidgetService.handleForegroundUri(
        controller,
        Uri.parse('grownestwidget://feeding?ml=105'),
      );

      expect(controller.snapshot.records.first.type, RecordType.feeding);
      expect(controller.snapshot.records.first.value, '105 ml');
      expect(remote.syncedRecords.last.value, '105 ml');
    },
  );
}

class _WidgetRemoteSyncService implements RemoteSyncService {
  final syncedRecords = <TrackerRecord>[];

  @override
  bool get isEnabled => true;

  @override
  Future<void> syncUser(UserProfile user) async {}

  @override
  Future<void> syncFamily(Family family) async {}

  @override
  Future<void> syncBaby(BabyProfile baby) async {}

  @override
  Future<void> syncPregnancy(PregnancyProfile pregnancy) async {}

  @override
  Future<void> syncTrackerRecord(TrackerRecord record) async {
    syncedRecords.add(record);
  }

  @override
  Future<void> deleteTrackerRecord(String recordId) async {}

  @override
  Future<void> syncReminder(
    ReminderItem reminder, {
    required String familyId,
    String? createdByName,
  }) async {}

  @override
  Future<void> deleteReminder(String reminderId) async {}

  @override
  Future<void> syncVaccineEvent(
    VaccineEvent vaccine, {
    String? updatedByName,
  }) async {}

  @override
  Future<void> addFamilyPartner({
    required String familyId,
    required String familyOwnerUserId,
    required String email,
    required String invitedByName,
    String? invitedDisplayName,
    String? roleLabel,
    List<FamilyPermission> permissions = const [],
  }) async {}

  @override
  Future<void> updateFamilyInvitePermissions({
    required FamilyInvite invite,
    String? invitedDisplayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
  }) async {}

  @override
  Future<void> removeFamilyMember(FamilyInvite invite) async {}

  @override
  Future<void> acceptFamilyInvite(FamilyInvite invite) async {}

  @override
  Future<void> declineFamilyInvite(FamilyInvite invite) async {}

  @override
  Future<List<RemoteFamilyInvite>> fetchPendingFamilyInvites(
    String email,
  ) async {
    return const [];
  }

  @override
  Future<List<RemoteFamilySummary>> fetchMyFamilies() async {
    return const [];
  }

  @override
  Future<List<RemoteTrackerRecordSummary>> fetchFamilyTrackerRecords(
    String familyId, {
    int limit = 60,
  }) async {
    return const [];
  }

  @override
  Stream<RemoteFamilySummary> watchFamily(String familyId) {
    return const Stream.empty();
  }

  @override
  Future<void> syncNotificationToken({
    required String token,
    required String platform,
    String? familyId,
    required bool notificationsEnabled,
  }) async {}

  @override
  Future<void> markNotificationRead(String notificationId) async {}
}
