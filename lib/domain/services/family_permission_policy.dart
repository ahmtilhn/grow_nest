import '../entities/app_entities.dart';

class FamilyPermissionPolicy {
  const FamilyPermissionPolicy._();

  static List<FamilyPermission> permissionsFor({
    required Family? family,
    required UserProfile? user,
    required Iterable<FamilyInvite> invites,
  }) {
    if (family == null || user == null) return FamilyPermissionSets.owner;
    if (family.ownerUserId == user.id) return FamilyPermissionSets.owner;
    final invite = membershipInviteFor(
      family: family,
      userId: user.id,
      email: user.email,
      invites: invites,
    );
    return invite?.permissions ?? const [];
  }

  static bool hasPermission({
    required Family? family,
    required UserProfile? user,
    required Iterable<FamilyInvite> invites,
    required FamilyPermission permission,
  }) {
    return permissionsFor(
      family: family,
      user: user,
      invites: invites,
    ).contains(permission);
  }

  static FamilyInvite? membershipInviteFor({
    required Family family,
    required String userId,
    required String email,
    required Iterable<FamilyInvite> invites,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    for (final invite in invites) {
      if (invite.familyId != family.id) continue;
      if (invite.status != FamilyInviteStatus.accepted) continue;
      final matchesUid = invite.acceptedUserId == userId;
      final matchesEmail =
          invite.invitedEmail.trim().toLowerCase() == normalizedEmail;
      if (matchesUid || matchesEmail) return invite;
    }
    return null;
  }

  static FamilyPermission createPermissionForRecord(RecordType type) {
    return switch (type) {
      RecordType.feeding ||
      RecordType.solidFood ||
      RecordType.milkStock ||
      RecordType.water ||
      RecordType.vitamin => FamilyPermission.addFeeding,
      RecordType.diaper => FamilyPermission.addDiaper,
      RecordType.sleep => FamilyPermission.manageSleep,
      RecordType.growth => FamilyPermission.addGrowth,
      RecordType.appointment ||
      RecordType.reminder ||
      RecordType.health => FamilyPermission.addAppointment,
      RecordType.memory => FamilyPermission.addMemory,
    };
  }

  static FamilyPermission viewPermissionForRecord(RecordType type) {
    return switch (type) {
      RecordType.feeding ||
      RecordType.solidFood ||
      RecordType.milkStock ||
      RecordType.water ||
      RecordType.vitamin => FamilyPermission.viewFeeding,
      RecordType.diaper => FamilyPermission.viewDiaper,
      RecordType.sleep => FamilyPermission.viewSleep,
      RecordType.growth => FamilyPermission.viewStats,
      RecordType.appointment ||
      RecordType.reminder ||
      RecordType.health => FamilyPermission.viewAppointments,
      RecordType.memory => FamilyPermission.viewMemories,
    };
  }

  static bool canViewRecord(
    RecordType type, {
    required Iterable<FamilyPermission> permissions,
  }) {
    return permissions.contains(viewPermissionForRecord(type));
  }

  static bool canViewReminder(
    ReminderCategory category, {
    required Iterable<FamilyPermission> permissions,
  }) {
    final permission = switch (category) {
      ReminderCategory.vaccine => FamilyPermission.viewVaccines,
      ReminderCategory.appointment ||
      ReminderCategory.health ||
      ReminderCategory.medicine => FamilyPermission.viewAppointments,
      _ => FamilyPermission.viewNotifications,
    };
    return permissions.contains(permission);
  }

  static bool canViewBaby({required Iterable<FamilyPermission> permissions}) {
    return permissions.contains(FamilyPermission.viewBaby);
  }

  static bool canViewNotifications({
    required Iterable<FamilyPermission> permissions,
  }) {
    return permissions.contains(FamilyPermission.viewNotifications);
  }
}
