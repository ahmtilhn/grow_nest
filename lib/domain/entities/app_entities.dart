import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/sync/sync_queue.dart';

part 'app_entities.freezed.dart';
part 'app_entities.g.dart';

enum CareMode { pregnancy, baby, planning }

enum FeedingType {
  breastMilk,
  leftBreast,
  rightBreast,
  formula,
  storedMilk,
  solidFood,
  water,
  other,
}

enum DiaperType { wet, dirty, both, dry, other }

enum SleepType { day, night }

enum RecordType {
  feeding,
  diaper,
  sleep,
  growth,
  health,
  solidFood,
  milkStock,
  memory,
  water,
  vitamin,
  appointment,
  reminder,
}

enum ReminderCategory {
  health,
  water,
  feeding,
  vaccine,
  appointment,
  vitamin,
  medicine,
  sleep,
  diaper,
  custom,
}

enum AppNotificationStatus { unread, read, accepted, declined }

enum FamilyInviteStatus { pending, accepted, declined }

enum VaccineStatus { upcoming, completed, overdue }

enum FamilyPermission {
  viewBaby,
  viewFeeding,
  viewDiaper,
  viewSleep,
  viewVaccines,
  viewAppointments,
  viewMemories,
  viewNotifications,
  viewStats,
  addFeeding,
  addDiaper,
  manageSleep,
  addGrowth,
  addVaccine,
  addAppointment,
  addMemory,
  saveArticle,
  editRecords,
  deleteRecords,
  inviteUsers,
  manageUserPermissions,
  removeUsers,
  editFamily,
  editBaby,
  deleteFamilyData,
}

class FamilyPermissionSets {
  const FamilyPermissionSets._();

  static List<FamilyPermission> get owner => FamilyPermission.values;

  static const parent = [
    FamilyPermission.viewBaby,
    FamilyPermission.viewFeeding,
    FamilyPermission.viewDiaper,
    FamilyPermission.viewSleep,
    FamilyPermission.viewVaccines,
    FamilyPermission.viewAppointments,
    FamilyPermission.viewMemories,
    FamilyPermission.viewNotifications,
    FamilyPermission.viewStats,
    FamilyPermission.addFeeding,
    FamilyPermission.addDiaper,
    FamilyPermission.manageSleep,
    FamilyPermission.addGrowth,
    FamilyPermission.addVaccine,
    FamilyPermission.addAppointment,
    FamilyPermission.addMemory,
    FamilyPermission.saveArticle,
    FamilyPermission.editRecords,
    FamilyPermission.deleteRecords,
    FamilyPermission.inviteUsers,
    FamilyPermission.editBaby,
  ];

  static const caregiver = [
    FamilyPermission.viewBaby,
    FamilyPermission.viewFeeding,
    FamilyPermission.viewDiaper,
    FamilyPermission.viewSleep,
    FamilyPermission.viewAppointments,
    FamilyPermission.viewMemories,
    FamilyPermission.viewNotifications,
    FamilyPermission.addFeeding,
    FamilyPermission.addDiaper,
    FamilyPermission.manageSleep,
    FamilyPermission.addAppointment,
    FamilyPermission.addMemory,
  ];

  static const viewOnly = [
    FamilyPermission.viewBaby,
    FamilyPermission.viewFeeding,
    FamilyPermission.viewDiaper,
    FamilyPermission.viewSleep,
    FamilyPermission.viewVaccines,
    FamilyPermission.viewAppointments,
    FamilyPermission.viewMemories,
    FamilyPermission.viewNotifications,
    FamilyPermission.viewStats,
  ];

  static List<FamilyPermission> defaultsForRole(String? roleLabel) {
    final normalized = roleLabel?.trim().toLowerCase();
    return switch (normalized) {
      'bakıcı' || 'bakici' || 'caregiver' => caregiver,
      'görüntüleyici' ||
      'goruntuleyici' ||
      'doktor' ||
      'view' ||
      'viewer' => viewOnly,
      _ => parent,
    };
  }
}

enum HealthRecordType {
  fever,
  constipation,
  diarrhea,
  vomiting,
  rash,
  gas,
  unrest,
  cough,
  vaccine,
  medicine,
  other,
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    @Default(false) bool emailVerified,
    String? avatarUrl,
    DateTime? birthDate,
    String? phone,
    String? role,
    required DateTime createdAt,
    @Default('tr') String language,
    @Default('light') String theme,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
abstract class Family with _$Family {
  const factory Family({
    required String id,
    required String ownerUserId,
    @Default([]) List<String> partnerUserIds,
    String? activeBabyId,
    required DateTime createdAt,
  }) = _Family;

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}

@freezed
abstract class BabyProfile with _$BabyProfile {
  const factory BabyProfile({
    required String id,
    required String familyId,
    required String name,
    required DateTime birthDate,
    String? gender,
    double? birthWeight,
    double? birthHeight,
    double? birthHeadCircumference,
    double? currentWeight,
    double? currentHeight,
    double? currentHeadCircumference,
    required DateTime createdAt,
  }) = _BabyProfile;

