part of 'generated.dart';

class UpsertCurrentUserVariablesBuilder {
  String email;
  Optional<String> _displayName = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _avatarUrl = Optional.optional(nativeFromJson, nativeToJson);
  Optional<Timestamp> _birthDate = Optional.optional((json) => json['birthDate'] = Timestamp.fromJson(json['birthDate']), defaultSerializer);
  Optional<String> _phone = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _role = Optional.optional(nativeFromJson, nativeToJson);
  String language;
  String theme;

  final FirebaseDataConnect _dataConnect;  UpsertCurrentUserVariablesBuilder displayName(String? t) {
   _displayName.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder avatarUrl(String? t) {
   _avatarUrl.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder birthDate(Timestamp? t) {
   _birthDate.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder phone(String? t) {
   _phone.value = t;
   return this;
  }
  UpsertCurrentUserVariablesBuilder role(String? t) {
   _role.value = t;
   return this;
  }

  UpsertCurrentUserVariablesBuilder(this._dataConnect, {required  this.email,required  this.language,required  this.theme,});
  Deserializer<UpsertCurrentUserData> dataDeserializer = (dynamic json)  => UpsertCurrentUserData.fromJson(jsonDecode(json));
  Serializer<UpsertCurrentUserVariables> varsSerializer = (UpsertCurrentUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCurrentUserData, UpsertCurrentUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCurrentUserData, UpsertCurrentUserVariables> ref() {
    UpsertCurrentUserVariables vars= UpsertCurrentUserVariables(email: email,displayName: _displayName,avatarUrl: _avatarUrl,birthDate: _birthDate,phone: _phone,role: _role,language: language,theme: theme,);
    return _dataConnect.mutation("UpsertCurrentUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCurrentUserUserUpsert {
  final String id;
  UpsertCurrentUserUserUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCurrentUserUserUpsert otherTyped = other as UpsertCurrentUserUserUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertCurrentUserUserUpsert({
    required this.id,
  });
}

@immutable
class UpsertCurrentUserData {
  final UpsertCurrentUserUserUpsert user_upsert;
  UpsertCurrentUserData.fromJson(dynamic json):
  
  user_upsert = UpsertCurrentUserUserUpsert.fromJson(json['user_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCurrentUserData otherTyped = other as UpsertCurrentUserData;
    return user_upsert == otherTyped.user_upsert;
    
  }
  @override
  int get hashCode => user_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_upsert'] = user_upsert.toJson();
    return json;
  }

  UpsertCurrentUserData({
    required this.user_upsert,
  });
}

@immutable
class UpsertCurrentUserVariables {
  final String email;
  late final Optional<String>displayName;
  late final Optional<String>avatarUrl;
  late final Optional<Timestamp>birthDate;
  late final Optional<String>phone;
  late final Optional<String>role;
  final String language;
  final String theme;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCurrentUserVariables.fromJson(Map<String, dynamic> json):
  
  email = nativeFromJson<String>(json['email']),
  language = nativeFromJson<String>(json['language']),
  theme = nativeFromJson<String>(json['theme']) {
  
  
  
    displayName = Optional.optional(nativeFromJson, nativeToJson);
    displayName.value = json['displayName'] == null ? null : nativeFromJson<String>(json['displayName']);
  
  
    avatarUrl = Optional.optional(nativeFromJson, nativeToJson);
    avatarUrl.value = json['avatarUrl'] == null ? null : nativeFromJson<String>(json['avatarUrl']);
  
  
    birthDate = Optional.optional((json) => json['birthDate'] = Timestamp.fromJson(json['birthDate']), defaultSerializer);
    birthDate.value = json['birthDate'] == null ? null : Timestamp.fromJson(json['birthDate']);
  
  
    phone = Optional.optional(nativeFromJson, nativeToJson);
    phone.value = json['phone'] == null ? null : nativeFromJson<String>(json['phone']);
  
  
    role = Optional.optional(nativeFromJson, nativeToJson);
    role.value = json['role'] == null ? null : nativeFromJson<String>(json['role']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCurrentUserVariables otherTyped = other as UpsertCurrentUserVariables;
    return email == otherTyped.email && 
    displayName == otherTyped.displayName && 
    avatarUrl == otherTyped.avatarUrl && 
    birthDate == otherTyped.birthDate && 
    phone == otherTyped.phone && 
    role == otherTyped.role && 
    language == otherTyped.language && 
    theme == otherTyped.theme;
    
  }
  @override
  int get hashCode => Object.hashAll([email.hashCode, displayName.hashCode, avatarUrl.hashCode, birthDate.hashCode, phone.hashCode, role.hashCode, language.hashCode, theme.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['email'] = nativeToJson<String>(email);
    if(displayName.state == OptionalState.set) {
      json['displayName'] = displayName.toJson();
    }
    if(avatarUrl.state == OptionalState.set) {
      json['avatarUrl'] = avatarUrl.toJson();
    }
    if(birthDate.state == OptionalState.set) {
      json['birthDate'] = birthDate.toJson();
    }
    if(phone.state == OptionalState.set) {
      json['phone'] = phone.toJson();
    }
    if(role.state == OptionalState.set) {
      json['role'] = role.toJson();
    }
    json['language'] = nativeToJson<String>(language);
    json['theme'] = nativeToJson<String>(theme);
    return json;
  }

  UpsertCurrentUserVariables({
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.birthDate,
    required this.phone,
    required this.role,
    required this.language,
    required this.theme,
  });
}

