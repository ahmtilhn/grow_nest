part of 'generated.dart';

class UpsertTrackerRecordVariablesBuilder {
  String id;
  Optional<String> _familyId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _babyId = Optional.optional(nativeFromJson, nativeToJson);
  String type;
  String title;
  Optional<String> _value = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _note = Optional.optional(nativeFromJson, nativeToJson);
  Timestamp occurredAt;
  Optional<Timestamp> _deletedAt = Optional.optional((json) => json['deletedAt'] = Timestamp.fromJson(json['deletedAt']), defaultSerializer);

  final FirebaseDataConnect _dataConnect;  UpsertTrackerRecordVariablesBuilder familyId(String? t) {
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

  UpsertTrackerRecordVariablesBuilder(this._dataConnect, {required  this.id,required  this.type,required  this.title,required  this.occurredAt,});
  Deserializer<UpsertTrackerRecordData> dataDeserializer = (dynamic json)  => UpsertTrackerRecordData.fromJson(jsonDecode(json));
  Serializer<UpsertTrackerRecordVariables> varsSerializer = (UpsertTrackerRecordVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertTrackerRecordData, UpsertTrackerRecordVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertTrackerRecordData, UpsertTrackerRecordVariables> ref() {
    UpsertTrackerRecordVariables vars= UpsertTrackerRecordVariables(id: id,familyId: _familyId,babyId: _babyId,type: type,title: title,value: _value,note: _note,occurredAt: occurredAt,deletedAt: _deletedAt,);
    return _dataConnect.mutation("UpsertTrackerRecord", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertTrackerRecordTrackerRecordUpsert {
  final String id;
  UpsertTrackerRecordTrackerRecordUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTrackerRecordTrackerRecordUpsert otherTyped = other as UpsertTrackerRecordTrackerRecordUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertTrackerRecordTrackerRecordUpsert({
    required this.id,
  });
}

@immutable
class UpsertTrackerRecordData {
  final UpsertTrackerRecordTrackerRecordUpsert trackerRecord_upsert;
  UpsertTrackerRecordData.fromJson(dynamic json):
  
  trackerRecord_upsert = UpsertTrackerRecordTrackerRecordUpsert.fromJson(json['trackerRecord_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTrackerRecordData otherTyped = other as UpsertTrackerRecordData;
    return trackerRecord_upsert == otherTyped.trackerRecord_upsert;
    
  }
  @override
  int get hashCode => trackerRecord_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['trackerRecord_upsert'] = trackerRecord_upsert.toJson();
    return json;
  }

  UpsertTrackerRecordData({
    required this.trackerRecord_upsert,
  });
}

@immutable
class UpsertTrackerRecordVariables {
  final String id;
  late final Optional<String>familyId;
  late final Optional<String>babyId;
  final String type;
  final String title;
  late final Optional<String>value;
  late final Optional<String>note;
  final Timestamp occurredAt;
  late final Optional<Timestamp>deletedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertTrackerRecordVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  type = nativeFromJson<String>(json['type']),
  title = nativeFromJson<String>(json['title']),
  occurredAt = Timestamp.fromJson(json['occurredAt']) {
  
  
  
    familyId = Optional.optional(nativeFromJson, nativeToJson);
    familyId.value = json['familyId'] == null ? null : nativeFromJson<String>(json['familyId']);
  
  
    babyId = Optional.optional(nativeFromJson, nativeToJson);
    babyId.value = json['babyId'] == null ? null : nativeFromJson<String>(json['babyId']);
  
  
  
  
    value = Optional.optional(nativeFromJson, nativeToJson);
    value.value = json['value'] == null ? null : nativeFromJson<String>(json['value']);
  
  
    note = Optional.optional(nativeFromJson, nativeToJson);
    note.value = json['note'] == null ? null : nativeFromJson<String>(json['note']);
  
  
  
    deletedAt = Optional.optional((json) => json['deletedAt'] = Timestamp.fromJson(json['deletedAt']), defaultSerializer);
    deletedAt.value = json['deletedAt'] == null ? null : Timestamp.fromJson(json['deletedAt']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertTrackerRecordVariables otherTyped = other as UpsertTrackerRecordVariables;
    return id == otherTyped.id && 
    familyId == otherTyped.familyId && 
    babyId == otherTyped.babyId && 
    type == otherTyped.type && 
    title == otherTyped.title && 
    value == otherTyped.value && 
    note == otherTyped.note && 
    occurredAt == otherTyped.occurredAt && 
    deletedAt == otherTyped.deletedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, familyId.hashCode, babyId.hashCode, type.hashCode, title.hashCode, value.hashCode, note.hashCode, occurredAt.hashCode, deletedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(familyId.state == OptionalState.set) {
      json['familyId'] = familyId.toJson();
    }
    if(babyId.state == OptionalState.set) {
      json['babyId'] = babyId.toJson();
    }
    json['type'] = nativeToJson<String>(type);
    json['title'] = nativeToJson<String>(title);
    if(value.state == OptionalState.set) {
      json['value'] = value.toJson();
    }
    if(note.state == OptionalState.set) {
      json['note'] = note.toJson();
    }
    json['occurredAt'] = occurredAt.toJson();
    if(deletedAt.state == OptionalState.set) {
      json['deletedAt'] = deletedAt.toJson();
    }
    return json;
  }

  UpsertTrackerRecordVariables({
    required this.id,
    required this.familyId,
    required this.babyId,
    required this.type,
    required this.title,
    required this.value,
    required this.note,
    required this.occurredAt,
    required this.deletedAt,
  });
}

