# Grow Nest Firebase Security and Cost Notes

Date: 2026-05-29

## Current Firebase Shape

- Firebase project: `grownest-f4141`
- Firestore database: `(default)`
- Edition: `STANDARD`
- Location: `europe-west4`
- Free tier: enabled
- Primary app data store in production code: Cloud Firestore
- Data Connect schema/generated client exists, but the active runtime sync path is Firestore.

## Fixed In This Pass

- Firestore user profile writes now bind `emailVerified` to the Firebase Auth token instead of trusting client-provided data.
- Family invite accept/decline responses now require a verified email that matches the invited email.
- Family invite permissions now allow only known permission names, preventing arbitrary permission/schema pollution.
- Notification read/seen updates now only allow the current user to add their own UID.
- Cloud Functions notification fan-out now caches email lookups within each invocation and skips redundant user lookups when an accepted invite already has an `acceptedUserId`.
- Removed the unsupported `auth` block from `firebase.json`; Firebase CLI ignored it, so it was misleading configuration noise.

## Remaining Watch Items

- `firebase.json` still contains a FlutterFire `flutter` metadata block. Firebase CLI warns about it, but it is commonly left for FlutterFire tooling and was not removed.
- Data Connect files are present, but the app currently uses Firestore for runtime sync. Treat Data Connect as unfinished/experimental unless the app is intentionally migrated.
- Firestore rules are a strong prototype and covered by emulator tests, but should still get a final pre-launch review with real production access patterns and indexes.
- Cloud Functions currently create notification documents and send FCM on several write triggers. This is minimal enough for early scale, but noisy record updates can still create extra function invocations.

## Cost Posture

- No always-on function instances were added.
- Function `maxInstances` remains capped at `2`.
- Query limits are already present in the Flutter sync layer.
- The notification function now reduces duplicate Firestore/Auth lookups for accepted family members.
