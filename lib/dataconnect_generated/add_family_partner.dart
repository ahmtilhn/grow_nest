part of 'generated.dart';

class AddFamilyPartnerVariablesBuilder {
  String familyId;
  String email;

  final FirebaseDataConnect _dataConnect;
  AddFamilyPartnerVariablesBuilder(this._dataConnect, {required  this.familyId,required  this.email,});
  Deserializer<AddFamilyPartnerData> dataDeserializer = (dynamic json)  => AddFamilyPartnerData.fromJson(jsonDecode(json));
  Serializer<AddFamilyPartnerVariables> varsSerializer = (AddFamilyPartnerVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddFamilyPartnerData, AddFamilyPartnerVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddFamilyPartnerData, AddFamilyPartnerVariables> ref() {
    AddFamilyPartnerVariables vars= AddFamilyPartnerVariables(familyId: familyId,email: email,);
    return _dataConnect.mutation("AddFamilyPartner", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddFamilyPartnerFamilyPartnerUpsert {
  final String familyId;
  final String email;
  AddFamilyPartnerFamilyPartnerUpsert.fromJson(dynamic json):
  
  familyId = nativeFromJson<String>(json['familyId']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddFamilyPartnerFamilyPartnerUpsert otherTyped = other as AddFamilyPartnerFamilyPartnerUpsert;
    return familyId == otherTyped.familyId && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([familyId.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['familyId'] = nativeToJson<String>(familyId);
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  AddFamilyPartnerFamilyPartnerUpsert({
    required this.familyId,
    required this.email,
  });
}

@immutable
class AddFamilyPartnerData {
  final AddFamilyPartnerFamilyPartnerUpsert familyPartner_upsert;
  AddFamilyPartnerData.fromJson(dynamic json):
  
  familyPartner_upsert = AddFamilyPartnerFamilyPartnerUpsert.fromJson(json['familyPartner_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddFamilyPartnerData otherTyped = other as AddFamilyPartnerData;
    return familyPartner_upsert == otherTyped.familyPartner_upsert;
    
  }
  @override
  int get hashCode => familyPartner_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['familyPartner_upsert'] = familyPartner_upsert.toJson();
    return json;
  }

  AddFamilyPartnerData({
    required this.familyPartner_upsert,
  });
}

@immutable
class AddFamilyPartnerVariables {
  final String familyId;
  final String email;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddFamilyPartnerVariables.fromJson(Map<String, dynamic> json):
  
  familyId = nativeFromJson<String>(json['familyId']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddFamilyPartnerVariables otherTyped = other as AddFamilyPartnerVariables;
    return familyId == otherTyped.familyId && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([familyId.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['familyId'] = nativeToJson<String>(familyId);
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  AddFamilyPartnerVariables({
    required this.familyId,
    required this.email,
  });
}

