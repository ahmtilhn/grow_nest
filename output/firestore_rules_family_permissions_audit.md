# Firestore Rules Family Permission Audit

Date: 2026-05-06

## Scope

Collections reviewed: `users`, `families`, `babies`, `pregnancies`, `trackerRecords`, `reminders`, `vaccineEvents`, `familyInvites`, `notifications`, `notificationTokens`.

Firestore database: `(default)`, Standard edition, native mode, `europe-west4`.

## Red-Team Summary

```json
{
  "score": 4,
  "summary": "The rules now enforce owner/member family access, per-invite permissions, invite resend/update controls, pending-invite notification read access, notification target scoping with viewNotifications permission, token ownership, strict schemas, and soft-delete validation. They compile and are deployed to the live Firebase project. Live Firebase Auth/Firestore tests confirmed invite creation, invite acceptance, permission denial before grant, permission update, and allowed writes after grant.",
  "findings": [
    {
      "check": "Authority Source",
      "severity": "minor",
      "issue": "Member authority is stored on the accepted familyInvites document. Owners can set it, invitees cannot change it in validInviteResponse.",
      "recommendation": "For high-scale production, consider moving memberships to immutable server-managed familyMembers documents created by Cloud Functions."
    },
    {
      "check": "Storage Abuse",
      "severity": "minor",
      "issue": "String fields have size limits and list fields have size caps, but generic string lists do not deeply validate every element length.",
      "recommendation": "Add dedicated validators for UID/email list contents before broad launch."
    },
    {
      "check": "Business Logic vs Rules",
      "severity": "minor",
      "issue": "Pending invite notifications are readable only by the targeted auth UID and matching invited email, while accepted family data still requires owner/member access. Accepted family notifications additionally require the viewNotifications permission.",
      "recommendation": "After the Firebase project is upgraded to Blaze, deploy Cloud Functions and re-run the notification poll to verify server-created notification documents and FCM sends."
    },
    {
      "check": "Cloud Functions Deployment",
      "severity": "major",
      "issue": "Remote push notification functions are implemented but cannot be deployed while the Firebase project is on Spark/free tier; Firebase blocks Cloud Build and Artifact Registry API enablement.",
      "recommendation": "Upgrade project grownest-f4141 to Blaze, then run npx -y firebase-tools@latest deploy --only functions --project grownest-f4141."
    }
  ]
}
```

## Validation

- `npx -y firebase-tools@latest firestore:databases:list --project grownest-f4141`: `(default)` found.
- `npx -y firebase-tools@latest firestore:databases:get '(default)' --project grownest-f4141`: Standard edition, Firestore Native, free tier.
- `npx -y firebase-tools@latest deploy --only firestore:rules,firestore:indexes,auth --project grownest-f4141`: rules, indexes, and Auth provider config deployed successfully.
- `node tooling/firebase_sdk_invite_test.mjs`: passed against live Firebase with two newly created Auth users. Confirmed owner writes family/invite, invitee reads pending invite, invitee accepts, owner updates permissions, invitee writes allowed tracker record.
- `node tooling/firebase_live_invite_test.mjs`: passed against live Firebase REST API. Confirmed denied write before accept, denied feeding write before addFeeding permission, allowed write after owner permission update, notification token write allowed, client notification document creation denied.
- `node tooling/firebase_flutter_invite_flow_test.mjs`: passed against live Firebase with the Flutter-like flow. Confirmed no missing-document reads are required for family/baby/invite creation, existing immutable `createdAt` values do not block resync, and invite creation works without a transaction read on a non-existing invite document.
- `npx -y firebase-tools@latest functions:list --project grownest-f4141`: no functions found.
- `npx -y firebase-tools@latest deploy --only functions --project grownest-f4141`: blocked by Firebase because project must be on Blaze to enable `artifactregistry.googleapis.com` and `cloudbuild.googleapis.com`.

## App Validation

- `flutter analyze`: passed.
- `flutter test`: passed, 26 tests.
- `flutter build apk --debug`: passed, produced `build/app/outputs/flutter-apk/app-debug.apk`.
- `flutter build apk --release`: passed, produced `build/app/outputs/flutter-apk/app-release.apk`.
- Physical Android device `SM S918B` was detected and the debug APK was installed with `adb install -r build/app/outputs/flutter-apk/app-debug.apk`.
- `flutter build ios`: not available from this Windows Flutter toolchain. iOS remote notification entitlements were added statically via `ios/Runner/Runner.entitlements` and `CODE_SIGN_ENTITLEMENTS`.

## Notification Notes

- Family/invite/remote-sync notifications no longer call local device notification display from the Flutter app.
- Reminder add/update no longer schedules local device notifications. Existing local schedules are still canceled on reminder update/delete as cleanup.
- Normal remote notification delivery is implemented through FCM in Cloud Functions, but cannot become live until the Firebase project can deploy functions on Blaze.
