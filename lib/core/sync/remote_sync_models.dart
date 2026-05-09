class RemoteFamilyInvite {
  const RemoteFamilyInvite({
    required this.familyId,
    required this.invitedEmail,
    required this.invitedByUserId,
    required this.invitedByName,
    required this.ownerUserId,
    required this.createdAt,
    this.activeBabyId,
    this.invitedDisplayName,
    this.roleLabel,
    this.permissions = const [],
    this.acceptedUserId,
    this.status = 'pending',
    this.respondedAt,
  });

  String get id => 'invite-$familyId-${invitedEmail.trim().toLowerCase()}';

  final String familyId;
  final String invitedEmail;
  final String invitedByUserId;
  final String invitedByName;
  final String ownerUserId;
  final String? activeBabyId;
  final String? invitedDisplayName;
  final String? roleLabel;
  final List<String> permissions;
  final String? acceptedUserId;
  final String status;
  final DateTime createdAt;
  final DateTime? respondedAt;
}

class RemoteFamilySummary {
  const RemoteFamilySummary({
    required this.id,
    required this.ownerUserId,
    required this.createdAt,
    this.activeBabyId,
    this.partnerEmails = const [],
    this.invites = const [],
    this.babies = const [],
    this.records = const [],
    this.reminders = const [],
    this.vaccines = const [],
    this.notifications = const [],
  });

  final String id;
  final String ownerUserId;
  final String? activeBabyId;
  final DateTime createdAt;
  final List<String> partnerEmails;
  final List<RemoteFamilyInvite> invites;
  final List<RemoteBabySummary> babies;
  final List<RemoteTrackerRecordSummary> records;
  final List<RemoteReminderSummary> reminders;
  final List<RemoteVaccineSummary> vaccines;
  final List<RemoteNotificationSummary> notifications;
}

class RemoteNotificationSummary {
  const RemoteNotificationSummary({
    required this.id,
    required this.familyId,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.category = 'family',
    this.payload,
    this.createdBy,
    this.targetUserIds = const [],
    this.readBy = const [],
    this.seenBy = const [],
    this.isDeleted = false,
  });

  final String id;
  final String familyId;
  final String type;
  final String category;
  final String title;
  final String body;
  final String? payload;
  final String? createdBy;
  final List<String> targetUserIds;
  final List<String> readBy;
  final List<String> seenBy;
  final bool isDeleted;
  final DateTime createdAt;
}

class RemoteBabySummary {
  const RemoteBabySummary({
    required this.id,
    required this.familyId,
    required this.name,
    required this.birthDate,
    required this.createdAt,
    this.gender,
    this.birthWeight,
    this.birthHeight,
    this.birthHeadCircumference,
    this.currentWeight,
    this.currentHeight,
    this.currentHeadCircumference,
  });

  final String id;
  final String familyId;
  final String name;
  final DateTime birthDate;
  final String? gender;
  final double? birthWeight;
  final double? birthHeight;
  final double? birthHeadCircumference;
  final double? currentWeight;
  final double? currentHeight;
  final double? currentHeadCircumference;
  final DateTime createdAt;
}

class RemoteTrackerRecordSummary {
  const RemoteTrackerRecordSummary({
    required this.id,
    required this.type,
    required this.title,
    required this.familyId,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.babyId,
    this.value,
    this.note,
    this.createdByUserId,
    this.createdByName,
    this.updatedByUserId,
    this.updatedByName,
    this.deletedAt,
  });

  final String id;
  final String type;
  final String title;
  final String familyId;
  final String? babyId;
  final String? value;
  final String? note;
  final String? createdByUserId;
  final String? createdByName;
  final String? updatedByUserId;
  final String? updatedByName;
  final DateTime? deletedAt;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class RemoteReminderSummary {
  const RemoteReminderSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.frequency,
    required this.isActive,
    required this.familyId,
    required this.createdAt,
    this.notes,
    this.createdByUserId,
    this.createdByName,
    this.updatedByUserId,
    this.updatedByName,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String title;
  final String category;
  final DateTime time;
  final String frequency;
  final String? notes;
  final bool isActive;
  final String familyId;
  final String? createdByUserId;
  final String? createdByName;
  final String? updatedByUserId;
  final String? updatedByName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
}

class RemoteVaccineSummary {
  const RemoteVaccineSummary({
    required this.id,
    required this.babyId,
    required this.title,
    required this.dose,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    this.notes,
    this.completedAt,
    this.updatedByUserId,
    this.updatedByName,
    this.updatedAt,
  });

  final String id;
  final String babyId;
  final String title;
  final String dose;
  final DateTime dueDate;
  final String status;
  final String? notes;
  final DateTime? completedAt;
  final String? updatedByUserId;
  final String? updatedByName;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
