part of 'generated.dart';

class ListMyFamiliesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListMyFamiliesVariablesBuilder(this._dataConnect, );
  Deserializer<ListMyFamiliesData> dataDeserializer = (dynamic json)  => ListMyFamiliesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListMyFamiliesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<ListMyFamiliesData, void> ref() {
    
    return _dataConnect.query("ListMyFamilies", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMyFamiliesFamilies {
  final String id;
  final String ownerUserId;
  final String? activeBabyId;
  final Timestamp createdAt;
  final List<ListMyFamiliesFamiliesPartners> partners;
  final List<ListMyFamiliesFamiliesBabies> babies;
  ListMyFamiliesFamilies.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  ownerUserId = nativeFromJson<String>(json['ownerUserId']),
  activeBabyId = json['activeBabyId'] == null ? null : nativeFromJson<String>(json['activeBabyId']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  partners = (json['partners'] as List<dynamic>)
        .map((e) => ListMyFamiliesFamiliesPartners.fromJson(e))
        .toList(),
  babies = (json['babies'] as List<dynamic>)
        .map((e) => ListMyFamiliesFamiliesBabies.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyFamiliesFamilies otherTyped = other as ListMyFamiliesFamilies;
    return id == otherTyped.id && 
    ownerUserId == otherTyped.ownerUserId && 
    activeBabyId == otherTyped.activeBabyId && 
    createdAt == otherTyped.createdAt && 
    partners == otherTyped.partners && 
    babies == otherTyped.babies;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, ownerUserId.hashCode, activeBabyId.hashCode, createdAt.hashCode, partners.hashCode, babies.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['ownerUserId'] = nativeToJson<String>(ownerUserId);
    if (activeBabyId != null) {
      json['activeBabyId'] = nativeToJson<String?>(activeBabyId);
    }
    json['createdAt'] = createdAt.toJson();
    json['partners'] = partners.map((e) => e.toJson()).toList();
    json['babies'] = babies.map((e) => e.toJson()).toList();
    return json;
  }

  ListMyFamiliesFamilies({
    required this.id,
    required this.ownerUserId,
    this.activeBabyId,
    required this.createdAt,
    required this.partners,
    required this.babies,
  });
}

@immutable
class ListMyFamiliesFamiliesPartners {
  final String email;
  final String status;
  final String? acceptedUserId;
  final Timestamp createdAt;
  final Timestamp? respondedAt;
  ListMyFamiliesFamiliesPartners.fromJson(dynamic json):
  
  email = nativeFromJson<String>(json['email']),
  status = nativeFromJson<String>(json['status']),
  acceptedUserId = json['acceptedUserId'] == null ? null : nativeFromJson<String>(json['acceptedUserId']),
  createdAt = Timestamp.fromJson(json['createdAt']),
  respondedAt = json['respondedAt'] == null ? null : Timestamp.fromJson(json['respondedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyFamiliesFamiliesPartners otherTyped = other as ListMyFamiliesFamiliesPartners;
    return email == otherTyped.email && 
    status == otherTyped.status && 
    acceptedUserId == otherTyped.acceptedUserId && 
    createdAt == otherTyped.createdAt && 
    respondedAt == otherTyped.respondedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([email.hashCode, status.hashCode, acceptedUserId.hashCode, createdAt.hashCode, respondedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = nativeToJson<String>(email);
    json['status'] = nativeToJson<String>(status);
    if (acceptedUserId != null) {
      json['acceptedUserId'] = nativeToJson<String?>(acceptedUserId);
    }
    json['createdAt'] = createdAt.toJson();
    if (respondedAt != null) {
      json['respondedAt'] = respondedAt!.toJson();
    }
    return json;
  }

  ListMyFamiliesFamiliesPartners({
    required this.email,
    required this.status,
    this.acceptedUserId,
    required this.createdAt,
    this.respondedAt,
  });
}

@immutable
class ListMyFamiliesFamiliesBabies {
  final String id;
  final String name;
  final Timestamp birthDate;
  final String? gender;
  final double? currentWeight;
  final double? currentHeight;
  final double? currentHeadCircumference;
  final Timestamp createdAt;
  ListMyFamiliesFamiliesBabies.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  birthDate = Timestamp.fromJson(json['birthDate']),
  gender = json['gender'] == null ? null : nativeFromJson<String>(json['gender']),
  currentWeight = json['currentWeight'] == null ? null : nativeFromJson<double>(json['currentWeight']),
  currentHeight = json['currentHeight'] == null ? null : nativeFromJson<double>(json['currentHeight']),
  currentHeadCircumference = json['currentHeadCircumference'] == null ? null : nativeFromJson<double>(json['currentHeadCircumference']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyFamiliesFamiliesBabies otherTyped = other as ListMyFamiliesFamiliesBabies;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    birthDate == otherTyped.birthDate && 
    gender == otherTyped.gender && 
    currentWeight == otherTyped.currentWeight && 
    currentHeight == otherTyped.currentHeight && 
    currentHeadCircumference == otherTyped.currentHeadCircumference && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, birthDate.hashCode, gender.hashCode, currentWeight.hashCode, currentHeight.hashCode, currentHeadCircumference.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['birthDate'] = birthDate.toJson();
    if (gender != null) {
      json['gender'] = nativeToJson<String?>(gender);
    }
    if (currentWeight != null) {
      json['currentWeight'] = nativeToJson<double?>(currentWeight);
    }
    if (currentHeight != null) {
      json['currentHeight'] = nativeToJson<double?>(currentHeight);
    }
    if (currentHeadCircumference != null) {
      json['currentHeadCircumference'] = nativeToJson<double?>(currentHeadCircumference);
    }
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  ListMyFamiliesFamiliesBabies({
    required this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    this.currentWeight,
    this.currentHeight,
    this.currentHeadCircumference,
    required this.createdAt,
  });
}

@immutable
class ListMyFamiliesData {
  final List<ListMyFamiliesFamilies> families;
  ListMyFamiliesData.fromJson(dynamic json):
  
  families = (json['families'] as List<dynamic>)
        .map((e) => ListMyFamiliesFamilies.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyFamiliesData otherTyped = other as ListMyFamiliesData;
    return families == otherTyped.families;
    
  }
  @override
  int get hashCode => families.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['families'] = families.map((e) => e.toJson()).toList();
    return json;
  }

  ListMyFamiliesData({
    required this.families,
  });
}

