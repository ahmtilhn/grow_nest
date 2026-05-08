part of 'generated.dart';

class GetMyProfileVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetMyProfileVariablesBuilder(this._dataConnect, );
  Deserializer<GetMyProfileData> dataDeserializer = (dynamic json)  => GetMyProfileData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetMyProfileData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetMyProfileData, void> ref() {
    
    return _dataConnect.query("GetMyProfile", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetMyProfileUser {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final Timestamp? birthDate;
  final String? phone;
  final String? role;
  final String language;
  final String theme;
  GetMyProfileUser.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  email = nativeFromJson<String>(json['email']),
  displayName = json['displayName'] == null ? null : nativeFromJson<String>(json['displayName']),
  avatarUrl = json['avatarUrl'] == null ? null : nativeFromJson<String>(json['avatarUrl']),
  birthDate = json['birthDate'] == null ? null : Timestamp.fromJson(json['birthDate']),
  phone = json['phone'] == null ? null : nativeFromJson<String>(json['phone']),
  role = json['role'] == null ? null : nativeFromJson<String>(json['role']),
  language = nativeFromJson<String>(json['language']),
  theme = nativeFromJson<String>(json['theme']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyProfileUser otherTyped = other as GetMyProfileUser;
    return id == otherTyped.id && 
    email == otherTyped.email && 
    displayName == otherTyped.displayName && 
    avatarUrl == otherTyped.avatarUrl && 
    birthDate == otherTyped.birthDate && 
    phone == otherTyped.phone && 
    role == otherTyped.role && 
    language == otherTyped.language && 
    theme == otherTyped.theme;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, email.hashCode, displayName.hashCode, avatarUrl.hashCode, birthDate.hashCode, phone.hashCode, role.hashCode, language.hashCode, theme.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['email'] = nativeToJson<String>(email);
    if (displayName != null) {
      json['displayName'] = nativeToJson<String?>(displayName);
    }
    if (avatarUrl != null) {
      json['avatarUrl'] = nativeToJson<String?>(avatarUrl);
    }
    if (birthDate != null) {
      json['birthDate'] = birthDate!.toJson();
    }
    if (phone != null) {
      json['phone'] = nativeToJson<String?>(phone);
    }
    if (role != null) {
      json['role'] = nativeToJson<String?>(role);
    }
    json['language'] = nativeToJson<String>(language);
    json['theme'] = nativeToJson<String>(theme);
    return json;
  }

  GetMyProfileUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.birthDate,
    this.phone,
    this.role,
    required this.language,
    required this.theme,
  });
}

@immutable
class GetMyProfileData {
  final GetMyProfileUser? user;
  GetMyProfileData.fromJson(dynamic json):
  
  user = json['user'] == null ? null : GetMyProfileUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetMyProfileData otherTyped = other as GetMyProfileData;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  GetMyProfileData({
    this.user,
  });
}

