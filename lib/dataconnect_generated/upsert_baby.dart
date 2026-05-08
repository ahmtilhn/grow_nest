part of 'generated.dart';

class UpsertBabyVariablesBuilder {
  String id;
  String familyId;
  String name;
  Timestamp birthDate;
  Optional<String> _gender = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _birthWeight = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _birthHeight = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _birthHeadCircumference = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _currentWeight = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _currentHeight = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _currentHeadCircumference = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  UpsertBabyVariablesBuilder gender(String? t) {
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

  UpsertBabyVariablesBuilder(this._dataConnect, {required  this.id,required  this.familyId,required  this.name,required  this.birthDate,});
  Deserializer<UpsertBabyData> dataDeserializer = (dynamic json)  => UpsertBabyData.fromJson(jsonDecode(json));
  Serializer<UpsertBabyVariables> varsSerializer = (UpsertBabyVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertBabyData, UpsertBabyVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertBabyData, UpsertBabyVariables> ref() {
    UpsertBabyVariables vars= UpsertBabyVariables(id: id,familyId: familyId,name: name,birthDate: birthDate,gender: _gender,birthWeight: _birthWeight,birthHeight: _birthHeight,birthHeadCircumference: _birthHeadCircumference,currentWeight: _currentWeight,currentHeight: _currentHeight,currentHeadCircumference: _currentHeadCircumference,);
    return _dataConnect.mutation("UpsertBaby", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertBabyBabyUpsert {
  final String id;
  UpsertBabyBabyUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertBabyBabyUpsert otherTyped = other as UpsertBabyBabyUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertBabyBabyUpsert({
    required this.id,
  });
}

@immutable
class UpsertBabyData {
  final UpsertBabyBabyUpsert baby_upsert;
  UpsertBabyData.fromJson(dynamic json):
  
  baby_upsert = UpsertBabyBabyUpsert.fromJson(json['baby_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertBabyData otherTyped = other as UpsertBabyData;
    return baby_upsert == otherTyped.baby_upsert;
    
  }
  @override
  int get hashCode => baby_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['baby_upsert'] = baby_upsert.toJson();
    return json;
  }

  UpsertBabyData({
    required this.baby_upsert,
  });
}

@immutable
class UpsertBabyVariables {
  final String id;
  final String familyId;
  final String name;
  final Timestamp birthDate;
  late final Optional<String>gender;
  late final Optional<double>birthWeight;
  late final Optional<double>birthHeight;
  late final Optional<double>birthHeadCircumference;
  late final Optional<double>currentWeight;
  late final Optional<double>currentHeight;
  late final Optional<double>currentHeadCircumference;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertBabyVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  familyId = nativeFromJson<String>(json['familyId']),
  name = nativeFromJson<String>(json['name']),
  birthDate = Timestamp.fromJson(json['birthDate']) {
  
  
  
  
  
  
    gender = Optional.optional(nativeFromJson, nativeToJson);
    gender.value = json['gender'] == null ? null : nativeFromJson<String>(json['gender']);
  
  
    birthWeight = Optional.optional(nativeFromJson, nativeToJson);
    birthWeight.value = json['birthWeight'] == null ? null : nativeFromJson<double>(json['birthWeight']);
  
  
    birthHeight = Optional.optional(nativeFromJson, nativeToJson);
    birthHeight.value = json['birthHeight'] == null ? null : nativeFromJson<double>(json['birthHeight']);
  
  
    birthHeadCircumference = Optional.optional(nativeFromJson, nativeToJson);
    birthHeadCircumference.value = json['birthHeadCircumference'] == null ? null : nativeFromJson<double>(json['birthHeadCircumference']);
  
  
    currentWeight = Optional.optional(nativeFromJson, nativeToJson);
    currentWeight.value = json['currentWeight'] == null ? null : nativeFromJson<double>(json['currentWeight']);
  
  
    currentHeight = Optional.optional(nativeFromJson, nativeToJson);
    currentHeight.value = json['currentHeight'] == null ? null : nativeFromJson<double>(json['currentHeight']);
  
  
    currentHeadCircumference = Optional.optional(nativeFromJson, nativeToJson);
    currentHeadCircumference.value = json['currentHeadCircumference'] == null ? null : nativeFromJson<double>(json['currentHeadCircumference']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertBabyVariables otherTyped = other as UpsertBabyVariables;
    return id == otherTyped.id && 
    familyId == otherTyped.familyId && 
    name == otherTyped.name && 
    birthDate == otherTyped.birthDate && 
    gender == otherTyped.gender && 
    birthWeight == otherTyped.birthWeight && 
    birthHeight == otherTyped.birthHeight && 
    birthHeadCircumference == otherTyped.birthHeadCircumference && 
    currentWeight == otherTyped.currentWeight && 
    currentHeight == otherTyped.currentHeight && 
    currentHeadCircumference == otherTyped.currentHeadCircumference;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, familyId.hashCode, name.hashCode, birthDate.hashCode, gender.hashCode, birthWeight.hashCode, birthHeight.hashCode, birthHeadCircumference.hashCode, currentWeight.hashCode, currentHeight.hashCode, currentHeadCircumference.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['familyId'] = nativeToJson<String>(familyId);
    json['name'] = nativeToJson<String>(name);
    json['birthDate'] = birthDate.toJson();
    if(gender.state == OptionalState.set) {
      json['gender'] = gender.toJson();
    }
    if(birthWeight.state == OptionalState.set) {
      json['birthWeight'] = birthWeight.toJson();
    }
    if(birthHeight.state == OptionalState.set) {
      json['birthHeight'] = birthHeight.toJson();
    }
    if(birthHeadCircumference.state == OptionalState.set) {
      json['birthHeadCircumference'] = birthHeadCircumference.toJson();
    }
    if(currentWeight.state == OptionalState.set) {
      json['currentWeight'] = currentWeight.toJson();
    }
    if(currentHeight.state == OptionalState.set) {
      json['currentHeight'] = currentHeight.toJson();
    }
    if(currentHeadCircumference.state == OptionalState.set) {
      json['currentHeadCircumference'] = currentHeadCircumference.toJson();
    }
    return json;
  }

  UpsertBabyVariables({
    required this.id,
    required this.familyId,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.birthWeight,
    required this.birthHeight,
    required this.birthHeadCircumference,
    required this.currentWeight,
    required this.currentHeight,
    required this.currentHeadCircumference,
  });
}

