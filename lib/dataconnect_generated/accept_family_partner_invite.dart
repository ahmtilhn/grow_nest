part of 'generated.dart';

class AcceptFamilyPartnerInviteVariablesBuilder {
  String familyId;
  String email;

  final FirebaseDataConnect _dataConnect;
  AcceptFamilyPartnerInviteVariablesBuilder(this._dataConnect, {required  this.familyId,required  this.email,});
  Deserializer<AcceptFamilyPartnerInviteData> dataDeserializer = (dynamic json)  => AcceptFamilyPartnerInviteData.fromJson(jsonDecode(json));
  Serializer<AcceptFamilyPartnerInviteVariables> varsSerializer = (AcceptFamilyPartnerInviteVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AcceptFamilyPartnerInviteData, AcceptFamilyPartnerInviteVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AcceptFamilyPartnerInviteData, AcceptFamilyPartnerInviteVariables> ref() {
    AcceptFamilyPartnerInviteVariables vars= AcceptFamilyPartnerInviteVariables(familyId: familyId,email: email,);
    return _dataConnect.mutation("AcceptFamilyPartnerInvite", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AcceptFamilyPartnerInviteFamilyPartnerUpdate {
  final String familyId;
  final String email;
  AcceptFamilyPartnerInviteFamilyPartnerUpdate.fromJson(dynamic json):
  
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

    final AcceptFamilyPartnerInviteFamilyPartnerUpdate otherTyped = other as AcceptFamilyPartnerInviteFamilyPartnerUpdate;
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

  AcceptFamilyPartnerInviteFamilyPartnerUpdate({
    required this.familyId,
    required this.email,
  });
}

@immutable
class AcceptFamilyPartnerInviteData {
  final AcceptFamilyPartnerInviteFamilyPartnerUpdate? familyPartner_update;
  AcceptFamilyPartnerInviteData.fromJson(dynamic json):
  
  familyPartner_update = json['familyPartner_update'] == null ? null : AcceptFamilyPartnerInviteFamilyPartnerUpdate.fromJson(json['familyPartner_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AcceptFamilyPartnerInviteData otherTyped = other as AcceptFamilyPartnerInviteData;
    return familyPartner_update == otherTyped.familyPartner_update;
    
  }
  @override
  int get hashCode => familyPartner_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (familyPartner_update != null) {
      json['familyPartner_update'] = familyPartner_update!.toJson();
    }
    return json;
  }

  AcceptFamilyPartnerInviteData({
    this.familyPartner_update,
  });
}

@immutable
class AcceptFamilyPartnerInviteVariables {
  final String familyId;
  final String email;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AcceptFamilyPartnerInviteVariables.fromJson(Map<String, dynamic> json):
  
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

    final AcceptFamilyPartnerInviteVariables otherTyped = other as AcceptFamilyPartnerInviteVariables;
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

  AcceptFamilyPartnerInviteVariables({
    required this.familyId,
    required this.email,
  });
}

