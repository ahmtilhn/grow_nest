part of 'generated.dart';

class ListPendingInvitesForMeVariablesBuilder {
  String email;

  final FirebaseDataConnect _dataConnect;
  ListPendingInvitesForMeVariablesBuilder(this._dataConnect, {required  this.email,});
  Deserializer<ListPendingInvitesForMeData> dataDeserializer = (dynamic json)  => ListPendingInvitesForMeData.fromJson(jsonDecode(json));
  Serializer<ListPendingInvitesForMeVariables> varsSerializer = (ListPendingInvitesForMeVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListPendingInvitesForMeData, ListPendingInvitesForMeVariables>> execute() {
    return ref().execute();
  }

  QueryRef<ListPendingInvitesForMeData, ListPendingInvitesForMeVariables> ref() {
    ListPendingInvitesForMeVariables vars= ListPendingInvitesForMeVariables(email: email,);
    return _dataConnect.query("ListPendingInvitesForMe", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListPendingInvitesForMeFamilyPartners {
  final String familyId;
  final String email;
  final String invitedByUserId;
  final String status;
  final Timestamp createdAt;
  final ListPendingInvitesForMeFamilyPartnersInvitedBy invitedBy;
  final ListPendingInvitesForMeFamilyPartnersFamily family;
  ListPendingInvitesForMeFamilyPartners.fromJson(dynamic json):
  
  familyId = nativeFromJson<String>(json['familyId']),
  email = nativeFromJson<String>(json['email']),
  invitedByUserId = nativeFromJson<String>(json['invitedByUserId']),
  status = nativeFromJson<String>(json['status']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  invitedBy = ListPendingInvitesForMeFamilyPartnersInvitedBy.fromJson(json['invitedBy']),
  family = ListPendingInvitesForMeFamilyPartnersFamily.fromJson(json['family']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingInvitesForMeFamilyPartners otherTyped = other as ListPendingInvitesForMeFamilyPartners;
    return familyId == otherTyped.familyId && 
    email == otherTyped.email && 
    invitedByUserId == otherTyped.invitedByUserId && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    invitedBy == otherTyped.invitedBy && 
    family == otherTyped.family;
    
  }
  @override
  int get hashCode => Object.hashAll([familyId.hashCode, email.hashCode, invitedByUserId.hashCode, status.hashCode, createdAt.hashCode, invitedBy.hashCode, family.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['familyId'] = nativeToJson<String>(familyId);
    json['email'] = nativeToJson<String>(email);
    json['invitedByUserId'] = nativeToJson<String>(invitedByUserId);
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = createdAt.toJson();
    json['invitedBy'] = invitedBy.toJson();
    json['family'] = family.toJson();
    return json;
  }

  ListPendingInvitesForMeFamilyPartners({
    required this.familyId,
    required this.email,
    required this.invitedByUserId,
    required this.status,
    required this.createdAt,
    required this.invitedBy,
    required this.family,
  });
}

@immutable
class ListPendingInvitesForMeFamilyPartnersInvitedBy {
  final String? displayName;
  final String email;
  ListPendingInvitesForMeFamilyPartnersInvitedBy.fromJson(dynamic json):
  
  displayName = json['displayName'] == null ? null : nativeFromJson<String>(json['displayName']),
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingInvitesForMeFamilyPartnersInvitedBy otherTyped = other as ListPendingInvitesForMeFamilyPartnersInvitedBy;
    return displayName == otherTyped.displayName && 
    email == otherTyped.email;
    
  }
  @override
  int get hashCode => Object.hashAll([displayName.hashCode, email.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (displayName != null) {
      json['displayName'] = nativeToJson<String?>(displayName);
    }
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  ListPendingInvitesForMeFamilyPartnersInvitedBy({
    this.displayName,
    required this.email,
  });
}

@immutable
class ListPendingInvitesForMeFamilyPartnersFamily {
  final String id;
  final String ownerUserId;
  final String? activeBabyId;
  ListPendingInvitesForMeFamilyPartnersFamily.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  ownerUserId = nativeFromJson<String>(json['ownerUserId']),
  activeBabyId = json['activeBabyId'] == null ? null : nativeFromJson<String>(json['activeBabyId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingInvitesForMeFamilyPartnersFamily otherTyped = other as ListPendingInvitesForMeFamilyPartnersFamily;
    return id == otherTyped.id && 
    ownerUserId == otherTyped.ownerUserId && 
    activeBabyId == otherTyped.activeBabyId;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, ownerUserId.hashCode, activeBabyId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['ownerUserId'] = nativeToJson<String>(ownerUserId);
    if (activeBabyId != null) {
      json['activeBabyId'] = nativeToJson<String?>(activeBabyId);
    }
    return json;
  }

  ListPendingInvitesForMeFamilyPartnersFamily({
    required this.id,
    required this.ownerUserId,
    this.activeBabyId,
  });
}

@immutable
class ListPendingInvitesForMeData {
  final List<ListPendingInvitesForMeFamilyPartners> familyPartners;
  ListPendingInvitesForMeData.fromJson(dynamic json):
  
  familyPartners = (json['familyPartners'] as List<dynamic>)
        .map((e) => ListPendingInvitesForMeFamilyPartners.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingInvitesForMeData otherTyped = other as ListPendingInvitesForMeData;
    return familyPartners == otherTyped.familyPartners;
    
  }
  @override
  int get hashCode => familyPartners.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['familyPartners'] = familyPartners.map((e) => e.toJson()).toList();
    return json;
  }

  ListPendingInvitesForMeData({
    required this.familyPartners,
  });
}

@immutable
class ListPendingInvitesForMeVariables {
  final String email;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListPendingInvitesForMeVariables.fromJson(Map<String, dynamic> json):
  
  email = nativeFromJson<String>(json['email']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPendingInvitesForMeVariables otherTyped = other as ListPendingInvitesForMeVariables;
    return email == otherTyped.email;
    
  }
  @override
  int get hashCode => email.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = nativeToJson<String>(email);
    return json;
  }

  ListPendingInvitesForMeVariables({
    required this.email,
  });
}

