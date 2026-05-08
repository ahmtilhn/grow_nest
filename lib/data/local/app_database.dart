import 'package:drift/drift.dart';

import 'database_connection.dart';

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  BoolColumn get emailVerified =>
      boolean().withDefault(const Constant(false))();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('tr'))();
  TextColumn get theme => text().withDefault(const Constant('light'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SettingsRows extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class Families extends Table {
  TextColumn get id => text()();
  TextColumn get ownerUserId => text()();
  TextColumn get partnerUserIds => text().withDefault(const Constant('[]'))();
  TextColumn get activeBabyId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Babies extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get gender => text().nullable()();
  RealColumn get birthWeight => real().nullable()();
  RealColumn get birthHeight => real().nullable()();
  RealColumn get birthHeadCircumference => real().nullable()();
  RealColumn get currentWeight => real().nullable()();
  RealColumn get currentHeight => real().nullable()();
  RealColumn get currentHeadCircumference => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Pregnancies extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get birthCompletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class TrackerRecords extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get familyId => text().nullable()();
  TextColumn get babyId => text().nullable()();
  TextColumn get value => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get createdByUserId => text().nullable()();
  TextColumn get createdByName => text().nullable()();
  TextColumn get updatedByUserId => text().nullable()();
  TextColumn get updatedByName => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  DateTimeColumn get time => dateTime()();
  TextColumn get frequency => text().withDefault(const Constant('daily'))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get ownerUserId => text().nullable()();
  TextColumn get familyId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().nullable()();
  TextColumn get targetUserIds => text().withDefault(const Constant('[]'))();
  TextColumn get createdBy => text().nullable()();
  TextColumn get type => text()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get payload => text().nullable()();
  TextColumn get readBy => text().withDefault(const Constant('[]'))();
  TextColumn get seenBy => text().withDefault(const Constant('[]'))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('unread'))();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FamilyInvites extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text()();
  TextColumn get invitedEmail => text()();
  TextColumn get invitedByUserId => text()();
  TextColumn get invitedByName => text()();
  TextColumn get invitedDisplayName => text().nullable()();
  TextColumn get roleLabel => text().nullable()();
  TextColumn get permissionsJson => text().withDefault(const Constant('[]'))();
  TextColumn get acceptedUserId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get respondedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class VaccineEvents extends Table {
  TextColumn get id => text()();
  TextColumn get babyId => text()();
  TextColumn get title => text()();
  TextColumn get dose => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text().withDefault(const Constant('upcoming'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Articles extends Table {
  TextColumn get id => text()();
  TextColumn get careMode => text().withDefault(const Constant('baby'))();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get summary => text()();
  TextColumn get content => text()();
  IntColumn get readingMinutes => integer()();
  TextColumn get sourceName => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get medicalDisclaimer => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SavedArticles extends Table {
  TextColumn get articleId => text()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {articleId};
}

class SyncQueueItems extends Table {
  TextColumn get id => text()();
  TextColumn get entityKind => text()();
  TextColumn get entityId => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Users,
    SettingsRows,
    Families,
    Babies,
    Pregnancies,
    TrackerRecords,
    Reminders,
    AppNotifications,
    FamilyInvites,
    VaccineEvents,
    Articles,
    SavedArticles,
    SyncQueueItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.open() {
    return AppDatabase(openDatabaseConnection());
  }

  factory AppDatabase.inMemory() {
    return AppDatabase(openInMemoryDatabaseConnection());
  }

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(articles, articles.careMode);
      }
      if (from < 3) {
        await m.addColumn(users, users.birthDate);
        await m.addColumn(users, users.phone);
        await m.addColumn(users, users.role);
        await m.createTable(appNotifications);
        await m.createTable(familyInvites);
        await m.createTable(vaccineEvents);
      }
      if (from < 4) {
        await m.addColumn(reminders, reminders.ownerUserId);
        await m.addColumn(reminders, reminders.familyId);
        await m.addColumn(appNotifications, appNotifications.userId);
        await m.addColumn(appNotifications, appNotifications.familyId);
      }
      if (from < 5) {
        await m.addColumn(trackerRecords, trackerRecords.createdByName);
      }
      if (from < 6) {
        await m.addColumn(trackerRecords, trackerRecords.updatedByUserId);
        await m.addColumn(trackerRecords, trackerRecords.updatedByName);
      }
      if (from < 7) {
        await m.addColumn(users, users.emailVerified);
      }
      if (from >= 4 && from < 8) {
        await m.addColumn(appNotifications, appNotifications.targetUserIds);
        await m.addColumn(appNotifications, appNotifications.createdBy);
        await m.addColumn(appNotifications, appNotifications.readBy);
        await m.addColumn(appNotifications, appNotifications.seenBy);
        await m.addColumn(appNotifications, appNotifications.isDeleted);
      }
      if (from >= 3 && from < 8) {
        await m.addColumn(familyInvites, familyInvites.invitedDisplayName);
        await m.addColumn(familyInvites, familyInvites.roleLabel);
        await m.addColumn(familyInvites, familyInvites.permissionsJson);
        await m.addColumn(familyInvites, familyInvites.acceptedUserId);
      }
    },
  );
}
