# Firestore Rules Notes

## Codebase Scan

- Client: Flutter/Dart with Firebase Auth.
- Firestore is used only through `FirebaseFirestoreSyncService`.
- Active shared family data now uses scoped realtime listeners so two caregivers see the same baby panel live.

## Collections

- `users/{uid}`: private profile synced from the authenticated Firebase user.
- `families/{familyId}`: owner-scoped family shell.
- `babies/{babyId}`: baby profile scoped by `familyId`.
- `pregnancies/{pregnancyId}`: private pregnancy profile scoped by `userId`.
- `trackerRecords/{recordId}`: tracker records scoped by creator and optional family; `createdByName` is denormalized display-only actor text so partner screens do not need extra user reads.
- `reminders/{reminderId}`: shared reminders scoped by `familyId`.
- `vaccineEvents/{vaccineId}`: shared vaccine status scoped by `babyId`.
- `familyInvites/{inviteId}`: invite documents with id `invite-{familyId}-{email}`.

## Queries

- `familyInvites.where(invitedEmail == email).where(status == pending).limit(20)`
- `families.where(ownerUserId == uid).limit(5)`
- `familyInvites.where(acceptedUserId == uid).where(status == accepted).limit(5)`
- `familyInvites.where(invitedByUserId == uid).where(status == accepted).limit(20)`
- `babies.where(familyId == familyId).limit(5)`
- `trackerRecords.where(familyId == familyId).limit(100)`
- Live active family listeners:
  - `families/{familyId}.snapshots()`
  - `babies.where(familyId == familyId).limit(5).snapshots()`
  - `trackerRecords.where(familyId == familyId).limit(200).snapshots()`
  - `reminders.where(familyId == familyId).limit(100).snapshots()`
  - `familyInvites.where(familyId == familyId).where(status == accepted).limit(20).snapshots()`
  - `vaccineEvents.where(babyId == activeBabyId).limit(60).snapshots()`

## Cost Controls

- Realtime listeners are limited to the active shared family/baby only.
- No periodic polling.
- No unbounded reads; every list query uses `limit`.
- Invite creation and accept/decline are single-document writes.
