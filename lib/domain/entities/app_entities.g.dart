// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  emailVerified: json['emailVerified'] as bool? ?? false,
  avatarUrl: json['avatarUrl'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  phone: json['phone'] as String?,
  role: json['role'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  language: json['language'] as String? ?? 'tr',
  theme: json['theme'] as String? ?? 'light',
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'avatarUrl': instance.avatarUrl,
      'birthDate': instance.birthDate?.toIso8601String(),
      'phone': instance.phone,
      'role': instance.role,
      'createdAt': instance.createdAt.toIso8601String(),
      'language': instance.language,
      'theme': instance.theme,
    };

_Family _$FamilyFromJson(Map<String, dynamic> json) => _Family(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  partnerUserIds:
      (json['partnerUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  activeBabyId: json['activeBabyId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$FamilyToJson(_Family instance) => <String, dynamic>{
  'id': instance.id,
  'ownerUserId': instance.ownerUserId,
  'partnerUserIds': instance.partnerUserIds,
  'activeBabyId': instance.activeBabyId,
  'createdAt': instance.createdAt.toIso8601String(),
};

_BabyProfile _$BabyProfileFromJson(Map<String, dynamic> json) => _BabyProfile(
  id: json['id'] as String,
  familyId: json['familyId'] as String,
  name: json['name'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
  gender: json['gender'] as String?,
  birthWeight: (json['birthWeight'] as num?)?.toDouble(),
  birthHeight: (json['birthHeight'] as num?)?.toDouble(),
  birthHeadCircumference: (json['birthHeadCircumference'] as num?)?.toDouble(),
  currentWeight: (json['currentWeight'] as num?)?.toDouble(),
  currentHeight: (json['currentHeight'] as num?)?.toDouble(),
  currentHeadCircumference: (json['currentHeadCircumference'] as num?)
      ?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BabyProfileToJson(_BabyProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'name': instance.name,
      'birthDate': instance.birthDate.toIso8601String(),
      'gender': instance.gender,
      'birthWeight': instance.birthWeight,
      'birthHeight': instance.birthHeight,
      'birthHeadCircumference': instance.birthHeadCircumference,
      'currentWeight': instance.currentWeight,
      'currentHeight': instance.currentHeight,
      'currentHeadCircumference': instance.currentHeadCircumference,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_PregnancyProfile _$PregnancyProfileFromJson(Map<String, dynamic> json) =>
    _PregnancyProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
      birthCompletedAt: json['birthCompletedAt'] == null
          ? null
          : DateTime.parse(json['birthCompletedAt'] as String),
    );

Map<String, dynamic> _$PregnancyProfileToJson(_PregnancyProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startDate': instance.startDate.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'status': instance.status,
      'birthCompletedAt': instance.birthCompletedAt?.toIso8601String(),
    };

_TrackerRecord _$TrackerRecordFromJson(Map<String, dynamic> json) =>
    _TrackerRecord(
      id: json['id'] as String,
      type: $enumDecode(_$RecordTypeEnumMap, json['type']),
      title: json['title'] as String,
      familyId: json['familyId'] as String?,
      babyId: json['babyId'] as String?,
      value: json['value'] as String?,
      note: json['note'] as String?,
      createdByUserId: json['createdByUserId'] as String?,
      createdByName: json['createdByName'] as String?,
      updatedByUserId: json['updatedByUserId'] as String?,
      updatedByName: json['updatedByName'] as String?,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
          SyncStatus.pending,
    );

Map<String, dynamic> _$TrackerRecordToJson(_TrackerRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$RecordTypeEnumMap[instance.type]!,
      'title': instance.title,
      'familyId': instance.familyId,
      'babyId': instance.babyId,
      'value': instance.value,
      'note': instance.note,
      'createdByUserId': instance.createdByUserId,
      'createdByName': instance.createdByName,
      'updatedByUserId': instance.updatedByUserId,
      'updatedByName': instance.updatedByName,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$RecordTypeEnumMap = {
  RecordType.feeding: 'feeding',
  RecordType.diaper: 'diaper',
  RecordType.sleep: 'sleep',
  RecordType.growth: 'growth',
  RecordType.health: 'health',
  RecordType.solidFood: 'solidFood',
  RecordType.milkStock: 'milkStock',
  RecordType.memory: 'memory',
  RecordType.water: 'water',
  RecordType.vitamin: 'vitamin',
  RecordType.appointment: 'appointment',
  RecordType.reminder: 'reminder',
};

const _$SyncStatusEnumMap = {
  SyncStatus.localOnly: 'localOnly',
  SyncStatus.pending: 'pending',
  SyncStatus.synced: 'synced',
  SyncStatus.failed: 'failed',
  SyncStatus.conflict: 'conflict',
};

_ReminderItem _$ReminderItemFromJson(Map<String, dynamic> json) =>
    _ReminderItem(
      id: json['id'] as String,
      title: json['title'] as String,
      category: $enumDecode(_$ReminderCategoryEnumMap, json['category']),
      time: DateTime.parse(json['time'] as String),
      frequency: json['frequency'] as String? ?? 'daily',
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReminderItemToJson(_ReminderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$ReminderCategoryEnumMap[instance.category]!,
      'time': instance.time.toIso8601String(),
      'frequency': instance.frequency,
      'notes': instance.notes,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ReminderCategoryEnumMap = {
  ReminderCategory.health: 'health',
  ReminderCategory.water: 'water',
  ReminderCategory.feeding: 'feeding',
  ReminderCategory.vaccine: 'vaccine',
  ReminderCategory.appointment: 'appointment',
  ReminderCategory.vitamin: 'vitamin',
  ReminderCategory.medicine: 'medicine',
  ReminderCategory.sleep: 'sleep',
  ReminderCategory.diaper: 'diaper',
  ReminderCategory.custom: 'custom',
};

_AppNotification _$AppNotificationFromJson(
  Map<String, dynamic> json,
) => _AppNotification(
  id: json['id'] as String,
  familyId: json['familyId'] as String?,
  targetUserIds:
      (json['targetUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdBy: json['createdBy'] as String?,
  type: json['type'] as String,
  category: json['category'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  payload: json['payload'] as String?,
  readBy:
      (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  seenBy:
      (json['seenBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isDeleted: json['isDeleted'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$AppNotificationStatusEnumMap, json['status']) ??
      AppNotificationStatus.unread,
  createdAt: DateTime.parse(json['createdAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
);

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'targetUserIds': instance.targetUserIds,
      'createdBy': instance.createdBy,
      'type': instance.type,
      'category': instance.category,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
      'readBy': instance.readBy,
      'seenBy': instance.seenBy,
      'isDeleted': instance.isDeleted,
      'status': _$AppNotificationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };

const _$AppNotificationStatusEnumMap = {
  AppNotificationStatus.unread: 'unread',
  AppNotificationStatus.read: 'read',
  AppNotificationStatus.accepted: 'accepted',
  AppNotificationStatus.declined: 'declined',
};

_FamilyInvite _$FamilyInviteFromJson(Map<String, dynamic> json) =>
    _FamilyInvite(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      invitedEmail: json['invitedEmail'] as String,
      invitedByUserId: json['invitedByUserId'] as String,
      invitedByName: json['invitedByName'] as String,
      invitedDisplayName: json['invitedDisplayName'] as String?,
      roleLabel: json['roleLabel'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$FamilyPermissionEnumMap, e))
              .toList() ??
          const [],
      acceptedUserId: json['acceptedUserId'] as String?,
      status:
          $enumDecodeNullable(_$FamilyInviteStatusEnumMap, json['status']) ??
          FamilyInviteStatus.pending,
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$FamilyInviteToJson(_FamilyInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'invitedEmail': instance.invitedEmail,
      'invitedByUserId': instance.invitedByUserId,
      'invitedByName': instance.invitedByName,
      'invitedDisplayName': instance.invitedDisplayName,
      'roleLabel': instance.roleLabel,
      'permissions': instance.permissions
          .map((e) => _$FamilyPermissionEnumMap[e]!)
          .toList(),
      'acceptedUserId': instance.acceptedUserId,
      'status': _$FamilyInviteStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };

const _$FamilyPermissionEnumMap = {
  FamilyPermission.viewBaby: 'viewBaby',
  FamilyPermission.viewFeeding: 'viewFeeding',
  FamilyPermission.viewDiaper: 'viewDiaper',
  FamilyPermission.viewSleep: 'viewSleep',
  FamilyPermission.viewVaccines: 'viewVaccines',
  FamilyPermission.viewAppointments: 'viewAppointments',
  FamilyPermission.viewMemories: 'viewMemories',
  FamilyPermission.viewNotifications: 'viewNotifications',
  FamilyPermission.viewStats: 'viewStats',
  FamilyPermission.addFeeding: 'addFeeding',
  FamilyPermission.addDiaper: 'addDiaper',
  FamilyPermission.manageSleep: 'manageSleep',
  FamilyPermission.addGrowth: 'addGrowth',
  FamilyPermission.addVaccine: 'addVaccine',
  FamilyPermission.addAppointment: 'addAppointment',
  FamilyPermission.addMemory: 'addMemory',
  FamilyPermission.saveArticle: 'saveArticle',
  FamilyPermission.editRecords: 'editRecords',
  FamilyPermission.deleteRecords: 'deleteRecords',
  FamilyPermission.inviteUsers: 'inviteUsers',
  FamilyPermission.manageUserPermissions: 'manageUserPermissions',
  FamilyPermission.removeUsers: 'removeUsers',
  FamilyPermission.editFamily: 'editFamily',
  FamilyPermission.editBaby: 'editBaby',
  FamilyPermission.deleteFamilyData: 'deleteFamilyData',
};

const _$FamilyInviteStatusEnumMap = {
  FamilyInviteStatus.pending: 'pending',
  FamilyInviteStatus.accepted: 'accepted',
  FamilyInviteStatus.declined: 'declined',
};

_VaccineEvent _$VaccineEventFromJson(Map<String, dynamic> json) =>
    _VaccineEvent(
      id: json['id'] as String,
      babyId: json['babyId'] as String,
      title: json['title'] as String,
      dose: json['dose'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      status:
          $enumDecodeNullable(_$VaccineStatusEnumMap, json['status']) ??
          VaccineStatus.upcoming,
      notes: json['notes'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VaccineEventToJson(_VaccineEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'babyId': instance.babyId,
      'title': instance.title,
      'dose': instance.dose,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$VaccineStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$VaccineStatusEnumMap = {
  VaccineStatus.upcoming: 'upcoming',
  VaccineStatus.completed: 'completed',
  VaccineStatus.overdue: 'overdue',
};

_Article _$ArticleFromJson(Map<String, dynamic> json) => _Article(
  id: json['id'] as String,
  careMode: json['careMode'] as String? ?? 'baby',
  title: json['title'] as String,
  category: json['category'] as String,
  summary: json['summary'] as String,
  content: json['content'] as String,
  readingMinutes: (json['readingMinutes'] as num).toInt(),
  sourceName: json['sourceName'] as String,
  sourceUrl: json['sourceUrl'] as String,
  medicalDisclaimer: json['medicalDisclaimer'] as String,
  isSaved: json['isSaved'] as bool? ?? false,
);

Map<String, dynamic> _$ArticleToJson(_Article instance) => <String, dynamic>{
  'id': instance.id,
  'careMode': instance.careMode,
  'title': instance.title,
  'category': instance.category,
  'summary': instance.summary,
  'content': instance.content,
  'readingMinutes': instance.readingMinutes,
  'sourceName': instance.sourceName,
  'sourceUrl': instance.sourceUrl,
  'medicalDisclaimer': instance.medicalDisclaimer,
  'isSaved': instance.isSaved,
};

_AppSnapshot _$AppSnapshotFromJson(Map<String, dynamic> json) => _AppSnapshot(
  user: json['user'] == null
      ? null
      : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
  family: json['family'] == null
      ? null
      : Family.fromJson(json['family'] as Map<String, dynamic>),
  baby: json['baby'] == null
      ? null
      : BabyProfile.fromJson(json['baby'] as Map<String, dynamic>),
  pregnancy: json['pregnancy'] == null
      ? null
      : PregnancyProfile.fromJson(json['pregnancy'] as Map<String, dynamic>),
  mode:
      $enumDecodeNullable(_$CareModeEnumMap, json['mode']) ??
      CareMode.pregnancy,
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => TrackerRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reminders:
      (json['reminders'] as List<dynamic>?)
          ?.map((e) => ReminderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notifications:
      (json['notifications'] as List<dynamic>?)
          ?.map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  invites:
      (json['invites'] as List<dynamic>?)
          ?.map((e) => FamilyInvite.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  vaccines:
      (json['vaccines'] as List<dynamic>?)
          ?.map((e) => VaccineEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  articles:
      (json['articles'] as List<dynamic>?)
          ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  onboardingComplete: json['onboardingComplete'] as bool? ?? false,
  localeCode: json['localeCode'] as String? ?? 'tr',
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  healthNotificationsEnabled:
      json['healthNotificationsEnabled'] as bool? ?? true,
  familyNotificationsEnabled:
      json['familyNotificationsEnabled'] as bool? ?? true,
  reminderNotificationsEnabled:
      json['reminderNotificationsEnabled'] as bool? ?? true,
  notificationSound: json['notificationSound'] as String? ?? 'soft_chime',
);

Map<String, dynamic> _$AppSnapshotToJson(_AppSnapshot instance) =>
    <String, dynamic>{
      'user': instance.user,
      'family': instance.family,
      'baby': instance.baby,
      'pregnancy': instance.pregnancy,
      'mode': _$CareModeEnumMap[instance.mode]!,
      'records': instance.records,
      'reminders': instance.reminders,
      'notifications': instance.notifications,
      'invites': instance.invites,
      'vaccines': instance.vaccines,
      'articles': instance.articles,
      'onboardingComplete': instance.onboardingComplete,
      'localeCode': instance.localeCode,
      'notificationsEnabled': instance.notificationsEnabled,
      'healthNotificationsEnabled': instance.healthNotificationsEnabled,
      'familyNotificationsEnabled': instance.familyNotificationsEnabled,
      'reminderNotificationsEnabled': instance.reminderNotificationsEnabled,
      'notificationSound': instance.notificationSound,
    };

const _$CareModeEnumMap = {
  CareMode.pregnancy: 'pregnancy',
  CareMode.baby: 'baby',
  CareMode.planning: 'planning',
};
