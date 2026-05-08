part of 'generated.dart';

class ListFamilyRecordsVariablesBuilder {
  String familyId;

  final FirebaseDataConnect _dataConnect;
  ListFamilyRecordsVariablesBuilder(this._dataConnect, {required  this.familyId,});
  Deserializer<ListFamilyRecordsData> dataDeserializer = (dynamic json)  => ListFamilyRecordsData.fromJson(jsonDecode(json));
  Serializer<ListFamilyRecordsVariables> varsSerializer = (ListFamilyRecordsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListFamilyRecordsData, ListFamilyRecordsVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListFamilyRecordsData, ListFamilyRecordsVariables> ref() {
    ListFamilyRecordsVariables vars= ListFamilyRecordsVariables(familyId: familyId,);
    return _dataConnect.query("ListFamilyRecords", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListFamilyRecordsTrackerRecords {
  final String id;
  final String? familyId;
  final String? babyId;
  final String? createdByUserId;
  final String type;
  final String title;
  final String? value;
  final String? note;
  final Timestamp occurredAt;
  final Timestamp updatedAt;
  ListFamilyRecordsTrackerRecords.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  familyId = json['familyId'] == null ? null : nativeFromJson<String>(json['familyId']),
  babyId = json['babyId'] == null ? null : nativeFromJson<String>(json['babyId']),
  createdByUserId = json['createdByUserId'] == null ? null : nativeFromJson<String>(json['createdByUserId']),
  type = nativeFromJson<String>(json['type']),
  title = nativeFromJson<String>(json['title']),
  value = json['value'] == null ? null : nativeFromJson<String>(json['value']),
  note = json['note'] == null ? null : nativeFromJson<String>(json['note']),
  occurredAt = Timestamp.fromJson(json['occurredAt']),
  updatedAt = Timestamp.fromJson(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListFamilyRecordsTrackerRecords otherTyped = other as ListFamilyRecordsTrackerRecords;
    return id == otherTyped.id && 
    familyId == otherTyped.familyId && 
    babyId == otherTyped.babyId && 
    createdByUserId == otherTyped.createdByUserId && 
    type == otherTyped.type && 
    title == otherTyped.title && 
    value == otherTyped.value && 
    note == otherTyped.note && 
    occurredAt == otherTyped.occurredAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, familyId.hashCode, babyId.hashCode, createdByUserId.hashCode, type.hashCode, title.hashCode, value.hashCode, note.hashCode, occurredAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (familyId != null) {
      json['familyId'] = nativeToJson<String?>(familyId);
    }
    if (babyId != null) {
      json['babyId'] = nativeToJson<String?>(babyId);
    }
    if (createdByUserId != null) {
      json['createdByUserId'] = nativeToJson<String?>(createdByUserId);
    }
    json['type'] = nativeToJson<String>(type);
    json['title'] = nativeToJson<String>(title);
    if (value != null) {
      json['value'] = nativeToJson<String?>(value);
    }
    if (note != null) {
      json['note'] = nativeToJson<String?>(note);
    }
    json['occurredAt'] = occurredAt.toJson();
    json['updatedAt'] = updatedAt.toJson();
    return json;
  }

  ListFamilyRecordsTrackerRecords({
    required this.id,
    this.familyId,
    this.babyId,
    this.createdByUserId,
    required this.type,
    required this.title,
    this.value,
    this.note,
    required this.occurredAt,
    required this.updatedAt,
  });
}

@immutable
class ListFamilyRecordsData {
  final List<ListFamilyRecordsTrackerRecords> trackerRecords;
  ListFamilyRecordsData.fromJson(dynamic json):
  
  trackerRecords = (json['trackerRecords'] as List<dynamic>)
        .map((e) => ListFamilyRecordsTrackerRecords.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListFamilyRecordsData otherTyped = other as ListFamilyRecordsData;
    return trackerRecords == otherTyped.trackerRecords;
    
  }
  @override
  int get hashCode => trackerRecords.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['trackerRecords'] = trackerRecords.map((e) => e.toJson()).toList();
    return json;
  }

  ListFamilyRecordsData({
    required this.trackerRecords,
  });
}

@immutable
class ListFamilyRecordsVariables {
  final String familyId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListFamilyRecordsVariables.fromJson(Map<String, dynamic> json):
  
  familyId = nativeFromJson<String>(json['familyId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListFamilyRecordsVariables otherTyped = other as ListFamilyRecordsVariables;
    return familyId == otherTyped.familyId;
    
  }
  @override
  int get hashCode => familyId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['familyId'] = nativeToJson<String>(familyId);
    return json;
  }

  ListFamilyRecordsVariables({
    required this.familyId,
  });
}

