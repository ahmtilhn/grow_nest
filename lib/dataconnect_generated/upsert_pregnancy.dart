part of 'generated.dart';

class UpsertPregnancyVariablesBuilder {
  String id;
  Timestamp startDate;
  Timestamp dueDate;
  String status;
  Optional<Timestamp> _birthCompletedAt = Optional.optional((json) => json['birthCompletedAt'] = Timestamp.fromJson(json['birthCompletedAt']), defaultSerializer);

  final FirebaseDataConnect _dataConnect;  UpsertPregnancyVariablesBuilder birthCompletedAt(Timestamp? t) {
   _birthCompletedAt.value = t;
   return this;
  }

  UpsertPregnancyVariablesBuilder(this._dataConnect, {required  this.id,required  this.startDate,required  this.dueDate,required  this.status,});
  Deserializer<UpsertPregnancyData> dataDeserializer = (dynamic json)  => UpsertPregnancyData.fromJson(jsonDecode(json));
  Serializer<UpsertPregnancyVariables> varsSerializer = (UpsertPregnancyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertPregnancyData, UpsertPregnancyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertPregnancyData, UpsertPregnancyVariables> ref() {
    UpsertPregnancyVariables vars= UpsertPregnancyVariables(id: id,startDate: startDate,dueDate: dueDate,status: status,birthCompletedAt: _birthCompletedAt,);
    return _dataConnect.mutation("UpsertPregnancy", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertPregnancyPregnancyUpsert {
  final String id;
  UpsertPregnancyPregnancyUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPregnancyPregnancyUpsert otherTyped = other as UpsertPregnancyPregnancyUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertPregnancyPregnancyUpsert({
    required this.id,
  });
}

@immutable
class UpsertPregnancyData {
  final UpsertPregnancyPregnancyUpsert pregnancy_upsert;
  UpsertPregnancyData.fromJson(dynamic json):
  
  pregnancy_upsert = UpsertPregnancyPregnancyUpsert.fromJson(json['pregnancy_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPregnancyData otherTyped = other as UpsertPregnancyData;
    return pregnancy_upsert == otherTyped.pregnancy_upsert;
    
  }
  @override
  int get hashCode => pregnancy_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pregnancy_upsert'] = pregnancy_upsert.toJson();
    return json;
  }

  UpsertPregnancyData({
    required this.pregnancy_upsert,
  });
}

@immutable
class UpsertPregnancyVariables {
  final String id;
  final Timestamp startDate;
  final Timestamp dueDate;
  final String status;
  late final Optional<Timestamp>birthCompletedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertPregnancyVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  startDate = Timestamp.fromJson(json['startDate']),
  dueDate = Timestamp.fromJson(json['dueDate']),
  status = nativeFromJson<String>(json['status']) {
  
  
  
  
  
  
    birthCompletedAt = Optional.optional((json) => json['birthCompletedAt'] = Timestamp.fromJson(json['birthCompletedAt']), defaultSerializer);
    birthCompletedAt.value = json['birthCompletedAt'] == null ? null : Timestamp.fromJson(json['birthCompletedAt']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertPregnancyVariables otherTyped = other as UpsertPregnancyVariables;
    return id == otherTyped.id && 
    startDate == otherTyped.startDate && 
    dueDate == otherTyped.dueDate && 
    status == otherTyped.status && 
    birthCompletedAt == otherTyped.birthCompletedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, startDate.hashCode, dueDate.hashCode, status.hashCode, birthCompletedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['startDate'] = startDate.toJson();
    json['dueDate'] = dueDate.toJson();
    json['status'] = nativeToJson<String>(status);
    if(birthCompletedAt.state == OptionalState.set) {
      json['birthCompletedAt'] = birthCompletedAt.toJson();
    }
    return json;
  }

  UpsertPregnancyVariables({
    required this.id,
    required this.startDate,
    required this.dueDate,
    required this.status,
    required this.birthCompletedAt,
  });
}

