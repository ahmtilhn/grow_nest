# Basic Usage

```dart
ExampleConnector.instance.GetMyProfile().execute();
ExampleConnector.instance.ListMyFamilies().execute();
ExampleConnector.instance.ListPendingInvitesForMe(listPendingInvitesForMeVariables).execute();
ExampleConnector.instance.GetMyPregnancy().execute();
ExampleConnector.instance.ListFamilyRecords(listFamilyRecordsVariables).execute();
ExampleConnector.instance.UpsertCurrentUser(upsertCurrentUserVariables).execute();
ExampleConnector.instance.UpsertFamily(upsertFamilyVariables).execute();
ExampleConnector.instance.AddFamilyPartner(addFamilyPartnerVariables).execute();
ExampleConnector.instance.AcceptFamilyPartnerInvite(acceptFamilyPartnerInviteVariables).execute();
ExampleConnector.instance.DeclineFamilyPartnerInvite(declineFamilyPartnerInviteVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ExampleConnector.instance.UpsertTrackerRecord({ ... })
.familyId(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

