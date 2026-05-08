part of 'generated.dart';

class UpsertFamilyVariablesBuilder {
  String id;
  Optional<String> _activeBabyId = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertFamilyVariablesBuilder activeBabyId(String? t) {
   _activeBabyId.value = t;
   return this;
  }

  UpsertFamilyVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<UpsertFamilyData> dataDeserializer = (dynamic json)  => UpsertFamilyData.fromJson(jsonDecode(json));
  Serializer<UpsertFamilyVariables> varsSerializer = (UpsertFamilyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertFamilyData, UpsertFamilyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertFamilyData, UpsertFamilyVariables> ref() {
    UpsertFamilyVariables vars= UpsertFamilyVariables(id: id,activeBabyId: _activeBabyId,);
    return _dataConnect.mutation("UpsertFamily", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertFamilyFamilyUpsert {
  final String id;
  UpsertFamilyFamilyUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertFamilyFamilyUpsert otherTyped = other as UpsertFamilyFamilyUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertFamilyFamilyUpsert({
    required this.id,
  });
}

@immutable
class UpsertFamilyData {
  final UpsertFamilyFamilyUpsert family_upsert;
  UpsertFamilyData.fromJson(dynamic json):
  
  family_upsert = UpsertFamilyFamilyUpsert.fromJson(json['family_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertFamilyData otherTyped = other as UpsertFamilyData;
    return family_upsert == otherTyped.family_upsert;
    
  }
  @override
  int get hashCode => family_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['family_upsert'] = family_upsert.toJson();
    return json;
  }

  UpsertFamilyData({
    required this.family_upsert,
  });
}

@immutable
class UpsertFamilyVariables {
  final String id;
  late final Optional<String>activeBabyId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertFamilyVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']) {
  
  
  
    activeBabyId = Optional.optional(nativeFromJson, nativeToJson);
    activeBabyId.value = json['activeBabyId'] == null ? null : nativeFromJson<String>(json['activeBabyId']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertFamilyVariables otherTyped = other as UpsertFamilyVariables;
    return id == otherTyped.id && 
    activeBabyId == otherTyped.activeBabyId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, activeBabyId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(activeBabyId.state == OptionalState.set) {
      json['activeBabyId'] = activeBabyId.toJson();
    }
    return json;
  }

  UpsertFamilyVariables({
    required this.id,
    required this.activeBabyId,
  });
}

