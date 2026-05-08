part of 'generated.dart';

class DeclineFamilyPartnerInviteVariablesBuilder {
  String familyId;
  String email;

  final FirebaseDataConnect _dataConnect;
  DeclineFamilyPartnerInviteVariablesBuilder(this._dataConnect, {required  this.familyId,required  this.email,});
  Deserializer<DeclineFamilyPartnerInviteData> dataDeserializer = (dynamic json)  => DeclineFamilyPartnerInviteData.fromJson(jsonDecode(json));
  Serializer<DeclineFamilyPartnerInviteVariables> varsSerializer = (DeclineFamilyPartnerInviteVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeclineFamilyPartnerInviteData, DeclineFamilyPartnerInviteVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeclineFamilyPartnerInviteData, DeclineFamilyPartnerInviteVariables> ref() {
    DeclineFamilyPartnerInviteVariables vars= DeclineFamilyPartnerInviteVariables(familyId: familyId,email: email,);
    return _dataConnect.mutation("DeclineFamilyPartnerInvite", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeclineFamilyPartnerInviteFamilyPartnerUpdate {
  final String familyId;
  final String email;
  DeclineFamilyPartnerInviteFamilyPartnerUpdate.fromJson(dynamic json):
  
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

    final DeclineFamilyPartnerInviteFamilyPartnerUpdate otherTyped = other as DeclineFamilyPartnerInviteFamilyPartnerUpdate;
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

  DeclineFamilyPartnerInviteFamilyPartnerUpdate({
    required this.familyId,
    required this.email,
  });
}

@immutable
class DeclineFamilyPartnerInviteData {
  final DeclineFamilyPartnerInviteFamilyPartnerUpdate? familyPartner_update;
  DeclineFamilyPartnerInviteData.fromJson(dynamic json):
  
  familyPartner_update = json['familyPartner_update'] == null ? null : DeclineFamilyPartnerInviteFamilyPartnerUpdate.fromJson(json['familyPartner_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeclineFamilyPartnerInviteData otherTyped = other as DeclineFamilyPartnerInviteData;
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

  DeclineFamilyPartnerInviteData({
    this.familyPartner_update,
  });
}

@immutable
class DeclineFamilyPartnerInviteVariables {
  final String familyId;
  final String email;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeclineFamilyPartnerInviteVariables.fromJson(Map<String, dynamic> json):
  
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

    final DeclineFamilyPartnerInviteVariables otherTyped = other as DeclineFamilyPartnerInviteVariables;
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

  DeclineFamilyPartnerInviteVariables({
    required this.familyId,
    required this.email,
  });
}

