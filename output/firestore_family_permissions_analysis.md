# Firestore Family Permissions Analysis

Date: 2026-05-08

Firestore instance checked with Firebase CLI:

- Project: `grownest-f4141`
- Database: `(default)`
- Edition: `STANDARD`
- Type: `FIRESTORE_NATIVE`
- Realtime updates: enabled

Relevant app paths:

- `lib/app/app_controller.dart`: operation guards, invite/member actions, live family subscription.
- `lib/data/repositories/app_repository.dart`: Drift cache, remote family merge, duplicate invite/member presentation source.
- `lib/core/firebase/firebase_sync_service.dart`: Firestore reads/writes, realtime listeners, FCM token writes.
- `lib/domain/entities/app_entities.dart`: roles, permissions, family/invite/notification models.
- `lib/features/family/family_screen.dart`: invite/member UI.
- `lib/features/notifications/notifications_screen.dart`: in-app notification UI.
- `functions/index.js`: Firestore triggers creating notification records and push messages.
- `firestore.rules`: server-side permission enforcement.

Firestore collections used by the current code:

- `users/{uid}`
- `families/{familyId}`
- `babies/{babyId}`
- `pregnancies/{pregnancyId}`
- `trackerRecords/{recordId}`
- `reminders/{reminderId}`
- `vaccineEvents/{vaccineId}`
- `familyInvites/{inviteId}`
- `notifications/{notificationId}`
- `families/{familyId}/notifications/{notificationId}`
- `notificationTokens/{tokenId}`

Key findings:

- Remote permission lists were lowercased while reading from Firestore. Enum values such as `inviteUsers` became `inviteusers`, so accepted members could look authorized in Firestore but fail client-side permission checks.
- `addFamilyPartner` ran strict family/baby sync before creating an invite. Non-owner members with invite permission could fail on `families/{familyId}` rules before reaching invite creation.
- Family UI rendered `partnerUserIds` and accepted `familyInvites` as separate rows, causing the same person to appear twice.
- Reminder soft-delete rules required `addAppointment` instead of `deleteRecords`, so authorized delete flows could be rejected by Firestore.
- Tracker record rules allowed a record creator to soft-delete a family-scoped record without `deleteRecords`; server rules did not match the requested family permission model.
- Notification screen marked everything read on open, making unread state effectively unusable.
- Notification triggers only wrote root `notifications`; a family-scoped notification mirror was added for the requested architecture while keeping the existing root collection for compatibility.
