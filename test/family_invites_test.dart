import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:grow_nest/app/app_controller.dart';
import 'package:grow_nest/core/calendar/calendar_sync_service.dart';
import 'package:grow_nest/core/firebase/firebase_sync_service.dart';
import 'package:grow_nest/core/notifications/notification_service.dart';
import 'package:grow_nest/core/sync/remote_sync_models.dart';
import 'package:grow_nest/data/local/app_database.dart'
    hide Family, FamilyInvite, TrackerRecord, VaccineEvent;
import 'package:grow_nest/data/repositories/app_repository.dart';
import 'package:grow_nest/domain/entities/app_entities.dart';

void main() {
  test(
    'partner invite waits for invited user and joins family on accept',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();

      await repository.loginLocal('sender@example.com', '123456');
      await repository.completeBabyOnboarding(
        parentName: 'Sender Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );

      await repository.loginLocal('invitee@example.com', '123456');
      await repository.loginLocal('sender@example.com', '123456');
      await repository.addFamilyPartner('invitee@example.com');

      final senderSnapshot = await repository.loadSnapshot();
      expect(
        senderSnapshot.notifications.where(
          (item) => item.type == 'family_invite',
        ),
        isEmpty,
      );
      expect(senderSnapshot.invites.single.status, FamilyInviteStatus.pending);

      await repository.loginLocal('invitee@example.com', '123456');
      final inviteeSnapshot = await repository.loadSnapshot();

      expect(inviteeSnapshot.family, isNull);
      expect(inviteeSnapshot.invites.single.status, FamilyInviteStatus.pending);
      expect(inviteeSnapshot.notifications.single.title, 'Aile daveti');
      expect(
        inviteeSnapshot.notifications.single.body,
        contains('Sender Parent'),
      );

      await repository.acceptFamilyInvite(inviteeSnapshot.invites.single.id);
      final acceptedSnapshot = await repository.loadSnapshot();

      expect(acceptedSnapshot.family, isNotNull);
      expect(
        acceptedSnapshot.family!.partnerUserIds,
        contains('invitee@example.com'),
      );
      expect(
        acceptedSnapshot.invites.single.status,
        FamilyInviteStatus.accepted,
      );
    },
  );

  test('owner can remove an accepted family member locally', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();

    await repository.loginLocal('sender@example.com', '123456');
    await repository.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await repository.loginLocal('invitee@example.com', '123456');
    await repository.loginLocal('sender@example.com', '123456');
    await repository.addFamilyPartner('invitee@example.com');

    await repository.loginLocal('invitee@example.com', '123456');
    final inviteId = (await repository.loadSnapshot()).invites.single.id;
    await repository.acceptFamilyInvite(inviteId);

    await repository.loginLocal('sender@example.com', '123456');
    await repository.removeFamilyMember(inviteId);
    final ownerSnapshot = await repository.loadSnapshot();

    expect(
      ownerSnapshot.family!.partnerUserIds,
      isNot(contains('invitee@example.com')),
    );
    expect(ownerSnapshot.invites.single.status, FamilyInviteStatus.declined);
    expect(ownerSnapshot.invites.single.acceptedUserId, isNull);
  });

  test(
    'declined member is not resurrected by stale remote partner list',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();

      await repository.loginLocal('sender@example.com', '123456');
      await repository.completeBabyOnboarding(
        parentName: 'Sender Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );
      await repository.addFamilyPartner('invitee@example.com');

      await repository.loginLocal('invitee@example.com', '123456');
      final inviteId = (await repository.loadSnapshot()).invites.single.id;
      await repository.acceptFamilyInvite(inviteId);

      await repository.loginLocal('sender@example.com', '123456');
      await repository.removeFamilyMember(inviteId);
      await repository.upsertRemoteFamily(
        RemoteFamilySummary(
          id: 'family-email-sender-example-com',
          ownerUserId: 'email-sender-example-com',
          activeBabyId: 'baby-email-sender-example-com',
          createdAt: DateTime(2026, 1, 1),
          partnerEmails: const ['invitee@example.com'],
        ),
      );

      final ownerSnapshot = await repository.loadSnapshot();
      expect(
        ownerSnapshot.family!.partnerUserIds,
        isNot(contains('invitee@example.com')),
      );
      expect(ownerSnapshot.invites.single.status, FamilyInviteStatus.declined);
    },
  );

  test(
    'controller sends invite to Firebase before creating local success',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService();
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('sender@example.com', '123456');
      await controller.completeBabyOnboarding(
        parentName: 'Sender Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );
      remote.calls.clear();

      await controller.addFamilyPartner('invitee@example.com');

      expect(
        remote.calls,
        containsAllInOrder([
          'syncUser:sender@example.com',
          'syncFamily:family-email-sender-example-com',
          'syncBaby:baby-email-sender-example-com',
          'addFamilyPartner:family-email-sender-example-com:invitee@example.com',
        ]),
      );
      expect(
        controller.snapshot.invites.single.invitedEmail,
        'invitee@example.com',
      );
    },
  );

  test('controller accepts invite locally and through Firebase sync', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.addFamilyPartner('invitee@example.com');

    await controller.loginLocal('invitee@example.com', '123456');
    final invite = controller.snapshot.invites.single;
    remote.calls.clear();

    await controller.acceptFamilyInvite(invite.id);

    expect(remote.calls, contains('acceptFamilyInvite:${invite.id}'));
    expect(controller.snapshot.family?.id, 'family-email-sender-example-com');
    expect(
      controller.snapshot.family!.partnerUserIds,
      contains('invitee@example.com'),
    );
    expect(
      controller.snapshot.invites.single.status,
      FamilyInviteStatus.accepted,
    );
  });

  test('controller removes member locally and through Firebase sync', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.addFamilyPartner('invitee@example.com');

    await controller.loginLocal('invitee@example.com', '123456');
    final inviteId = controller.snapshot.invites.single.id;
    await controller.acceptFamilyInvite(inviteId);

    await controller.loginLocal('sender@example.com', '123456');
    remote.calls.clear();
    await controller.removeFamilyMember(inviteId);

    expect(remote.calls, contains('removeFamilyMember:$inviteId'));
    expect(
      controller.snapshot.family!.partnerUserIds,
      isNot(contains('invitee@example.com')),
    );
    expect(
      controller.snapshot.invites.single.status,
      FamilyInviteStatus.declined,
    );
  });

  test('controller can resend invite after member removal', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.addFamilyPartner('invitee@example.com');

    await controller.loginLocal('invitee@example.com', '123456');
    final inviteId = controller.snapshot.invites.single.id;
    await controller.acceptFamilyInvite(inviteId);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.removeFamilyMember(inviteId);
    expect(
      controller.snapshot.invites.single.status,
      FamilyInviteStatus.declined,
    );

    remote.calls.clear();
    await controller.addFamilyPartner('invitee@example.com');

    final resentInvite = controller.snapshot.invites.single;
    expect(resentInvite.status, FamilyInviteStatus.pending);
    expect(resentInvite.acceptedUserId, isNull);
    expect(resentInvite.respondedAt, isNull);
    expect(
      remote.calls,
      contains(
        'addFamilyPartner:family-email-sender-example-com:invitee@example.com',
      ),
    );
  });

  test(
    'controller does not create local invite when Firebase delivery fails',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()..failAddFamilyPartner = true;
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('sender@example.com', '123456');
      await controller.completeBabyOnboarding(
        parentName: 'Sender Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );

      await expectLater(
        controller.addFamilyPartner('invitee@example.com'),
        throwsA(isA<AppControllerException>()),
      );
      expect(controller.snapshot.invites, isEmpty);
    },
  );

  test('owner can update permissions for a single invited account', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.addFamilyPartner(
      'invitee@example.com',
      roleLabel: 'Görüntüleyici',
      permissions: FamilyPermissionSets.viewOnly,
    );

    final invite = controller.snapshot.invites.single;
    await controller.updateFamilyInvitePermissions(
      inviteId: invite.id,
      displayName: 'Gece Bakıcısı',
      roleLabel: 'Bakıcı',
      permissions: const [
        FamilyPermission.viewBaby,
        FamilyPermission.viewSleep,
        FamilyPermission.manageSleep,
      ],
    );

    final updated = controller.snapshot.invites.single;
    expect(updated.invitedDisplayName, 'Gece Bakıcısı');
    expect(updated.roleLabel, 'Bakıcı');
    expect(updated.permissions, contains(FamilyPermission.manageSleep));
    expect(updated.permissions, isNot(contains(FamilyPermission.addFeeding)));
    expect(
      remote.calls,
      contains('updateFamilyInvitePermissions:${invite.id}'),
    );
  });

  test(
    'accepted partner refresh sees shared family baby and tracker records',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()
        ..families = [
          RemoteFamilySummary(
            id: 'family-sender',
            ownerUserId: 'sender-uid',
            activeBabyId: 'baby-sender',
            createdAt: DateTime(2026, 1, 1),
            partnerEmails: const ['invitee@example.com'],
            babies: [
              RemoteBabySummary(
                id: 'baby-sender',
                familyId: 'family-sender',
                name: 'Aylin',
                birthDate: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
              ),
            ],
            records: [
              RemoteTrackerRecordSummary(
                id: 'record-shared',
                type: 'feeding',
                title: 'Biberon',
                familyId: 'family-sender',
                babyId: 'baby-sender',
                value: '90 ml',
                createdByUserId: 'sender-uid',
                createdByName: 'Sender Parent',
                occurredAt: DateTime(2026, 2, 1, 8),
                createdAt: DateTime(2026, 2, 1, 8),
                updatedAt: DateTime(2026, 2, 1, 8),
              ),
            ],
          ),
        ];
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.refreshRemoteFamilies();

      expect(controller.snapshot.family?.id, 'family-sender');
      expect(controller.snapshot.baby?.name, 'Aylin');
      expect(controller.snapshot.records.single.id, 'record-shared');
      expect(controller.snapshot.records.single.title, 'Biberon');
      expect(controller.snapshot.records.single.createdByName, 'Sender Parent');
    },
  );

  test(
    'accepted remote permissions keep camelCase names and allow member invites',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()
        ..families = [
          RemoteFamilySummary(
            id: 'family-shared',
            ownerUserId: 'sender-uid',
            activeBabyId: 'baby-shared',
            createdAt: DateTime(2026, 1, 1),
            partnerEmails: const ['invitee@example.com'],
            invites: [
              RemoteFamilyInvite(
                familyId: 'family-shared',
                invitedEmail: 'invitee@example.com',
                invitedByUserId: 'sender-uid',
                invitedByName: 'Sender Parent',
                ownerUserId: 'sender-uid',
                activeBabyId: 'baby-shared',
                permissions: const [
                  'viewBaby',
                  'viewNotifications',
                  'inviteUsers',
                  'manageUserPermissions',
                  'removeUsers',
                ],
                acceptedUserId: 'email-invitee-example-com',
                status: 'accepted',
                createdAt: DateTime(2026, 1, 1),
                respondedAt: DateTime(2026, 1, 2),
              ),
            ],
            babies: [
              RemoteBabySummary(
                id: 'baby-shared',
                familyId: 'family-shared',
                name: 'Aylin',
                birthDate: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
              ),
            ],
          ),
        ];
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.refreshRemoteFamilies(force: true);

      expect(controller.hasPermission(FamilyPermission.inviteUsers), isTrue);
      remote.calls.clear();

      await controller.addFamilyPartner('new-member@example.com');

      expect(remote.calls, contains('syncUser:invitee@example.com'));
      expect(remote.calls, isNot(contains('syncFamily:family-shared')));
      expect(
        remote.calls,
        contains('addFamilyPartner:family-shared:new-member@example.com'),
      );
    },
  );

  test(
    'accepted remote permissions allow only granted record actions',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()
        ..families = [
          RemoteFamilySummary(
            id: 'family-limited',
            ownerUserId: 'sender-uid',
            activeBabyId: 'baby-limited',
            createdAt: DateTime(2026, 1, 1),
            partnerEmails: const ['invitee@example.com'],
            invites: [
              RemoteFamilyInvite(
                familyId: 'family-limited',
                invitedEmail: 'invitee@example.com',
                invitedByUserId: 'sender-uid',
                invitedByName: 'Sender Parent',
                ownerUserId: 'sender-uid',
                activeBabyId: 'baby-limited',
                permissions: const ['viewBaby', 'viewDiaper', 'addDiaper'],
                acceptedUserId: 'email-invitee-example-com',
                status: 'accepted',
                createdAt: DateTime(2026, 1, 1),
                respondedAt: DateTime(2026, 1, 2),
              ),
            ],
            babies: [
              RemoteBabySummary(
                id: 'baby-limited',
                familyId: 'family-limited',
                name: 'Aylin',
                birthDate: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
              ),
            ],
          ),
        ];
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.refreshRemoteFamilies(force: true);

      expect(controller.hasPermission(FamilyPermission.addDiaper), isTrue);
      expect(controller.hasPermission(FamilyPermission.addFeeding), isFalse);

      await controller.addRecord(
        type: RecordType.diaper,
        title: 'Bez degisimi',
        value: 'Islak',
      );

      expect(remote.syncedRecords.last.type, RecordType.diaper);
      final syncedRecordCount = remote.syncedRecords.length;
      await expectLater(
        controller.addRecord(
          type: RecordType.feeding,
          title: 'Biberon',
          value: '90 ml',
        ),
        throwsA(isA<AppControllerException>()),
      );
      expect(remote.syncedRecords, hasLength(syncedRecordCount));
    },
  );

  test(
    'invitee with an existing local family switches to the shared family and writes into shared scope',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()
        ..families = [
          RemoteFamilySummary(
            id: 'family-sender',
            ownerUserId: 'sender-uid',
            activeBabyId: 'baby-sender',
            createdAt: DateTime(2026, 1, 1),
            partnerEmails: const ['invitee@example.com'],
            babies: [
              RemoteBabySummary(
                id: 'baby-sender',
                familyId: 'family-sender',
                name: 'Aylin',
                birthDate: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
              ),
            ],
          ),
        ];
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.completeBabyOnboarding(
        parentName: 'Invitee Parent',
        babyName: 'Kendi Bebeği',
        birthDate: DateTime(2026, 2, 1),
      );
      expect(
        controller.snapshot.family?.id,
        'family-email-invitee-example-com',
      );
      expect(controller.snapshot.baby?.name, 'Kendi Bebeği');

      await controller.refreshRemoteFamilies(force: true);

      expect(controller.snapshot.family?.id, 'family-sender');
      expect(controller.snapshot.baby?.id, 'baby-sender');
      expect(controller.snapshot.baby?.name, 'Aylin');

      await controller.addRecord(
        type: RecordType.diaper,
        title: 'Bez değişimi',
        value: 'Islak',
      );

      expect(remote.syncedRecords, isNotEmpty);
      expect(remote.syncedRecords.last.familyId, 'family-sender');
      expect(remote.syncedRecords.last.babyId, 'baby-sender');
    },
  );

  test('editing and deleting a shared record syncs to remote', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.addRecord(
      type: RecordType.diaper,
      title: 'Bez değişimi',
      value: 'Islak',
    );

    final record = controller.snapshot.records.firstWhere(
      (item) => item.title == 'Bez değişimi',
    );
    remote.calls.clear();

    await controller.updateRecord(
      record.copyWith(value: 'Kuru', note: 'Gece kontrolü'),
    );

    expect(
      remote.syncedRecords.last.copyWith(updatedAt: record.updatedAt).value,
      'Kuru',
    );
    expect(remote.syncedRecords.last.familyId, controller.snapshot.family?.id);

    remote.calls.clear();
    await controller.deleteRecord(record.id);

    expect(remote.calls, contains('deleteTrackerRecord:${record.id}'));
  });

  test('editing and deleting a shared reminder syncs to remote', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.addReminder(
      category: ReminderCategory.water,
      title: 'Su planı',
      time: DateTime(2026, 2, 1, 9),
      frequency: const ReminderPlan(
        type: ReminderPlanType.dailyTimes,
        times: [TimeOfDayValue(9, 0)],
      ).encode(),
    );

    final reminder = controller.snapshot.reminders.firstWhere(
      (item) => item.title == 'Su planı',
    );
    remote.calls.clear();

    await controller.updateReminder(
      reminder.copyWith(title: 'Su planı akşam', isActive: false),
    );

    expect(
      remote.calls,
      contains('syncReminder:${reminder.id}:${controller.snapshot.family?.id}'),
    );

    remote.calls.clear();
    await controller.deleteReminder(reminder.id);

    expect(remote.calls, contains('deleteReminder:${reminder.id}'));
  });

  test(
    'active reminder schedules local notifications on this device',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final notifications = InMemoryNotificationService();
      final controller = AppController(
        repository,
        syncService: _FakeRemoteSyncService(),
        notificationService: notifications,
      );

      await controller.loginLocal('sender@example.com', '123456');
      await controller.updateNotificationPreferences(
        notificationsEnabled: true,
        healthEnabled: true,
        familyEnabled: true,
        reminderEnabled: true,
        sound: 'gentle_bell',
      );
      await controller.completeBabyOnboarding(
        parentName: 'Sender Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );

      await controller.addReminder(
        category: ReminderCategory.water,
        title: 'Su molası',
        time: DateTime(2026, 2, 1, 9),
        frequency: const ReminderPlan(
          type: ReminderPlanType.dailyTimes,
          times: [TimeOfDayValue(9, 0), TimeOfDayValue(15, 0)],
        ).encode(),
      );

      expect(notifications.scheduled, isNotEmpty);
      expect(notifications.scheduled.values.first.sound, 'gentle_bell');

      final reminder = controller.snapshot.reminders.firstWhere(
        (item) => item.title == 'Su molası',
      );
      await controller.updateReminder(reminder.copyWith(isActive: false));

      expect(notifications.scheduled, isEmpty);
    },
  );

  test('device calendar sync stores and clears reminder event ids', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final calendar = _FakeCalendarSyncService();
    final controller = AppController(
      repository,
      syncService: _FakeRemoteSyncService(),
      calendarSyncService: calendar,
    );

    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );
    await controller.setDeviceCalendarSyncEnabled(true);

    await controller.addReminder(
      category: ReminderCategory.water,
      title: 'Su molası',
      time: DateTime(2026, 2, 1, 9),
      frequency: const ReminderPlan(
        type: ReminderPlanType.dailyTimes,
        times: [TimeOfDayValue(9, 0)],
      ).encode(),
    );

    final reminder = controller.snapshot.reminders.firstWhere(
      (item) => item.title == 'Su molası',
    );
    expect(calendar.syncedReminderIds, [reminder.id]);
    expect(await repository.calendarEventIdsForReminder(reminder.id), [
      'calendar-0',
    ]);

    await controller.updateReminder(reminder.copyWith(isActive: false));

    expect(calendar.replacedExistingEventIds.last, ['calendar-0']);
    expect(await repository.calendarEventIdsForReminder(reminder.id), isEmpty);
  });

  test(
    'partner record refresh creates in-app and device notification',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService();
      final notifications = InMemoryNotificationService();
      final controller = AppController(
        repository,
        syncService: remote,
        notificationService: notifications,
      );

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.updateNotificationPreferences(
        notificationsEnabled: true,
        healthEnabled: true,
        familyEnabled: true,
        reminderEnabled: true,
        sound: 'gentle_bell',
      );
      remote.families = [
        RemoteFamilySummary(
          id: 'family-sender',
          ownerUserId: 'sender-uid',
          createdAt: DateTime(2026, 1, 1),
          partnerEmails: const ['invitee@example.com'],
          records: [
            RemoteTrackerRecordSummary(
              id: 'record-partner-action',
              type: 'feeding',
              title: 'Biberon',
              familyId: 'family-sender',
              value: '120 ml',
              createdByUserId: 'sender-uid',
              createdByName: 'Sender Parent',
              occurredAt: DateTime(2026, 2, 1, 8),
              createdAt: DateTime(2026, 2, 1, 8),
              updatedAt: DateTime(2026, 2, 1, 8),
            ),
          ],
        ),
      ];

      await controller.refreshRemoteFamilies();

      final familyNotifications = controller.snapshot.notifications.where(
        (item) => item.type == 'family_record',
      );
      expect(familyNotifications, hasLength(1));
      expect(familyNotifications.single.body, contains('Sender Parent'));
      expect(notifications.shown, hasLength(1));
      expect(notifications.shown.values.single.sound, 'gentle_bell');
      expect(notifications.shown.values.single.title, 'Yeni aile kaydı');

      await controller.refreshRemoteFamilies();

      expect(
        controller.snapshot.notifications.where(
          (item) => item.type == 'family_record',
        ),
        hasLength(1),
      );
      expect(notifications.shown, hasLength(1));
    },
  );

  test('pending invite refresh can create a device notification', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final notifications = InMemoryNotificationService();
    final controller = AppController(
      repository,
      syncService: remote,
      notificationService: notifications,
    );

    await controller.loginLocal('invitee@example.com', '123456');
    remote.pendingInvites = [
      RemoteFamilyInvite(
        familyId: 'family-sender',
        invitedEmail: 'invitee@example.com',
        invitedByUserId: 'sender-uid',
        invitedByName: 'Sender Parent',
        ownerUserId: 'sender-uid',
        createdAt: DateTime(2026, 2, 1, 8),
      ),
    ];

    await controller.refreshFamilyInvites(force: true);

    final inviteNotifications = controller.snapshot.notifications.where(
      (item) => item.type == 'family_invite',
    );
    expect(inviteNotifications, hasLength(1));
    expect(inviteNotifications.single.body, contains('Sender Parent'));
    expect(notifications.shown, hasLength(1));
    expect(notifications.shown.values.single.title, 'Aile daveti');
  });

  test(
    'family notification preference keeps in-app notices but mutes device alerts',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService();
      final notifications = InMemoryNotificationService();
      final controller = AppController(
        repository,
        syncService: remote,
        notificationService: notifications,
      );

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.updateNotificationPreferences(
        notificationsEnabled: true,
        healthEnabled: true,
        familyEnabled: false,
        reminderEnabled: true,
        sound: 'soft_chime',
      );
      remote.families = [
        RemoteFamilySummary(
          id: 'family-sender',
          ownerUserId: 'sender-uid',
          createdAt: DateTime(2026, 1, 1),
          partnerEmails: const ['invitee@example.com'],
          records: [
            RemoteTrackerRecordSummary(
              id: 'record-muted-family',
              type: 'feeding',
              title: 'Biberon',
              familyId: 'family-sender',
              value: '120 ml',
              createdByUserId: 'sender-uid',
              createdByName: 'Sender Parent',
              occurredAt: DateTime(2026, 2, 1, 8),
              createdAt: DateTime(2026, 2, 1, 8),
              updatedAt: DateTime(2026, 2, 1, 8),
            ),
          ],
        ),
      ];

      await controller.refreshRemoteFamilies(force: true);

      expect(
        controller.snapshot.notifications.where(
          (item) => item.type == 'family_record',
        ),
        hasLength(1),
      );
      expect(notifications.shown, isEmpty);
    },
  );

  test(
    'sender refresh marks sent invite accepted after partner accepts remotely',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService();
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('sender@example.com', '123456');
      await controller.completeBabyOnboarding(
        parentName: 'Sender Parent',
        babyName: 'Aylin',
        birthDate: DateTime(2026, 1, 1),
      );
      await controller.addFamilyPartner('invitee@example.com');
      expect(
        controller.snapshot.invites.single.status,
        FamilyInviteStatus.pending,
      );

      remote.families = [
        RemoteFamilySummary(
          id: controller.snapshot.family!.id,
          ownerUserId: controller.snapshot.user!.id,
          activeBabyId: controller.snapshot.baby!.id,
          createdAt: controller.snapshot.family!.createdAt,
          partnerEmails: const ['invitee@example.com'],
        ),
      ];

      await controller.refreshRemoteFamilies();

      expect(
        controller.snapshot.invites.single.status,
        FamilyInviteStatus.accepted,
      );
      expect(
        controller.snapshot.family!.partnerUserIds,
        contains('invitee@example.com'),
      );
    },
  );

  test(
    'live family stream updates shared records without manual refresh',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()
        ..families = [
          RemoteFamilySummary(
            id: 'family-live',
            ownerUserId: 'sender-uid',
            activeBabyId: 'baby-live',
            createdAt: DateTime(2026, 1, 1),
            partnerEmails: const ['invitee@example.com'],
            babies: [
              RemoteBabySummary(
                id: 'baby-live',
                familyId: 'family-live',
                name: 'Aylin',
                birthDate: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
              ),
            ],
          ),
        ];
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('invitee@example.com', '123456');
      expect(controller.snapshot.records, isEmpty);
      expect(remote.calls, contains('watchFamily:family-live'));

      remote.familyStreams['family-live']!.add(
        RemoteFamilySummary(
          id: 'family-live',
          ownerUserId: 'sender-uid',
          activeBabyId: 'baby-live',
          createdAt: DateTime(2026, 1, 1),
          partnerEmails: const ['invitee@example.com'],
          babies: [
            RemoteBabySummary(
              id: 'baby-live',
              familyId: 'family-live',
              name: 'Aylin',
              birthDate: DateTime(2026, 1, 1),
              createdAt: DateTime(2026, 1, 1),
            ),
          ],
          records: [
            RemoteTrackerRecordSummary(
              id: 'record-live-diaper',
              type: 'diaper',
              title: 'Bez değişimi',
              familyId: 'family-live',
              babyId: 'baby-live',
              value: 'Islak',
              createdByUserId: 'sender-uid',
              createdByName: 'Anne',
              updatedByUserId: 'sender-uid',
              updatedByName: 'Anne',
              occurredAt: DateTime(2026, 2, 1, 9),
              createdAt: DateTime(2026, 2, 1, 9),
              updatedAt: DateTime(2026, 2, 1, 9),
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(controller.snapshot.records.single.id, 'record-live-diaper');
      expect(controller.snapshot.records.single.createdByName, 'Anne');
    },
  );

  test(
    'live family stream removes tombstoned shared record and reminder',
    () async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      final repository = AppRepository(database);
      await repository.seedContent();
      final remote = _FakeRemoteSyncService()
        ..families = [
          RemoteFamilySummary(
            id: 'family-live',
            ownerUserId: 'sender-uid',
            activeBabyId: 'baby-live',
            createdAt: DateTime(2026, 1, 1),
            partnerEmails: const ['invitee@example.com'],
            babies: [
              RemoteBabySummary(
                id: 'baby-live',
                familyId: 'family-live',
                name: 'Aylin',
                birthDate: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
              ),
            ],
            records: [
              RemoteTrackerRecordSummary(
                id: 'record-live-diaper',
                type: 'diaper',
                title: 'Bez değişimi',
                familyId: 'family-live',
                babyId: 'baby-live',
                value: 'Islak',
                createdByUserId: 'sender-uid',
                createdByName: 'Anne',
                occurredAt: DateTime(2026, 2, 1, 9),
                createdAt: DateTime(2026, 2, 1, 9),
                updatedAt: DateTime(2026, 2, 1, 9),
              ),
            ],
            reminders: [
              RemoteReminderSummary(
                id: 'reminder-live-water',
                title: 'Su hedefi',
                category: 'water',
                time: DateTime(2026, 2, 1, 9),
                frequency: const ReminderPlan(
                  type: ReminderPlanType.dailyTimes,
                  times: [TimeOfDayValue(9, 0)],
                ).encode(),
                isActive: true,
                familyId: 'family-live',
                createdAt: DateTime(2026, 2, 1, 8),
              ),
            ],
          ),
        ];
      final controller = AppController(repository, syncService: remote);

      await controller.loginLocal('invitee@example.com', '123456');
      await controller.refreshRemoteFamilies(force: true);

      expect(controller.snapshot.records, hasLength(1));
      expect(controller.snapshot.reminders, hasLength(1));

      remote.familyStreams['family-live']!.add(
        RemoteFamilySummary(
          id: 'family-live',
          ownerUserId: 'sender-uid',
          activeBabyId: 'baby-live',
          createdAt: DateTime(2026, 1, 1),
          partnerEmails: const ['invitee@example.com'],
          babies: [
            RemoteBabySummary(
              id: 'baby-live',
              familyId: 'family-live',
              name: 'Aylin',
              birthDate: DateTime(2026, 1, 1),
              createdAt: DateTime(2026, 1, 1),
            ),
          ],
          records: [
            RemoteTrackerRecordSummary(
              id: 'record-live-diaper',
              type: 'diaper',
              title: 'Bez değişimi',
              familyId: 'family-live',
              babyId: 'baby-live',
              value: 'Islak',
              createdByUserId: 'sender-uid',
              createdByName: 'Anne',
              occurredAt: DateTime(2026, 2, 1, 9),
              createdAt: DateTime(2026, 2, 1, 9),
              updatedAt: DateTime(2026, 2, 1, 10),
              deletedAt: DateTime(2026, 2, 1, 10),
            ),
          ],
          reminders: [
            RemoteReminderSummary(
              id: 'reminder-live-water',
              title: 'Su hedefi',
              category: 'water',
              time: DateTime(2026, 2, 1, 9),
              frequency: const ReminderPlan(
                type: ReminderPlanType.dailyTimes,
                times: [TimeOfDayValue(9, 0)],
              ).encode(),
              isActive: false,
              familyId: 'family-live',
              createdAt: DateTime(2026, 2, 1, 8),
              updatedAt: DateTime(2026, 2, 1, 10),
              deletedAt: DateTime(2026, 2, 1, 10),
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(controller.snapshot.records, isEmpty);
      expect(controller.snapshot.reminders, isEmpty);
    },
  );

  test('completed vaccine syncs the updated vaccine status', () async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = AppRepository(database);
    await repository.seedContent();
    final remote = _FakeRemoteSyncService();
    final controller = AppController(repository, syncService: remote);
    await controller.loginLocal('sender@example.com', '123456');
    await controller.completeBabyOnboarding(
      parentName: 'Sender Parent',
      babyName: 'Aylin',
      birthDate: DateTime(2026, 1, 1),
    );

    final vaccine = controller.snapshot.vaccines.first;
    await controller.completeVaccine(vaccine.id, true);

    expect(remote.syncedVaccines.last.id, vaccine.id);
    expect(remote.syncedVaccines.last.status, VaccineStatus.completed);
    expect(remote.syncedVaccines.last.completedAt, isNotNull);
  });
}

class _FakeCalendarSyncService implements CalendarSyncService {
  final syncedReminderIds = <String>[];
  final replacedExistingEventIds = <List<String>>[];
  var _nextId = 0;

  @override
  Future<bool> requestAccess() async => true;

  @override
  Future<List<String>> replaceReminderEvents(
    ReminderItem reminder, {
    required Iterable<String> existingEventIds,
  }) async {
    syncedReminderIds.add(reminder.id);
    replacedExistingEventIds.add(existingEventIds.toList());
    if (!reminder.isActive) return const [];
    return ['calendar-${_nextId++}'];
  }

  @override
  Future<void> deleteReminderEvents(Iterable<String> eventIds) async {
    replacedExistingEventIds.add(eventIds.toList());
  }
}

class _FakeRemoteSyncService implements RemoteSyncService {
  final calls = <String>[];
  final syncedRecords = <TrackerRecord>[];
  final syncedVaccines = <VaccineEvent>[];
  List<RemoteFamilySummary> families = const [];
  List<RemoteFamilyInvite> pendingInvites = const [];
  final familyStreams = <String, StreamController<RemoteFamilySummary>>{};
  bool failAddFamilyPartner = false;

  @override
  bool get isEnabled => true;

  @override
  Future<void> syncUser(UserProfile user) async {
    calls.add('syncUser:${user.email}');
  }

  @override
  Future<void> syncFamily(Family family) async {
    calls.add('syncFamily:${family.id}');
  }

  @override
  Future<void> syncBaby(BabyProfile baby) async {
    calls.add('syncBaby:${baby.id}');
  }

  @override
  Future<void> syncPregnancy(PregnancyProfile pregnancy) async {
    calls.add('syncPregnancy:${pregnancy.id}');
  }

  @override
  Future<void> syncTrackerRecord(TrackerRecord record) async {
    calls.add('syncTrackerRecord:${record.id}');
    syncedRecords.add(record);
  }

  @override
  Future<void> deleteTrackerRecord(String recordId) async {
    calls.add('deleteTrackerRecord:$recordId');
  }

  @override
  Future<void> syncReminder(
    ReminderItem reminder, {
    required String familyId,
    String? createdByName,
  }) async {
    calls.add('syncReminder:${reminder.id}:$familyId');
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    calls.add('deleteReminder:$reminderId');
  }

  @override
  Future<void> syncVaccineEvent(
    VaccineEvent vaccine, {
    String? updatedByName,
  }) async {
    calls.add('syncVaccineEvent:${vaccine.id}');
    syncedVaccines.add(vaccine);
  }

  @override
  Future<void> addFamilyPartner({
    required String familyId,
    required String familyOwnerUserId,
    required String email,
    required String invitedByName,
    String? invitedDisplayName,
    String? roleLabel,
    List<FamilyPermission> permissions = const [],
  }) async {
    calls.add('addFamilyPartner:$familyId:$email');
    if (failAddFamilyPartner) throw StateError('remote failed');
  }

  @override
  Future<void> updateFamilyInvitePermissions({
    required FamilyInvite invite,
    String? invitedDisplayName,
    String? roleLabel,
    required List<FamilyPermission> permissions,
  }) async {
    calls.add('updateFamilyInvitePermissions:${invite.id}');
  }

  @override
  Future<void> removeFamilyMember(FamilyInvite invite) async {
    calls.add('removeFamilyMember:${invite.id}');
  }

  @override
  Future<void> acceptFamilyInvite(FamilyInvite invite) async {
    calls.add('acceptFamilyInvite:${invite.id}');
  }

  @override
  Future<void> declineFamilyInvite(FamilyInvite invite) async {
    calls.add('declineFamilyInvite:${invite.id}');
  }

  @override
  Future<List<RemoteFamilyInvite>> fetchPendingFamilyInvites(
    String email,
  ) async {
    calls.add('fetchPendingFamilyInvites:$email');
    return pendingInvites;
  }

  @override
  Future<List<RemoteFamilySummary>> fetchMyFamilies() async {
    calls.add('fetchMyFamilies');
    return families;
  }

  @override
  Future<List<RemoteTrackerRecordSummary>> fetchFamilyTrackerRecords(
    String familyId, {
    int limit = 60,
  }) async {
    calls.add('fetchFamilyTrackerRecords:$familyId:$limit');
    final family = families
        .where((summary) => summary.id == familyId)
        .cast<RemoteFamilySummary?>()
        .firstWhere((summary) => summary != null, orElse: () => null);
    return family?.records.take(limit).toList() ?? const [];
  }

  @override
  Stream<RemoteFamilySummary> watchFamily(String familyId) {
    calls.add('watchFamily:$familyId');
    return familyStreams
        .putIfAbsent(
          familyId,
          () => StreamController<RemoteFamilySummary>.broadcast(),
        )
        .stream;
  }

  @override
  Future<void> syncNotificationToken({
    required String token,
    required String platform,
    String? familyId,
    required bool notificationsEnabled,
  }) async {
    calls.add('syncNotificationToken:$platform:$familyId');
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    calls.add('markNotificationRead:$notificationId');
  }
}
