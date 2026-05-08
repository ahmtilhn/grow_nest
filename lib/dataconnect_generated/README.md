# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetMyProfile
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMyProfile().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyProfileData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMyProfile();
GetMyProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMyProfile().ref();
ref.execute();

ref.subscribe(...);
```


### ListMyFamilies
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listMyFamilies().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMyFamiliesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMyFamilies();
ListMyFamiliesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listMyFamilies().ref();
ref.execute();

ref.subscribe(...);
```


### ListPendingInvitesForMe
#### Required Arguments
```dart
String email = ...;
ExampleConnector.instance.listPendingInvitesForMe(
  email: email,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPendingInvitesForMeData, ListPendingInvitesForMeVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listPendingInvitesForMe(
  email: email,
);
ListPendingInvitesForMeData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String email = ...;

final ref = ExampleConnector.instance.listPendingInvitesForMe(
  email: email,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetMyPregnancy
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getMyPregnancy().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetMyPregnancyData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getMyPregnancy();
GetMyPregnancyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getMyPregnancy().ref();
ref.execute();

ref.subscribe(...);
```


### ListFamilyRecords
#### Required Arguments
```dart
String familyId = ...;
ExampleConnector.instance.listFamilyRecords(
  familyId: familyId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListFamilyRecordsData, ListFamilyRecordsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listFamilyRecords(
  familyId: familyId,
);
ListFamilyRecordsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String familyId = ...;

final ref = ExampleConnector.instance.listFamilyRecords(
  familyId: familyId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpsertCurrentUser
#### Required Arguments
```dart
String email = ...;
String language = ...;
String theme = ...;
ExampleConnector.instance.upsertCurrentUser(
  email: email,
  language: language,
  theme: theme,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCurrentUser, we created `UpsertCurrentUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCurrentUserVariablesBuilder {
  ...
   UpsertCurrentUserVariablesBuilder displayName(String? t) {
   _displayName.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder avatarUrl(String? t) {
   _avatarUrl.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder birthDate(Timestamp? t) {
   _birthDate.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder phone(String? t) {
   _phone.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder role(String? t) {
   _role.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertCurrentUser(
  email: email,
  language: language,
  theme: theme,
)
.displayName(displayName)
.avatarUrl(avatarUrl)
.birthDate(birthDate)
.phone(phone)
.role(role)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCurrentUserData, UpsertCurrentUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertCurrentUser(
  email: email,
  language: language,
  theme: theme,
);
UpsertCurrentUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String email = ...;
String language = ...;
String theme = ...;

final ref = ExampleConnector.instance.upsertCurrentUser(
  email: email,
  language: language,
  theme: theme,
).ref();
ref.execute();
```


### UpsertFamily
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.upsertFamily(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertFamily, we created `UpsertFamilyBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertFamilyVariablesBuilder {
  ...
   UpsertFamilyVariablesBuilder activeBabyId(String? t) {
   _activeBabyId.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertFamily(
  id: id,
)
.activeBabyId(activeBabyId)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertFamilyData, UpsertFamilyVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertFamily(
  id: id,
);
UpsertFamilyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.upsertFamily(
  id: id,
).ref();
ref.execute();
```


### AddFamilyPartner
#### Required Arguments
```dart
String familyId = ...;
String email = ...;
ExampleConnector.instance.addFamilyPartner(
  familyId: familyId,
  email: email,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddFamilyPartnerData, AddFamilyPartnerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addFamilyPartner(
  familyId: familyId,
  email: email,
);
AddFamilyPartnerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String familyId = ...;
String email = ...;

final ref = ExampleConnector.instance.addFamilyPartner(
  familyId: familyId,
  email: email,
).ref();
ref.execute();
```


### AcceptFamilyPartnerInvite
#### Required Arguments
```dart
String familyId = ...;
String email = ...;
ExampleConnector.instance.acceptFamilyPartnerInvite(
  familyId: familyId,
  email: email,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AcceptFamilyPartnerInviteData, AcceptFamilyPartnerInviteVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.acceptFamilyPartnerInvite(
  familyId: familyId,
  email: email,
);
AcceptFamilyPartnerInviteData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String familyId = ...;
String email = ...;

final ref = ExampleConnector.instance.acceptFamilyPartnerInvite(
  familyId: familyId,
  email: email,
).ref();
ref.execute();
```


### DeclineFamilyPartnerInvite
#### Required Arguments
```dart
String familyId = ...;
String email = ...;
ExampleConnector.instance.declineFamilyPartnerInvite(
  familyId: familyId,
  email: email,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeclineFamilyPartnerInviteData, DeclineFamilyPartnerInviteVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.declineFamilyPartnerInvite(
  familyId: familyId,
  email: email,
);
DeclineFamilyPartnerInviteData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String familyId = ...;
String email = ...;

final ref = ExampleConnector.instance.declineFamilyPartnerInvite(
  familyId: familyId,
  email: email,
).ref();
ref.execute();
```


### UpsertBaby
#### Required Arguments
```dart
String id = ...;
String familyId = ...;
String name = ...;
Timestamp birthDate = ...;
ExampleConnector.instance.upsertBaby(
  id: id,
  familyId: familyId,
  name: name,
  birthDate: birthDate,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertBaby, we created `UpsertBabyBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertBabyVariablesBuilder {
  ...
   UpsertBabyVariablesBuilder gender(String? t) {
   _gender.value = t;
   return this;
  }
  UpsertBabyVariablesBuilder birthWeight(double? t) {
   _birthWeight.value = t;
   return this;
  }
  UpsertBabyVariablesBuilder birthHeight(double? t) {
   _birthHeight.value = t;
   return this;
  }
  UpsertBabyVariablesBuilder birthHeadCircumference(double? t) {
   _birthHeadCircumference.value = t;
   return this;
  }
  UpsertBabyVariablesBuilder currentWeight(double? t) {
   _currentWeight.value = t;
   return this;
  }
  UpsertBabyVariablesBuilder currentHeight(double? t) {
   _currentHeight.value = t;
   return this;
  }
  UpsertBabyVariablesBuilder currentHeadCircumference(double? t) {
   _currentHeadCircumference.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertBaby(
  id: id,
  familyId: familyId,
  name: name,
  birthDate: birthDate,
)
.gender(gender)
.birthWeight(birthWeight)
.birthHeight(birthHeight)
.birthHeadCircumference(birthHeadCircumference)
.currentWeight(currentWeight)
.currentHeight(currentHeight)
.currentHeadCircumference(currentHeadCircumference)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertBabyData, UpsertBabyVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertBaby(
  id: id,
  familyId: familyId,
  name: name,
  birthDate: birthDate,
);
UpsertBabyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String familyId = ...;
String name = ...;
Timestamp birthDate = ...;

final ref = ExampleConnector.instance.upsertBaby(
  id: id,
  familyId: familyId,
  name: name,
  birthDate: birthDate,
).ref();
ref.execute();
```


### UpsertPregnancy
#### Required Arguments
```dart
String id = ...;
Timestamp startDate = ...;
Timestamp dueDate = ...;
String status = ...;
ExampleConnector.instance.upsertPregnancy(
  id: id,
  startDate: startDate,
  dueDate: dueDate,
  status: status,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertPregnancy, we created `UpsertPregnancyBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertPregnancyVariablesBuilder {
  ...
   UpsertPregnancyVariablesBuilder birthCompletedAt(Timestamp? t) {
   _birthCompletedAt.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertPregnancy(
  id: id,
  startDate: startDate,
  dueDate: dueDate,
  status: status,
)
.birthCompletedAt(birthCompletedAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertPregnancyData, UpsertPregnancyVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertPregnancy(
  id: id,
  startDate: startDate,
  dueDate: dueDate,
  status: status,
);
UpsertPregnancyData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
Timestamp startDate = ...;
Timestamp dueDate = ...;
String status = ...;

final ref = ExampleConnector.instance.upsertPregnancy(
  id: id,
  startDate: startDate,
  dueDate: dueDate,
  status: status,
).ref();
ref.execute();
```


### UpsertTrackerRecord
#### Required Arguments
```dart
String id = ...;
String type = ...;
String title = ...;
Timestamp occurredAt = ...;
ExampleConnector.instance.upsertTrackerRecord(
  id: id,
  type: type,
  title: title,
  occurredAt: occurredAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertTrackerRecord, we created `UpsertTrackerRecordBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertTrackerRecordVariablesBuilder {
  ...
   UpsertTrackerRecordVariablesBuilder familyId(String? t) {
   _familyId.value = t;
   return this;
  }
  UpsertTrackerRecordVariablesBuilder babyId(String? t) {
   _babyId.value = t;
   return this;
  }
  UpsertTrackerRecordVariablesBuilder value(String? t) {
   _value.value = t;
   return this;
  }
  UpsertTrackerRecordVariablesBuilder note(String? t) {
   _note.value = t;
   return this;
  }
  UpsertTrackerRecordVariablesBuilder deletedAt(Timestamp? t) {
   _deletedAt.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertTrackerRecord(
  id: id,
  type: type,
  title: title,
  occurredAt: occurredAt,
)
.familyId(familyId)
.babyId(babyId)
.value(value)
.note(note)
.deletedAt(deletedAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertTrackerRecordData, UpsertTrackerRecordVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertTrackerRecord(
  id: id,
  type: type,
  title: title,
  occurredAt: occurredAt,
);
UpsertTrackerRecordData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String type = ...;
String title = ...;
Timestamp occurredAt = ...;

final ref = ExampleConnector.instance.upsertTrackerRecord(
  id: id,
  type: type,
  title: title,
  occurredAt: occurredAt,
).ref();
ref.execute();
```