  factory BabyProfile.fromJson(Map<String, dynamic> json) =>
      _$BabyProfileFromJson(json);
}

@freezed
abstract class PregnancyProfile with _$PregnancyProfile {
  const factory PregnancyProfile({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime dueDate,
    required String status,
    DateTime? birthCompletedAt,
  }) = _PregnancyProfile;

  factory PregnancyProfile.fromJson(Map<String, dynamic> json) =>
      _$PregnancyProfileFromJson(json);
}

@freezed
abstract class TrackerRecord with _$TrackerRecord {
  const factory TrackerRecord({
    required String id,
    required RecordType type,
    required String title,
    String? familyId,
    String? babyId,
    String? value,
    String? note,
    String? createdByUserId,
    String? createdByName,
    String? updatedByUserId,
    String? updatedByName,
    required DateTime occurredAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _TrackerRecord;

  factory TrackerRecord.fromJson(Map<String, dynamic> json) =>
      _$TrackerRecordFromJson(json);
}

@freezed
abstract class ReminderItem with _$ReminderItem {
  const factory ReminderItem({
    required String id,
    required String title,
    required ReminderCategory category,
    required DateTime time,
    @Default('daily') String frequency,
    String? notes,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _ReminderItem;

  factory ReminderItem.fromJson(Map<String, dynamic> json) =>
      _$ReminderItemFromJson(json);
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    String? familyId,
    @Default([]) List<String> targetUserIds,
    String? createdBy,
    required String type,
    required String category,
    required String title,
    required String body,
    String? payload,
    @Default([]) List<String> readBy,
    @Default([]) List<String> seenBy,
    @Default(false) bool isDeleted,
    @Default(AppNotificationStatus.unread) AppNotificationStatus status,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

@freezed
abstract class FamilyInvite with _$FamilyInvite {
  const factory FamilyInvite({
    required String id,
    required String familyId,
    required String invitedEmail,
    required String invitedByUserId,
    required String invitedByName,
    String? invitedDisplayName,
    String? roleLabel,
    @Default([]) List<FamilyPermission> permissions,
    String? acceptedUserId,
    @Default(FamilyInviteStatus.pending) FamilyInviteStatus status,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) = _FamilyInvite;

  factory FamilyInvite.fromJson(Map<String, dynamic> json) =>
      _$FamilyInviteFromJson(json);
}

@freezed
abstract class VaccineEvent with _$VaccineEvent {
  const factory VaccineEvent({
    required String id,
    required String babyId,
    required String title,
    required String dose,
    required DateTime dueDate,
    @Default(VaccineStatus.upcoming) VaccineStatus status,
    String? notes,
    DateTime? completedAt,
    required DateTime createdAt,
  }) = _VaccineEvent;

  factory VaccineEvent.fromJson(Map<String, dynamic> json) =>
      _$VaccineEventFromJson(json);
}

@freezed
abstract class Article with _$Article {
  const factory Article({
    required String id,
    @Default('baby') String careMode,
    required String title,
    required String category,
    required String summary,
    required String content,
    required int readingMinutes,
    required String sourceName,
    required String sourceUrl,
    required String medicalDisclaimer,
    @Default(false) bool isSaved,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

@freezed
abstract class AppSnapshot with _$AppSnapshot {
  const factory AppSnapshot({
    UserProfile? user,
    Family? family,
    BabyProfile? baby,
    PregnancyProfile? pregnancy,
    @Default(CareMode.pregnancy) CareMode mode,
    @Default([]) List<TrackerRecord> records,
    @Default([]) List<ReminderItem> reminders,
    @Default([]) List<AppNotification> notifications,
    @Default([]) List<FamilyInvite> invites,
    @Default([]) List<VaccineEvent> vaccines,
    @Default([]) List<Article> articles,
    @Default(false) bool onboardingComplete,
    @Default('tr') String localeCode,
    @Default(true) bool notificationsEnabled,
    @Default(true) bool healthNotificationsEnabled,
    @Default(true) bool familyNotificationsEnabled,
    @Default(true) bool reminderNotificationsEnabled,
    @Default('soft_chime') String notificationSound,
  }) = _AppSnapshot;

  factory AppSnapshot.fromJson(Map<String, dynamic> json) =>
      _$AppSnapshotFromJson(json);
}
