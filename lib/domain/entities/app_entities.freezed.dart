// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get name; String get email; bool get emailVerified; String? get avatarUrl; DateTime? get birthDate; String? get phone; String? get role; DateTime get createdAt; String get language; String get theme;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.theme, theme) || other.theme == theme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,emailVerified,avatarUrl,birthDate,phone,role,createdAt,language,theme);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, emailVerified: $emailVerified, avatarUrl: $avatarUrl, birthDate: $birthDate, phone: $phone, role: $role, createdAt: $createdAt, language: $language, theme: $theme)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, bool emailVerified, String? avatarUrl, DateTime? birthDate, String? phone, String? role, DateTime createdAt, String language, String theme
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? emailVerified = null,Object? avatarUrl = freezed,Object? birthDate = freezed,Object? phone = freezed,Object? role = freezed,Object? createdAt = null,Object? language = null,Object? theme = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  bool emailVerified,  String? avatarUrl,  DateTime? birthDate,  String? phone,  String? role,  DateTime createdAt,  String language,  String theme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.emailVerified,_that.avatarUrl,_that.birthDate,_that.phone,_that.role,_that.createdAt,_that.language,_that.theme);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  bool emailVerified,  String? avatarUrl,  DateTime? birthDate,  String? phone,  String? role,  DateTime createdAt,  String language,  String theme)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.name,_that.email,_that.emailVerified,_that.avatarUrl,_that.birthDate,_that.phone,_that.role,_that.createdAt,_that.language,_that.theme);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  bool emailVerified,  String? avatarUrl,  DateTime? birthDate,  String? phone,  String? role,  DateTime createdAt,  String language,  String theme)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.emailVerified,_that.avatarUrl,_that.birthDate,_that.phone,_that.role,_that.createdAt,_that.language,_that.theme);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, required this.name, required this.email, this.emailVerified = false, this.avatarUrl, this.birthDate, this.phone, this.role, required this.createdAt, this.language = 'tr', this.theme = 'light'});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey() final  bool emailVerified;
@override final  String? avatarUrl;
@override final  DateTime? birthDate;
@override final  String? phone;
@override final  String? role;
@override final  DateTime createdAt;
@override@JsonKey() final  String language;
@override@JsonKey() final  String theme;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.theme, theme) || other.theme == theme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,emailVerified,avatarUrl,birthDate,phone,role,createdAt,language,theme);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, emailVerified: $emailVerified, avatarUrl: $avatarUrl, birthDate: $birthDate, phone: $phone, role: $role, createdAt: $createdAt, language: $language, theme: $theme)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, bool emailVerified, String? avatarUrl, DateTime? birthDate, String? phone, String? role, DateTime createdAt, String language, String theme
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? emailVerified = null,Object? avatarUrl = freezed,Object? birthDate = freezed,Object? phone = freezed,Object? role = freezed,Object? createdAt = null,Object? language = null,Object? theme = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Family {

 String get id; String get ownerUserId; List<String> get partnerUserIds; String? get activeBabyId; DateTime get createdAt;
/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyCopyWith<Family> get copyWith => _$FamilyCopyWithImpl<Family>(this as Family, _$identity);

  /// Serializes this Family to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Family&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&const DeepCollectionEquality().equals(other.partnerUserIds, partnerUserIds)&&(identical(other.activeBabyId, activeBabyId) || other.activeBabyId == activeBabyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,const DeepCollectionEquality().hash(partnerUserIds),activeBabyId,createdAt);

@override
String toString() {
  return 'Family(id: $id, ownerUserId: $ownerUserId, partnerUserIds: $partnerUserIds, activeBabyId: $activeBabyId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FamilyCopyWith<$Res>  {
  factory $FamilyCopyWith(Family value, $Res Function(Family) _then) = _$FamilyCopyWithImpl;
@useResult
$Res call({
 String id, String ownerUserId, List<String> partnerUserIds, String? activeBabyId, DateTime createdAt
});




}
/// @nodoc
class _$FamilyCopyWithImpl<$Res>
    implements $FamilyCopyWith<$Res> {
  _$FamilyCopyWithImpl(this._self, this._then);

  final Family _self;
  final $Res Function(Family) _then;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerUserId = null,Object? partnerUserIds = null,Object? activeBabyId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,partnerUserIds: null == partnerUserIds ? _self.partnerUserIds : partnerUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,activeBabyId: freezed == activeBabyId ? _self.activeBabyId : activeBabyId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Family].
extension FamilyPatterns on Family {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Family value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Family value)  $default,){
final _that = this;
switch (_that) {
case _Family():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Family value)?  $default,){
final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  List<String> partnerUserIds,  String? activeBabyId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.partnerUserIds,_that.activeBabyId,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerUserId,  List<String> partnerUserIds,  String? activeBabyId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Family():
return $default(_that.id,_that.ownerUserId,_that.partnerUserIds,_that.activeBabyId,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerUserId,  List<String> partnerUserIds,  String? activeBabyId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that.id,_that.ownerUserId,_that.partnerUserIds,_that.activeBabyId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Family implements Family {
  const _Family({required this.id, required this.ownerUserId, final  List<String> partnerUserIds = const [], this.activeBabyId, required this.createdAt}): _partnerUserIds = partnerUserIds;
  factory _Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);

@override final  String id;
@override final  String ownerUserId;
 final  List<String> _partnerUserIds;
@override@JsonKey() List<String> get partnerUserIds {
  if (_partnerUserIds is EqualUnmodifiableListView) return _partnerUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_partnerUserIds);
}

@override final  String? activeBabyId;
@override final  DateTime createdAt;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyCopyWith<_Family> get copyWith => __$FamilyCopyWithImpl<_Family>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Family&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUserId, ownerUserId) || other.ownerUserId == ownerUserId)&&const DeepCollectionEquality().equals(other._partnerUserIds, _partnerUserIds)&&(identical(other.activeBabyId, activeBabyId) || other.activeBabyId == activeBabyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUserId,const DeepCollectionEquality().hash(_partnerUserIds),activeBabyId,createdAt);

@override
String toString() {
  return 'Family(id: $id, ownerUserId: $ownerUserId, partnerUserIds: $partnerUserIds, activeBabyId: $activeBabyId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FamilyCopyWith<$Res> implements $FamilyCopyWith<$Res> {
  factory _$FamilyCopyWith(_Family value, $Res Function(_Family) _then) = __$FamilyCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerUserId, List<String> partnerUserIds, String? activeBabyId, DateTime createdAt
});




}
/// @nodoc
class __$FamilyCopyWithImpl<$Res>
    implements _$FamilyCopyWith<$Res> {
  __$FamilyCopyWithImpl(this._self, this._then);

  final _Family _self;
  final $Res Function(_Family) _then;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerUserId = null,Object? partnerUserIds = null,Object? activeBabyId = freezed,Object? createdAt = null,}) {
  return _then(_Family(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerUserId: null == ownerUserId ? _self.ownerUserId : ownerUserId // ignore: cast_nullable_to_non_nullable
as String,partnerUserIds: null == partnerUserIds ? _self._partnerUserIds : partnerUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,activeBabyId: freezed == activeBabyId ? _self.activeBabyId : activeBabyId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BabyProfile {

 String get id; String get familyId; String get name; DateTime get birthDate; String? get gender; double? get birthWeight; double? get birthHeight; double? get birthHeadCircumference; double? get currentWeight; double? get currentHeight; double? get currentHeadCircumference; DateTime get createdAt;
/// Create a copy of BabyProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BabyProfileCopyWith<BabyProfile> get copyWith => _$BabyProfileCopyWithImpl<BabyProfile>(this as BabyProfile, _$identity);

  /// Serializes this BabyProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BabyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthWeight, birthWeight) || other.birthWeight == birthWeight)&&(identical(other.birthHeight, birthHeight) || other.birthHeight == birthHeight)&&(identical(other.birthHeadCircumference, birthHeadCircumference) || other.birthHeadCircumference == birthHeadCircumference)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.currentHeight, currentHeight) || other.currentHeight == currentHeight)&&(identical(other.currentHeadCircumference, currentHeadCircumference) || other.currentHeadCircumference == currentHeadCircumference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,name,birthDate,gender,birthWeight,birthHeight,birthHeadCircumference,currentWeight,currentHeight,currentHeadCircumference,createdAt);

@override
String toString() {
  return 'BabyProfile(id: $id, familyId: $familyId, name: $name, birthDate: $birthDate, gender: $gender, birthWeight: $birthWeight, birthHeight: $birthHeight, birthHeadCircumference: $birthHeadCircumference, currentWeight: $currentWeight, currentHeight: $currentHeight, currentHeadCircumference: $currentHeadCircumference, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BabyProfileCopyWith<$Res>  {
  factory $BabyProfileCopyWith(BabyProfile value, $Res Function(BabyProfile) _then) = _$BabyProfileCopyWithImpl;
@useResult
$Res call({
 String id, String familyId, String name, DateTime birthDate, String? gender, double? birthWeight, double? birthHeight, double? birthHeadCircumference, double? currentWeight, double? currentHeight, double? currentHeadCircumference, DateTime createdAt
});




}
/// @nodoc
class _$BabyProfileCopyWithImpl<$Res>
    implements $BabyProfileCopyWith<$Res> {
  _$BabyProfileCopyWithImpl(this._self, this._then);

  final BabyProfile _self;
  final $Res Function(BabyProfile) _then;

/// Create a copy of BabyProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? name = null,Object? birthDate = null,Object? gender = freezed,Object? birthWeight = freezed,Object? birthHeight = freezed,Object? birthHeadCircumference = freezed,Object? currentWeight = freezed,Object? currentHeight = freezed,Object? currentHeadCircumference = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthWeight: freezed == birthWeight ? _self.birthWeight : birthWeight // ignore: cast_nullable_to_non_nullable
as double?,birthHeight: freezed == birthHeight ? _self.birthHeight : birthHeight // ignore: cast_nullable_to_non_nullable
as double?,birthHeadCircumference: freezed == birthHeadCircumference ? _self.birthHeadCircumference : birthHeadCircumference // ignore: cast_nullable_to_non_nullable
as double?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,currentHeight: freezed == currentHeight ? _self.currentHeight : currentHeight // ignore: cast_nullable_to_non_nullable
as double?,currentHeadCircumference: freezed == currentHeadCircumference ? _self.currentHeadCircumference : currentHeadCircumference // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BabyProfile].
extension BabyProfilePatterns on BabyProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BabyProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BabyProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BabyProfile value)  $default,){
final _that = this;
switch (_that) {
case _BabyProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BabyProfile value)?  $default,){
final _that = this;
switch (_that) {
case _BabyProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String familyId,  String name,  DateTime birthDate,  String? gender,  double? birthWeight,  double? birthHeight,  double? birthHeadCircumference,  double? currentWeight,  double? currentHeight,  double? currentHeadCircumference,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BabyProfile() when $default != null:
return $default(_that.id,_that.familyId,_that.name,_that.birthDate,_that.gender,_that.birthWeight,_that.birthHeight,_that.birthHeadCircumference,_that.currentWeight,_that.currentHeight,_that.currentHeadCircumference,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String familyId,  String name,  DateTime birthDate,  String? gender,  double? birthWeight,  double? birthHeight,  double? birthHeadCircumference,  double? currentWeight,  double? currentHeight,  double? currentHeadCircumference,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BabyProfile():
return $default(_that.id,_that.familyId,_that.name,_that.birthDate,_that.gender,_that.birthWeight,_that.birthHeight,_that.birthHeadCircumference,_that.currentWeight,_that.currentHeight,_that.currentHeadCircumference,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String familyId,  String name,  DateTime birthDate,  String? gender,  double? birthWeight,  double? birthHeight,  double? birthHeadCircumference,  double? currentWeight,  double? currentHeight,  double? currentHeadCircumference,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BabyProfile() when $default != null:
return $default(_that.id,_that.familyId,_that.name,_that.birthDate,_that.gender,_that.birthWeight,_that.birthHeight,_that.birthHeadCircumference,_that.currentWeight,_that.currentHeight,_that.currentHeadCircumference,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BabyProfile implements BabyProfile {
  const _BabyProfile({required this.id, required this.familyId, required this.name, required this.birthDate, this.gender, this.birthWeight, this.birthHeight, this.birthHeadCircumference, this.currentWeight, this.currentHeight, this.currentHeadCircumference, required this.createdAt});
  factory _BabyProfile.fromJson(Map<String, dynamic> json) => _$BabyProfileFromJson(json);

@override final  String id;
@override final  String familyId;
@override final  String name;
@override final  DateTime birthDate;
@override final  String? gender;
@override final  double? birthWeight;
@override final  double? birthHeight;
@override final  double? birthHeadCircumference;
@override final  double? currentWeight;
@override final  double? currentHeight;
@override final  double? currentHeadCircumference;
@override final  DateTime createdAt;

/// Create a copy of BabyProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BabyProfileCopyWith<_BabyProfile> get copyWith => __$BabyProfileCopyWithImpl<_BabyProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BabyProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BabyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.birthWeight, birthWeight) || other.birthWeight == birthWeight)&&(identical(other.birthHeight, birthHeight) || other.birthHeight == birthHeight)&&(identical(other.birthHeadCircumference, birthHeadCircumference) || other.birthHeadCircumference == birthHeadCircumference)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.currentHeight, currentHeight) || other.currentHeight == currentHeight)&&(identical(other.currentHeadCircumference, currentHeadCircumference) || other.currentHeadCircumference == currentHeadCircumference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,name,birthDate,gender,birthWeight,birthHeight,birthHeadCircumference,currentWeight,currentHeight,currentHeadCircumference,createdAt);

@override
String toString() {
  return 'BabyProfile(id: $id, familyId: $familyId, name: $name, birthDate: $birthDate, gender: $gender, birthWeight: $birthWeight, birthHeight: $birthHeight, birthHeadCircumference: $birthHeadCircumference, currentWeight: $currentWeight, currentHeight: $currentHeight, currentHeadCircumference: $currentHeadCircumference, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BabyProfileCopyWith<$Res> implements $BabyProfileCopyWith<$Res> {
  factory _$BabyProfileCopyWith(_BabyProfile value, $Res Function(_BabyProfile) _then) = __$BabyProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String familyId, String name, DateTime birthDate, String? gender, double? birthWeight, double? birthHeight, double? birthHeadCircumference, double? currentWeight, double? currentHeight, double? currentHeadCircumference, DateTime createdAt
});




}
/// @nodoc
class __$BabyProfileCopyWithImpl<$Res>
    implements _$BabyProfileCopyWith<$Res> {
  __$BabyProfileCopyWithImpl(this._self, this._then);

  final _BabyProfile _self;
  final $Res Function(_BabyProfile) _then;

/// Create a copy of BabyProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? name = null,Object? birthDate = null,Object? gender = freezed,Object? birthWeight = freezed,Object? birthHeight = freezed,Object? birthHeadCircumference = freezed,Object? currentWeight = freezed,Object? currentHeight = freezed,Object? currentHeadCircumference = freezed,Object? createdAt = null,}) {
  return _then(_BabyProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,birthWeight: freezed == birthWeight ? _self.birthWeight : birthWeight // ignore: cast_nullable_to_non_nullable
as double?,birthHeight: freezed == birthHeight ? _self.birthHeight : birthHeight // ignore: cast_nullable_to_non_nullable
as double?,birthHeadCircumference: freezed == birthHeadCircumference ? _self.birthHeadCircumference : birthHeadCircumference // ignore: cast_nullable_to_non_nullable
as double?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,currentHeight: freezed == currentHeight ? _self.currentHeight : currentHeight // ignore: cast_nullable_to_non_nullable
as double?,currentHeadCircumference: freezed == currentHeadCircumference ? _self.currentHeadCircumference : currentHeadCircumference // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PregnancyProfile {

 String get id; String get userId; DateTime get startDate; DateTime get dueDate; String get status; DateTime? get birthCompletedAt;
/// Create a copy of PregnancyProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PregnancyProfileCopyWith<PregnancyProfile> get copyWith => _$PregnancyProfileCopyWithImpl<PregnancyProfile>(this as PregnancyProfile, _$identity);

  /// Serializes this PregnancyProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PregnancyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.birthCompletedAt, birthCompletedAt) || other.birthCompletedAt == birthCompletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startDate,dueDate,status,birthCompletedAt);

@override
String toString() {
  return 'PregnancyProfile(id: $id, userId: $userId, startDate: $startDate, dueDate: $dueDate, status: $status, birthCompletedAt: $birthCompletedAt)';
}


}

/// @nodoc
abstract mixin class $PregnancyProfileCopyWith<$Res>  {
  factory $PregnancyProfileCopyWith(PregnancyProfile value, $Res Function(PregnancyProfile) _then) = _$PregnancyProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime startDate, DateTime dueDate, String status, DateTime? birthCompletedAt
});




}
/// @nodoc
class _$PregnancyProfileCopyWithImpl<$Res>
    implements $PregnancyProfileCopyWith<$Res> {
  _$PregnancyProfileCopyWithImpl(this._self, this._then);

  final PregnancyProfile _self;
  final $Res Function(PregnancyProfile) _then;

/// Create a copy of PregnancyProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? startDate = null,Object? dueDate = null,Object? status = null,Object? birthCompletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,birthCompletedAt: freezed == birthCompletedAt ? _self.birthCompletedAt : birthCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PregnancyProfile].
extension PregnancyProfilePatterns on PregnancyProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PregnancyProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PregnancyProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PregnancyProfile value)  $default,){
final _that = this;
switch (_that) {
case _PregnancyProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PregnancyProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PregnancyProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime startDate,  DateTime dueDate,  String status,  DateTime? birthCompletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PregnancyProfile() when $default != null:
return $default(_that.id,_that.userId,_that.startDate,_that.dueDate,_that.status,_that.birthCompletedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime startDate,  DateTime dueDate,  String status,  DateTime? birthCompletedAt)  $default,) {final _that = this;
switch (_that) {
case _PregnancyProfile():
return $default(_that.id,_that.userId,_that.startDate,_that.dueDate,_that.status,_that.birthCompletedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime startDate,  DateTime dueDate,  String status,  DateTime? birthCompletedAt)?  $default,) {final _that = this;
switch (_that) {
case _PregnancyProfile() when $default != null:
return $default(_that.id,_that.userId,_that.startDate,_that.dueDate,_that.status,_that.birthCompletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PregnancyProfile implements PregnancyProfile {
  const _PregnancyProfile({required this.id, required this.userId, required this.startDate, required this.dueDate, required this.status, this.birthCompletedAt});
  factory _PregnancyProfile.fromJson(Map<String, dynamic> json) => _$PregnancyProfileFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime startDate;
@override final  DateTime dueDate;
@override final  String status;
@override final  DateTime? birthCompletedAt;

/// Create a copy of PregnancyProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PregnancyProfileCopyWith<_PregnancyProfile> get copyWith => __$PregnancyProfileCopyWithImpl<_PregnancyProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PregnancyProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PregnancyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.birthCompletedAt, birthCompletedAt) || other.birthCompletedAt == birthCompletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startDate,dueDate,status,birthCompletedAt);

@override
String toString() {
  return 'PregnancyProfile(id: $id, userId: $userId, startDate: $startDate, dueDate: $dueDate, status: $status, birthCompletedAt: $birthCompletedAt)';
}


}

/// @nodoc
abstract mixin class _$PregnancyProfileCopyWith<$Res> implements $PregnancyProfileCopyWith<$Res> {
  factory _$PregnancyProfileCopyWith(_PregnancyProfile value, $Res Function(_PregnancyProfile) _then) = __$PregnancyProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime startDate, DateTime dueDate, String status, DateTime? birthCompletedAt
});




}
/// @nodoc
class __$PregnancyProfileCopyWithImpl<$Res>
    implements _$PregnancyProfileCopyWith<$Res> {
  __$PregnancyProfileCopyWithImpl(this._self, this._then);

  final _PregnancyProfile _self;
  final $Res Function(_PregnancyProfile) _then;

/// Create a copy of PregnancyProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? startDate = null,Object? dueDate = null,Object? status = null,Object? birthCompletedAt = freezed,}) {
  return _then(_PregnancyProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,birthCompletedAt: freezed == birthCompletedAt ? _self.birthCompletedAt : birthCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TrackerRecord {

 String get id; RecordType get type; String get title; String? get familyId; String? get babyId; String? get value; String? get note; String? get createdByUserId; String? get createdByName; String? get updatedByUserId; String? get updatedByName; DateTime get occurredAt; DateTime get createdAt; DateTime get updatedAt; SyncStatus get syncStatus;
/// Create a copy of TrackerRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackerRecordCopyWith<TrackerRecord> get copyWith => _$TrackerRecordCopyWithImpl<TrackerRecord>(this as TrackerRecord, _$identity);

  /// Serializes this TrackerRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackerRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.babyId, babyId) || other.babyId == babyId)&&(identical(other.value, value) || other.value == value)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.updatedByUserId, updatedByUserId) || other.updatedByUserId == updatedByUserId)&&(identical(other.updatedByName, updatedByName) || other.updatedByName == updatedByName)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,familyId,babyId,value,note,createdByUserId,createdByName,updatedByUserId,updatedByName,occurredAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'TrackerRecord(id: $id, type: $type, title: $title, familyId: $familyId, babyId: $babyId, value: $value, note: $note, createdByUserId: $createdByUserId, createdByName: $createdByName, updatedByUserId: $updatedByUserId, updatedByName: $updatedByName, occurredAt: $occurredAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $TrackerRecordCopyWith<$Res>  {
  factory $TrackerRecordCopyWith(TrackerRecord value, $Res Function(TrackerRecord) _then) = _$TrackerRecordCopyWithImpl;
@useResult
$Res call({
 String id, RecordType type, String title, String? familyId, String? babyId, String? value, String? note, String? createdByUserId, String? createdByName, String? updatedByUserId, String? updatedByName, DateTime occurredAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class _$TrackerRecordCopyWithImpl<$Res>
    implements $TrackerRecordCopyWith<$Res> {
  _$TrackerRecordCopyWithImpl(this._self, this._then);

  final TrackerRecord _self;
  final $Res Function(TrackerRecord) _then;

/// Create a copy of TrackerRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? familyId = freezed,Object? babyId = freezed,Object? value = freezed,Object? note = freezed,Object? createdByUserId = freezed,Object? createdByName = freezed,Object? updatedByUserId = freezed,Object? updatedByName = freezed,Object? occurredAt = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RecordType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,babyId: freezed == babyId ? _self.babyId : babyId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,updatedByUserId: freezed == updatedByUserId ? _self.updatedByUserId : updatedByUserId // ignore: cast_nullable_to_non_nullable
as String?,updatedByName: freezed == updatedByName ? _self.updatedByName : updatedByName // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackerRecord].
extension TrackerRecordPatterns on TrackerRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackerRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackerRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackerRecord value)  $default,){
final _that = this;
switch (_that) {
case _TrackerRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackerRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TrackerRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  RecordType type,  String title,  String? familyId,  String? babyId,  String? value,  String? note,  String? createdByUserId,  String? createdByName,  String? updatedByUserId,  String? updatedByName,  DateTime occurredAt,  DateTime createdAt,  DateTime updatedAt,  SyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackerRecord() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.familyId,_that.babyId,_that.value,_that.note,_that.createdByUserId,_that.createdByName,_that.updatedByUserId,_that.updatedByName,_that.occurredAt,_that.createdAt,_that.updatedAt,_that.syncStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  RecordType type,  String title,  String? familyId,  String? babyId,  String? value,  String? note,  String? createdByUserId,  String? createdByName,  String? updatedByUserId,  String? updatedByName,  DateTime occurredAt,  DateTime createdAt,  DateTime updatedAt,  SyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _TrackerRecord():
return $default(_that.id,_that.type,_that.title,_that.familyId,_that.babyId,_that.value,_that.note,_that.createdByUserId,_that.createdByName,_that.updatedByUserId,_that.updatedByName,_that.occurredAt,_that.createdAt,_that.updatedAt,_that.syncStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  RecordType type,  String title,  String? familyId,  String? babyId,  String? value,  String? note,  String? createdByUserId,  String? createdByName,  String? updatedByUserId,  String? updatedByName,  DateTime occurredAt,  DateTime createdAt,  DateTime updatedAt,  SyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _TrackerRecord() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.familyId,_that.babyId,_that.value,_that.note,_that.createdByUserId,_that.createdByName,_that.updatedByUserId,_that.updatedByName,_that.occurredAt,_that.createdAt,_that.updatedAt,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackerRecord implements TrackerRecord {
  const _TrackerRecord({required this.id, required this.type, required this.title, this.familyId, this.babyId, this.value, this.note, this.createdByUserId, this.createdByName, this.updatedByUserId, this.updatedByName, required this.occurredAt, required this.createdAt, required this.updatedAt, this.syncStatus = SyncStatus.pending});
  factory _TrackerRecord.fromJson(Map<String, dynamic> json) => _$TrackerRecordFromJson(json);

@override final  String id;
@override final  RecordType type;
@override final  String title;
@override final  String? familyId;
@override final  String? babyId;
@override final  String? value;
@override final  String? note;
@override final  String? createdByUserId;
@override final  String? createdByName;
@override final  String? updatedByUserId;
@override final  String? updatedByName;
@override final  DateTime occurredAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  SyncStatus syncStatus;

/// Create a copy of TrackerRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackerRecordCopyWith<_TrackerRecord> get copyWith => __$TrackerRecordCopyWithImpl<_TrackerRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackerRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackerRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.babyId, babyId) || other.babyId == babyId)&&(identical(other.value, value) || other.value == value)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.updatedByUserId, updatedByUserId) || other.updatedByUserId == updatedByUserId)&&(identical(other.updatedByName, updatedByName) || other.updatedByName == updatedByName)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,familyId,babyId,value,note,createdByUserId,createdByName,updatedByUserId,updatedByName,occurredAt,createdAt,updatedAt,syncStatus);

@override
String toString() {
  return 'TrackerRecord(id: $id, type: $type, title: $title, familyId: $familyId, babyId: $babyId, value: $value, note: $note, createdByUserId: $createdByUserId, createdByName: $createdByName, updatedByUserId: $updatedByUserId, updatedByName: $updatedByName, occurredAt: $occurredAt, createdAt: $createdAt, updatedAt: $updatedAt, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$TrackerRecordCopyWith<$Res> implements $TrackerRecordCopyWith<$Res> {
  factory _$TrackerRecordCopyWith(_TrackerRecord value, $Res Function(_TrackerRecord) _then) = __$TrackerRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, RecordType type, String title, String? familyId, String? babyId, String? value, String? note, String? createdByUserId, String? createdByName, String? updatedByUserId, String? updatedByName, DateTime occurredAt, DateTime createdAt, DateTime updatedAt, SyncStatus syncStatus
});




}
/// @nodoc
class __$TrackerRecordCopyWithImpl<$Res>
    implements _$TrackerRecordCopyWith<$Res> {
  __$TrackerRecordCopyWithImpl(this._self, this._then);

  final _TrackerRecord _self;
  final $Res Function(_TrackerRecord) _then;

/// Create a copy of TrackerRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? familyId = freezed,Object? babyId = freezed,Object? value = freezed,Object? note = freezed,Object? createdByUserId = freezed,Object? createdByName = freezed,Object? updatedByUserId = freezed,Object? updatedByName = freezed,Object? occurredAt = null,Object? createdAt = null,Object? updatedAt = null,Object? syncStatus = null,}) {
  return _then(_TrackerRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RecordType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,babyId: freezed == babyId ? _self.babyId : babyId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdByName: freezed == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String?,updatedByUserId: freezed == updatedByUserId ? _self.updatedByUserId : updatedByUserId // ignore: cast_nullable_to_non_nullable
as String?,updatedByName: freezed == updatedByName ? _self.updatedByName : updatedByName // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}


/// @nodoc
mixin _$ReminderItem {

 String get id; String get title; ReminderCategory get category; DateTime get time; String get frequency; String? get notes; bool get isActive; DateTime get createdAt;
/// Create a copy of ReminderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderItemCopyWith<ReminderItem> get copyWith => _$ReminderItemCopyWithImpl<ReminderItem>(this as ReminderItem, _$identity);

  /// Serializes this ReminderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.time, time) || other.time == time)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,time,frequency,notes,isActive,createdAt);

@override
String toString() {
  return 'ReminderItem(id: $id, title: $title, category: $category, time: $time, frequency: $frequency, notes: $notes, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReminderItemCopyWith<$Res>  {
  factory $ReminderItemCopyWith(ReminderItem value, $Res Function(ReminderItem) _then) = _$ReminderItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, ReminderCategory category, DateTime time, String frequency, String? notes, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$ReminderItemCopyWithImpl<$Res>
    implements $ReminderItemCopyWith<$Res> {
  _$ReminderItemCopyWithImpl(this._self, this._then);

  final ReminderItem _self;
  final $Res Function(ReminderItem) _then;

/// Create a copy of ReminderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? time = null,Object? frequency = null,Object? notes = freezed,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ReminderCategory,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderItem].
extension ReminderItemPatterns on ReminderItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderItem value)  $default,){
final _that = this;
switch (_that) {
case _ReminderItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  ReminderCategory category,  DateTime time,  String frequency,  String? notes,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderItem() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.time,_that.frequency,_that.notes,_that.isActive,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  ReminderCategory category,  DateTime time,  String frequency,  String? notes,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReminderItem():
return $default(_that.id,_that.title,_that.category,_that.time,_that.frequency,_that.notes,_that.isActive,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  ReminderCategory category,  DateTime time,  String frequency,  String? notes,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReminderItem() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.time,_that.frequency,_that.notes,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderItem implements ReminderItem {
  const _ReminderItem({required this.id, required this.title, required this.category, required this.time, this.frequency = 'daily', this.notes, this.isActive = true, required this.createdAt});
  factory _ReminderItem.fromJson(Map<String, dynamic> json) => _$ReminderItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  ReminderCategory category;
@override final  DateTime time;
@override@JsonKey() final  String frequency;
@override final  String? notes;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of ReminderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderItemCopyWith<_ReminderItem> get copyWith => __$ReminderItemCopyWithImpl<_ReminderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.time, time) || other.time == time)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,time,frequency,notes,isActive,createdAt);

@override
String toString() {
  return 'ReminderItem(id: $id, title: $title, category: $category, time: $time, frequency: $frequency, notes: $notes, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReminderItemCopyWith<$Res> implements $ReminderItemCopyWith<$Res> {
  factory _$ReminderItemCopyWith(_ReminderItem value, $Res Function(_ReminderItem) _then) = __$ReminderItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, ReminderCategory category, DateTime time, String frequency, String? notes, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$ReminderItemCopyWithImpl<$Res>
    implements _$ReminderItemCopyWith<$Res> {
  __$ReminderItemCopyWithImpl(this._self, this._then);

  final _ReminderItem _self;
  final $Res Function(_ReminderItem) _then;

/// Create a copy of ReminderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? time = null,Object? frequency = null,Object? notes = freezed,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_ReminderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ReminderCategory,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AppNotification {

 String get id; String? get familyId; List<String> get targetUserIds; String? get createdBy; String get type; String get category; String get title; String get body; String? get payload; List<String> get readBy; List<String> get seenBy; bool get isDeleted; AppNotificationStatus get status; DateTime get createdAt; DateTime? get readAt;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other.targetUserIds, targetUserIds)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.payload, payload) || other.payload == payload)&&const DeepCollectionEquality().equals(other.readBy, readBy)&&const DeepCollectionEquality().equals(other.seenBy, seenBy)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,const DeepCollectionEquality().hash(targetUserIds),createdBy,type,category,title,body,payload,const DeepCollectionEquality().hash(readBy),const DeepCollectionEquality().hash(seenBy),isDeleted,status,createdAt,readAt);

@override
String toString() {
  return 'AppNotification(id: $id, familyId: $familyId, targetUserIds: $targetUserIds, createdBy: $createdBy, type: $type, category: $category, title: $title, body: $body, payload: $payload, readBy: $readBy, seenBy: $seenBy, isDeleted: $isDeleted, status: $status, createdAt: $createdAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String? familyId, List<String> targetUserIds, String? createdBy, String type, String category, String title, String body, String? payload, List<String> readBy, List<String> seenBy, bool isDeleted, AppNotificationStatus status, DateTime createdAt, DateTime? readAt
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = freezed,Object? targetUserIds = null,Object? createdBy = freezed,Object? type = null,Object? category = null,Object? title = null,Object? body = null,Object? payload = freezed,Object? readBy = null,Object? seenBy = null,Object? isDeleted = null,Object? status = null,Object? createdAt = null,Object? readAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,targetUserIds: null == targetUserIds ? _self.targetUserIds : targetUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,readBy: null == readBy ? _self.readBy : readBy // ignore: cast_nullable_to_non_nullable
as List<String>,seenBy: null == seenBy ? _self.seenBy : seenBy // ignore: cast_nullable_to_non_nullable
as List<String>,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppNotificationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? familyId,  List<String> targetUserIds,  String? createdBy,  String type,  String category,  String title,  String body,  String? payload,  List<String> readBy,  List<String> seenBy,  bool isDeleted,  AppNotificationStatus status,  DateTime createdAt,  DateTime? readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.familyId,_that.targetUserIds,_that.createdBy,_that.type,_that.category,_that.title,_that.body,_that.payload,_that.readBy,_that.seenBy,_that.isDeleted,_that.status,_that.createdAt,_that.readAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? familyId,  List<String> targetUserIds,  String? createdBy,  String type,  String category,  String title,  String body,  String? payload,  List<String> readBy,  List<String> seenBy,  bool isDeleted,  AppNotificationStatus status,  DateTime createdAt,  DateTime? readAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.familyId,_that.targetUserIds,_that.createdBy,_that.type,_that.category,_that.title,_that.body,_that.payload,_that.readBy,_that.seenBy,_that.isDeleted,_that.status,_that.createdAt,_that.readAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? familyId,  List<String> targetUserIds,  String? createdBy,  String type,  String category,  String title,  String body,  String? payload,  List<String> readBy,  List<String> seenBy,  bool isDeleted,  AppNotificationStatus status,  DateTime createdAt,  DateTime? readAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.familyId,_that.targetUserIds,_that.createdBy,_that.type,_that.category,_that.title,_that.body,_that.payload,_that.readBy,_that.seenBy,_that.isDeleted,_that.status,_that.createdAt,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification implements AppNotification {
  const _AppNotification({required this.id, this.familyId, final  List<String> targetUserIds = const [], this.createdBy, required this.type, required this.category, required this.title, required this.body, this.payload, final  List<String> readBy = const [], final  List<String> seenBy = const [], this.isDeleted = false, this.status = AppNotificationStatus.unread, required this.createdAt, this.readAt}): _targetUserIds = targetUserIds,_readBy = readBy,_seenBy = seenBy;
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String id;
@override final  String? familyId;
 final  List<String> _targetUserIds;
@override@JsonKey() List<String> get targetUserIds {
  if (_targetUserIds is EqualUnmodifiableListView) return _targetUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targetUserIds);
}

@override final  String? createdBy;
@override final  String type;
@override final  String category;
@override final  String title;
@override final  String body;
@override final  String? payload;
 final  List<String> _readBy;
@override@JsonKey() List<String> get readBy {
  if (_readBy is EqualUnmodifiableListView) return _readBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_readBy);
}

 final  List<String> _seenBy;
@override@JsonKey() List<String> get seenBy {
  if (_seenBy is EqualUnmodifiableListView) return _seenBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seenBy);
}

@override@JsonKey() final  bool isDeleted;
@override@JsonKey() final  AppNotificationStatus status;
@override final  DateTime createdAt;
@override final  DateTime? readAt;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other._targetUserIds, _targetUserIds)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.payload, payload) || other.payload == payload)&&const DeepCollectionEquality().equals(other._readBy, _readBy)&&const DeepCollectionEquality().equals(other._seenBy, _seenBy)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,const DeepCollectionEquality().hash(_targetUserIds),createdBy,type,category,title,body,payload,const DeepCollectionEquality().hash(_readBy),const DeepCollectionEquality().hash(_seenBy),isDeleted,status,createdAt,readAt);

@override
String toString() {
  return 'AppNotification(id: $id, familyId: $familyId, targetUserIds: $targetUserIds, createdBy: $createdBy, type: $type, category: $category, title: $title, body: $body, payload: $payload, readBy: $readBy, seenBy: $seenBy, isDeleted: $isDeleted, status: $status, createdAt: $createdAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String? familyId, List<String> targetUserIds, String? createdBy, String type, String category, String title, String body, String? payload, List<String> readBy, List<String> seenBy, bool isDeleted, AppNotificationStatus status, DateTime createdAt, DateTime? readAt
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = freezed,Object? targetUserIds = null,Object? createdBy = freezed,Object? type = null,Object? category = null,Object? title = null,Object? body = null,Object? payload = freezed,Object? readBy = null,Object? seenBy = null,Object? isDeleted = null,Object? status = null,Object? createdAt = null,Object? readAt = freezed,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,targetUserIds: null == targetUserIds ? _self._targetUserIds : targetUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,readBy: null == readBy ? _self._readBy : readBy // ignore: cast_nullable_to_non_nullable
as List<String>,seenBy: null == seenBy ? _self._seenBy : seenBy // ignore: cast_nullable_to_non_nullable
as List<String>,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppNotificationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$FamilyInvite {

 String get id; String get familyId; String get invitedEmail; String get invitedByUserId; String get invitedByName; String? get invitedDisplayName; String? get roleLabel; List<FamilyPermission> get permissions; String? get acceptedUserId; FamilyInviteStatus get status; DateTime get createdAt; DateTime? get respondedAt;
/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyInviteCopyWith<FamilyInvite> get copyWith => _$FamilyInviteCopyWithImpl<FamilyInvite>(this as FamilyInvite, _$identity);

  /// Serializes this FamilyInvite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.invitedEmail, invitedEmail) || other.invitedEmail == invitedEmail)&&(identical(other.invitedByUserId, invitedByUserId) || other.invitedByUserId == invitedByUserId)&&(identical(other.invitedByName, invitedByName) || other.invitedByName == invitedByName)&&(identical(other.invitedDisplayName, invitedDisplayName) || other.invitedDisplayName == invitedDisplayName)&&(identical(other.roleLabel, roleLabel) || other.roleLabel == roleLabel)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.acceptedUserId, acceptedUserId) || other.acceptedUserId == acceptedUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,invitedEmail,invitedByUserId,invitedByName,invitedDisplayName,roleLabel,const DeepCollectionEquality().hash(permissions),acceptedUserId,status,createdAt,respondedAt);

@override
String toString() {
  return 'FamilyInvite(id: $id, familyId: $familyId, invitedEmail: $invitedEmail, invitedByUserId: $invitedByUserId, invitedByName: $invitedByName, invitedDisplayName: $invitedDisplayName, roleLabel: $roleLabel, permissions: $permissions, acceptedUserId: $acceptedUserId, status: $status, createdAt: $createdAt, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class $FamilyInviteCopyWith<$Res>  {
  factory $FamilyInviteCopyWith(FamilyInvite value, $Res Function(FamilyInvite) _then) = _$FamilyInviteCopyWithImpl;
@useResult
$Res call({
 String id, String familyId, String invitedEmail, String invitedByUserId, String invitedByName, String? invitedDisplayName, String? roleLabel, List<FamilyPermission> permissions, String? acceptedUserId, FamilyInviteStatus status, DateTime createdAt, DateTime? respondedAt
});




}
/// @nodoc
class _$FamilyInviteCopyWithImpl<$Res>
    implements $FamilyInviteCopyWith<$Res> {
  _$FamilyInviteCopyWithImpl(this._self, this._then);

  final FamilyInvite _self;
  final $Res Function(FamilyInvite) _then;

/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? invitedEmail = null,Object? invitedByUserId = null,Object? invitedByName = null,Object? invitedDisplayName = freezed,Object? roleLabel = freezed,Object? permissions = null,Object? acceptedUserId = freezed,Object? status = null,Object? createdAt = null,Object? respondedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,invitedEmail: null == invitedEmail ? _self.invitedEmail : invitedEmail // ignore: cast_nullable_to_non_nullable
as String,invitedByUserId: null == invitedByUserId ? _self.invitedByUserId : invitedByUserId // ignore: cast_nullable_to_non_nullable
as String,invitedByName: null == invitedByName ? _self.invitedByName : invitedByName // ignore: cast_nullable_to_non_nullable
as String,invitedDisplayName: freezed == invitedDisplayName ? _self.invitedDisplayName : invitedDisplayName // ignore: cast_nullable_to_non_nullable
as String?,roleLabel: freezed == roleLabel ? _self.roleLabel : roleLabel // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<FamilyPermission>,acceptedUserId: freezed == acceptedUserId ? _self.acceptedUserId : acceptedUserId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FamilyInviteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyInvite].
extension FamilyInvitePatterns on FamilyInvite {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyInvite value)  $default,){
final _that = this;
switch (_that) {
case _FamilyInvite():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyInvite value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String familyId,  String invitedEmail,  String invitedByUserId,  String invitedByName,  String? invitedDisplayName,  String? roleLabel,  List<FamilyPermission> permissions,  String? acceptedUserId,  FamilyInviteStatus status,  DateTime createdAt,  DateTime? respondedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
return $default(_that.id,_that.familyId,_that.invitedEmail,_that.invitedByUserId,_that.invitedByName,_that.invitedDisplayName,_that.roleLabel,_that.permissions,_that.acceptedUserId,_that.status,_that.createdAt,_that.respondedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String familyId,  String invitedEmail,  String invitedByUserId,  String invitedByName,  String? invitedDisplayName,  String? roleLabel,  List<FamilyPermission> permissions,  String? acceptedUserId,  FamilyInviteStatus status,  DateTime createdAt,  DateTime? respondedAt)  $default,) {final _that = this;
switch (_that) {
case _FamilyInvite():
return $default(_that.id,_that.familyId,_that.invitedEmail,_that.invitedByUserId,_that.invitedByName,_that.invitedDisplayName,_that.roleLabel,_that.permissions,_that.acceptedUserId,_that.status,_that.createdAt,_that.respondedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String familyId,  String invitedEmail,  String invitedByUserId,  String invitedByName,  String? invitedDisplayName,  String? roleLabel,  List<FamilyPermission> permissions,  String? acceptedUserId,  FamilyInviteStatus status,  DateTime createdAt,  DateTime? respondedAt)?  $default,) {final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
return $default(_that.id,_that.familyId,_that.invitedEmail,_that.invitedByUserId,_that.invitedByName,_that.invitedDisplayName,_that.roleLabel,_that.permissions,_that.acceptedUserId,_that.status,_that.createdAt,_that.respondedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyInvite implements FamilyInvite {
  const _FamilyInvite({required this.id, required this.familyId, required this.invitedEmail, required this.invitedByUserId, required this.invitedByName, this.invitedDisplayName, this.roleLabel, final  List<FamilyPermission> permissions = const [], this.acceptedUserId, this.status = FamilyInviteStatus.pending, required this.createdAt, this.respondedAt}): _permissions = permissions;
  factory _FamilyInvite.fromJson(Map<String, dynamic> json) => _$FamilyInviteFromJson(json);

@override final  String id;
@override final  String familyId;
@override final  String invitedEmail;
@override final  String invitedByUserId;
@override final  String invitedByName;
@override final  String? invitedDisplayName;
@override final  String? roleLabel;
 final  List<FamilyPermission> _permissions;
@override@JsonKey() List<FamilyPermission> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override final  String? acceptedUserId;
@override@JsonKey() final  FamilyInviteStatus status;
@override final  DateTime createdAt;
@override final  DateTime? respondedAt;

/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyInviteCopyWith<_FamilyInvite> get copyWith => __$FamilyInviteCopyWithImpl<_FamilyInvite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyInviteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.invitedEmail, invitedEmail) || other.invitedEmail == invitedEmail)&&(identical(other.invitedByUserId, invitedByUserId) || other.invitedByUserId == invitedByUserId)&&(identical(other.invitedByName, invitedByName) || other.invitedByName == invitedByName)&&(identical(other.invitedDisplayName, invitedDisplayName) || other.invitedDisplayName == invitedDisplayName)&&(identical(other.roleLabel, roleLabel) || other.roleLabel == roleLabel)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.acceptedUserId, acceptedUserId) || other.acceptedUserId == acceptedUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,invitedEmail,invitedByUserId,invitedByName,invitedDisplayName,roleLabel,const DeepCollectionEquality().hash(_permissions),acceptedUserId,status,createdAt,respondedAt);

@override
String toString() {
  return 'FamilyInvite(id: $id, familyId: $familyId, invitedEmail: $invitedEmail, invitedByUserId: $invitedByUserId, invitedByName: $invitedByName, invitedDisplayName: $invitedDisplayName, roleLabel: $roleLabel, permissions: $permissions, acceptedUserId: $acceptedUserId, status: $status, createdAt: $createdAt, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class _$FamilyInviteCopyWith<$Res> implements $FamilyInviteCopyWith<$Res> {
  factory _$FamilyInviteCopyWith(_FamilyInvite value, $Res Function(_FamilyInvite) _then) = __$FamilyInviteCopyWithImpl;
@override @useResult
$Res call({
 String id, String familyId, String invitedEmail, String invitedByUserId, String invitedByName, String? invitedDisplayName, String? roleLabel, List<FamilyPermission> permissions, String? acceptedUserId, FamilyInviteStatus status, DateTime createdAt, DateTime? respondedAt
});




}
/// @nodoc
class __$FamilyInviteCopyWithImpl<$Res>
    implements _$FamilyInviteCopyWith<$Res> {
  __$FamilyInviteCopyWithImpl(this._self, this._then);

  final _FamilyInvite _self;
  final $Res Function(_FamilyInvite) _then;

/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? invitedEmail = null,Object? invitedByUserId = null,Object? invitedByName = null,Object? invitedDisplayName = freezed,Object? roleLabel = freezed,Object? permissions = null,Object? acceptedUserId = freezed,Object? status = null,Object? createdAt = null,Object? respondedAt = freezed,}) {
  return _then(_FamilyInvite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,invitedEmail: null == invitedEmail ? _self.invitedEmail : invitedEmail // ignore: cast_nullable_to_non_nullable
as String,invitedByUserId: null == invitedByUserId ? _self.invitedByUserId : invitedByUserId // ignore: cast_nullable_to_non_nullable
as String,invitedByName: null == invitedByName ? _self.invitedByName : invitedByName // ignore: cast_nullable_to_non_nullable
as String,invitedDisplayName: freezed == invitedDisplayName ? _self.invitedDisplayName : invitedDisplayName // ignore: cast_nullable_to_non_nullable
as String?,roleLabel: freezed == roleLabel ? _self.roleLabel : roleLabel // ignore: cast_nullable_to_non_nullable
as String?,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<FamilyPermission>,acceptedUserId: freezed == acceptedUserId ? _self.acceptedUserId : acceptedUserId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FamilyInviteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$VaccineEvent {

 String get id; String get babyId; String get title; String get dose; DateTime get dueDate; VaccineStatus get status; String? get notes; DateTime? get completedAt; DateTime get createdAt;
/// Create a copy of VaccineEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineEventCopyWith<VaccineEvent> get copyWith => _$VaccineEventCopyWithImpl<VaccineEvent>(this as VaccineEvent, _$identity);

  /// Serializes this VaccineEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccineEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.babyId, babyId) || other.babyId == babyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,babyId,title,dose,dueDate,status,notes,completedAt,createdAt);

@override
String toString() {
  return 'VaccineEvent(id: $id, babyId: $babyId, title: $title, dose: $dose, dueDate: $dueDate, status: $status, notes: $notes, completedAt: $completedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $VaccineEventCopyWith<$Res>  {
  factory $VaccineEventCopyWith(VaccineEvent value, $Res Function(VaccineEvent) _then) = _$VaccineEventCopyWithImpl;
@useResult
$Res call({
 String id, String babyId, String title, String dose, DateTime dueDate, VaccineStatus status, String? notes, DateTime? completedAt, DateTime createdAt
});




}
/// @nodoc
class _$VaccineEventCopyWithImpl<$Res>
    implements $VaccineEventCopyWith<$Res> {
  _$VaccineEventCopyWithImpl(this._self, this._then);

  final VaccineEvent _self;
  final $Res Function(VaccineEvent) _then;

/// Create a copy of VaccineEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? babyId = null,Object? title = null,Object? dose = null,Object? dueDate = null,Object? status = null,Object? notes = freezed,Object? completedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,babyId: null == babyId ? _self.babyId : babyId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VaccineStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccineEvent].
extension VaccineEventPatterns on VaccineEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccineEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccineEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccineEvent value)  $default,){
final _that = this;
switch (_that) {
case _VaccineEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccineEvent value)?  $default,){
final _that = this;
switch (_that) {
case _VaccineEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String babyId,  String title,  String dose,  DateTime dueDate,  VaccineStatus status,  String? notes,  DateTime? completedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccineEvent() when $default != null:
return $default(_that.id,_that.babyId,_that.title,_that.dose,_that.dueDate,_that.status,_that.notes,_that.completedAt,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String babyId,  String title,  String dose,  DateTime dueDate,  VaccineStatus status,  String? notes,  DateTime? completedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _VaccineEvent():
return $default(_that.id,_that.babyId,_that.title,_that.dose,_that.dueDate,_that.status,_that.notes,_that.completedAt,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String babyId,  String title,  String dose,  DateTime dueDate,  VaccineStatus status,  String? notes,  DateTime? completedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _VaccineEvent() when $default != null:
return $default(_that.id,_that.babyId,_that.title,_that.dose,_that.dueDate,_that.status,_that.notes,_that.completedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccineEvent implements VaccineEvent {
  const _VaccineEvent({required this.id, required this.babyId, required this.title, required this.dose, required this.dueDate, this.status = VaccineStatus.upcoming, this.notes, this.completedAt, required this.createdAt});
  factory _VaccineEvent.fromJson(Map<String, dynamic> json) => _$VaccineEventFromJson(json);

@override final  String id;
@override final  String babyId;
@override final  String title;
@override final  String dose;
@override final  DateTime dueDate;
@override@JsonKey() final  VaccineStatus status;
@override final  String? notes;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;

/// Create a copy of VaccineEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineEventCopyWith<_VaccineEvent> get copyWith => __$VaccineEventCopyWithImpl<_VaccineEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccineEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.babyId, babyId) || other.babyId == babyId)&&(identical(other.title, title) || other.title == title)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,babyId,title,dose,dueDate,status,notes,completedAt,createdAt);

@override
String toString() {
  return 'VaccineEvent(id: $id, babyId: $babyId, title: $title, dose: $dose, dueDate: $dueDate, status: $status, notes: $notes, completedAt: $completedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$VaccineEventCopyWith<$Res> implements $VaccineEventCopyWith<$Res> {
  factory _$VaccineEventCopyWith(_VaccineEvent value, $Res Function(_VaccineEvent) _then) = __$VaccineEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String babyId, String title, String dose, DateTime dueDate, VaccineStatus status, String? notes, DateTime? completedAt, DateTime createdAt
});




}
/// @nodoc
class __$VaccineEventCopyWithImpl<$Res>
    implements _$VaccineEventCopyWith<$Res> {
  __$VaccineEventCopyWithImpl(this._self, this._then);

  final _VaccineEvent _self;
  final $Res Function(_VaccineEvent) _then;

/// Create a copy of VaccineEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? babyId = null,Object? title = null,Object? dose = null,Object? dueDate = null,Object? status = null,Object? notes = freezed,Object? completedAt = freezed,Object? createdAt = null,}) {
  return _then(_VaccineEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,babyId: null == babyId ? _self.babyId : babyId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VaccineStatus,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Article {

 String get id; String get careMode; String get title; String get category; String get summary; String get content; int get readingMinutes; String get sourceName; String get sourceUrl; String get medicalDisclaimer; bool get isSaved;
/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleCopyWith<Article> get copyWith => _$ArticleCopyWithImpl<Article>(this as Article, _$identity);

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Article&&(identical(other.id, id) || other.id == id)&&(identical(other.careMode, careMode) || other.careMode == careMode)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.readingMinutes, readingMinutes) || other.readingMinutes == readingMinutes)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.medicalDisclaimer, medicalDisclaimer) || other.medicalDisclaimer == medicalDisclaimer)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,careMode,title,category,summary,content,readingMinutes,sourceName,sourceUrl,medicalDisclaimer,isSaved);

@override
String toString() {
  return 'Article(id: $id, careMode: $careMode, title: $title, category: $category, summary: $summary, content: $content, readingMinutes: $readingMinutes, sourceName: $sourceName, sourceUrl: $sourceUrl, medicalDisclaimer: $medicalDisclaimer, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $ArticleCopyWith<$Res>  {
  factory $ArticleCopyWith(Article value, $Res Function(Article) _then) = _$ArticleCopyWithImpl;
@useResult
$Res call({
 String id, String careMode, String title, String category, String summary, String content, int readingMinutes, String sourceName, String sourceUrl, String medicalDisclaimer, bool isSaved
});




}
/// @nodoc
class _$ArticleCopyWithImpl<$Res>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._self, this._then);

  final Article _self;
  final $Res Function(Article) _then;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? careMode = null,Object? title = null,Object? category = null,Object? summary = null,Object? content = null,Object? readingMinutes = null,Object? sourceName = null,Object? sourceUrl = null,Object? medicalDisclaimer = null,Object? isSaved = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,careMode: null == careMode ? _self.careMode : careMode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,readingMinutes: null == readingMinutes ? _self.readingMinutes : readingMinutes // ignore: cast_nullable_to_non_nullable
as int,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,medicalDisclaimer: null == medicalDisclaimer ? _self.medicalDisclaimer : medicalDisclaimer // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Article].
extension ArticlePatterns on Article {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Article value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Article value)  $default,){
final _that = this;
switch (_that) {
case _Article():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Article value)?  $default,){
final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String careMode,  String title,  String category,  String summary,  String content,  int readingMinutes,  String sourceName,  String sourceUrl,  String medicalDisclaimer,  bool isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that.id,_that.careMode,_that.title,_that.category,_that.summary,_that.content,_that.readingMinutes,_that.sourceName,_that.sourceUrl,_that.medicalDisclaimer,_that.isSaved);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String careMode,  String title,  String category,  String summary,  String content,  int readingMinutes,  String sourceName,  String sourceUrl,  String medicalDisclaimer,  bool isSaved)  $default,) {final _that = this;
switch (_that) {
case _Article():
return $default(_that.id,_that.careMode,_that.title,_that.category,_that.summary,_that.content,_that.readingMinutes,_that.sourceName,_that.sourceUrl,_that.medicalDisclaimer,_that.isSaved);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String careMode,  String title,  String category,  String summary,  String content,  int readingMinutes,  String sourceName,  String sourceUrl,  String medicalDisclaimer,  bool isSaved)?  $default,) {final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that.id,_that.careMode,_that.title,_that.category,_that.summary,_that.content,_that.readingMinutes,_that.sourceName,_that.sourceUrl,_that.medicalDisclaimer,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Article implements Article {
  const _Article({required this.id, this.careMode = 'baby', required this.title, required this.category, required this.summary, required this.content, required this.readingMinutes, required this.sourceName, required this.sourceUrl, required this.medicalDisclaimer, this.isSaved = false});
  factory _Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

@override final  String id;
@override@JsonKey() final  String careMode;
@override final  String title;
@override final  String category;
@override final  String summary;
@override final  String content;
@override final  int readingMinutes;
@override final  String sourceName;
@override final  String sourceUrl;
@override final  String medicalDisclaimer;
@override@JsonKey() final  bool isSaved;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleCopyWith<_Article> get copyWith => __$ArticleCopyWithImpl<_Article>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Article&&(identical(other.id, id) || other.id == id)&&(identical(other.careMode, careMode) || other.careMode == careMode)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.readingMinutes, readingMinutes) || other.readingMinutes == readingMinutes)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.medicalDisclaimer, medicalDisclaimer) || other.medicalDisclaimer == medicalDisclaimer)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,careMode,title,category,summary,content,readingMinutes,sourceName,sourceUrl,medicalDisclaimer,isSaved);

@override
String toString() {
  return 'Article(id: $id, careMode: $careMode, title: $title, category: $category, summary: $summary, content: $content, readingMinutes: $readingMinutes, sourceName: $sourceName, sourceUrl: $sourceUrl, medicalDisclaimer: $medicalDisclaimer, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$ArticleCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$ArticleCopyWith(_Article value, $Res Function(_Article) _then) = __$ArticleCopyWithImpl;
@override @useResult
$Res call({
 String id, String careMode, String title, String category, String summary, String content, int readingMinutes, String sourceName, String sourceUrl, String medicalDisclaimer, bool isSaved
});




}
/// @nodoc
class __$ArticleCopyWithImpl<$Res>
    implements _$ArticleCopyWith<$Res> {
  __$ArticleCopyWithImpl(this._self, this._then);

  final _Article _self;
  final $Res Function(_Article) _then;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? careMode = null,Object? title = null,Object? category = null,Object? summary = null,Object? content = null,Object? readingMinutes = null,Object? sourceName = null,Object? sourceUrl = null,Object? medicalDisclaimer = null,Object? isSaved = null,}) {
  return _then(_Article(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,careMode: null == careMode ? _self.careMode : careMode // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,readingMinutes: null == readingMinutes ? _self.readingMinutes : readingMinutes // ignore: cast_nullable_to_non_nullable
as int,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,medicalDisclaimer: null == medicalDisclaimer ? _self.medicalDisclaimer : medicalDisclaimer // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AppSnapshot {

 UserProfile? get user; Family? get family; BabyProfile? get baby; PregnancyProfile? get pregnancy; CareMode get mode; List<TrackerRecord> get records; List<ReminderItem> get reminders; List<AppNotification> get notifications; List<FamilyInvite> get invites; List<VaccineEvent> get vaccines; List<Article> get articles; bool get onboardingComplete; String get localeCode; bool get notificationsEnabled; bool get healthNotificationsEnabled; bool get familyNotificationsEnabled; bool get reminderNotificationsEnabled; String get notificationSound;
/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSnapshotCopyWith<AppSnapshot> get copyWith => _$AppSnapshotCopyWithImpl<AppSnapshot>(this as AppSnapshot, _$identity);

  /// Serializes this AppSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSnapshot&&(identical(other.user, user) || other.user == user)&&(identical(other.family, family) || other.family == family)&&(identical(other.baby, baby) || other.baby == baby)&&(identical(other.pregnancy, pregnancy) || other.pregnancy == pregnancy)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.records, records)&&const DeepCollectionEquality().equals(other.reminders, reminders)&&const DeepCollectionEquality().equals(other.notifications, notifications)&&const DeepCollectionEquality().equals(other.invites, invites)&&const DeepCollectionEquality().equals(other.vaccines, vaccines)&&const DeepCollectionEquality().equals(other.articles, articles)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.healthNotificationsEnabled, healthNotificationsEnabled) || other.healthNotificationsEnabled == healthNotificationsEnabled)&&(identical(other.familyNotificationsEnabled, familyNotificationsEnabled) || other.familyNotificationsEnabled == familyNotificationsEnabled)&&(identical(other.reminderNotificationsEnabled, reminderNotificationsEnabled) || other.reminderNotificationsEnabled == reminderNotificationsEnabled)&&(identical(other.notificationSound, notificationSound) || other.notificationSound == notificationSound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,family,baby,pregnancy,mode,const DeepCollectionEquality().hash(records),const DeepCollectionEquality().hash(reminders),const DeepCollectionEquality().hash(notifications),const DeepCollectionEquality().hash(invites),const DeepCollectionEquality().hash(vaccines),const DeepCollectionEquality().hash(articles),onboardingComplete,localeCode,notificationsEnabled,healthNotificationsEnabled,familyNotificationsEnabled,reminderNotificationsEnabled,notificationSound);

@override
String toString() {
  return 'AppSnapshot(user: $user, family: $family, baby: $baby, pregnancy: $pregnancy, mode: $mode, records: $records, reminders: $reminders, notifications: $notifications, invites: $invites, vaccines: $vaccines, articles: $articles, onboardingComplete: $onboardingComplete, localeCode: $localeCode, notificationsEnabled: $notificationsEnabled, healthNotificationsEnabled: $healthNotificationsEnabled, familyNotificationsEnabled: $familyNotificationsEnabled, reminderNotificationsEnabled: $reminderNotificationsEnabled, notificationSound: $notificationSound)';
}


}

/// @nodoc
abstract mixin class $AppSnapshotCopyWith<$Res>  {
  factory $AppSnapshotCopyWith(AppSnapshot value, $Res Function(AppSnapshot) _then) = _$AppSnapshotCopyWithImpl;
@useResult
$Res call({
 UserProfile? user, Family? family, BabyProfile? baby, PregnancyProfile? pregnancy, CareMode mode, List<TrackerRecord> records, List<ReminderItem> reminders, List<AppNotification> notifications, List<FamilyInvite> invites, List<VaccineEvent> vaccines, List<Article> articles, bool onboardingComplete, String localeCode, bool notificationsEnabled, bool healthNotificationsEnabled, bool familyNotificationsEnabled, bool reminderNotificationsEnabled, String notificationSound
});


$UserProfileCopyWith<$Res>? get user;$FamilyCopyWith<$Res>? get family;$BabyProfileCopyWith<$Res>? get baby;$PregnancyProfileCopyWith<$Res>? get pregnancy;

}
/// @nodoc
class _$AppSnapshotCopyWithImpl<$Res>
    implements $AppSnapshotCopyWith<$Res> {
  _$AppSnapshotCopyWithImpl(this._self, this._then);

  final AppSnapshot _self;
  final $Res Function(AppSnapshot) _then;

/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? family = freezed,Object? baby = freezed,Object? pregnancy = freezed,Object? mode = null,Object? records = null,Object? reminders = null,Object? notifications = null,Object? invites = null,Object? vaccines = null,Object? articles = null,Object? onboardingComplete = null,Object? localeCode = null,Object? notificationsEnabled = null,Object? healthNotificationsEnabled = null,Object? familyNotificationsEnabled = null,Object? reminderNotificationsEnabled = null,Object? notificationSound = null,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserProfile?,family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as Family?,baby: freezed == baby ? _self.baby : baby // ignore: cast_nullable_to_non_nullable
as BabyProfile?,pregnancy: freezed == pregnancy ? _self.pregnancy : pregnancy // ignore: cast_nullable_to_non_nullable
as PregnancyProfile?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CareMode,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<TrackerRecord>,reminders: null == reminders ? _self.reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<ReminderItem>,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,invites: null == invites ? _self.invites : invites // ignore: cast_nullable_to_non_nullable
as List<FamilyInvite>,vaccines: null == vaccines ? _self.vaccines : vaccines // ignore: cast_nullable_to_non_nullable
as List<VaccineEvent>,articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,localeCode: null == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,healthNotificationsEnabled: null == healthNotificationsEnabled ? _self.healthNotificationsEnabled : healthNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,familyNotificationsEnabled: null == familyNotificationsEnabled ? _self.familyNotificationsEnabled : familyNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderNotificationsEnabled: null == reminderNotificationsEnabled ? _self.reminderNotificationsEnabled : reminderNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationSound: null == notificationSound ? _self.notificationSound : notificationSound // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyCopyWith<$Res>? get family {
    if (_self.family == null) {
    return null;
  }

  return $FamilyCopyWith<$Res>(_self.family!, (value) {
    return _then(_self.copyWith(family: value));
  });
}/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BabyProfileCopyWith<$Res>? get baby {
    if (_self.baby == null) {
    return null;
  }

  return $BabyProfileCopyWith<$Res>(_self.baby!, (value) {
    return _then(_self.copyWith(baby: value));
  });
}/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PregnancyProfileCopyWith<$Res>? get pregnancy {
    if (_self.pregnancy == null) {
    return null;
  }

  return $PregnancyProfileCopyWith<$Res>(_self.pregnancy!, (value) {
    return _then(_self.copyWith(pregnancy: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppSnapshot].
extension AppSnapshotPatterns on AppSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _AppSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _AppSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserProfile? user,  Family? family,  BabyProfile? baby,  PregnancyProfile? pregnancy,  CareMode mode,  List<TrackerRecord> records,  List<ReminderItem> reminders,  List<AppNotification> notifications,  List<FamilyInvite> invites,  List<VaccineEvent> vaccines,  List<Article> articles,  bool onboardingComplete,  String localeCode,  bool notificationsEnabled,  bool healthNotificationsEnabled,  bool familyNotificationsEnabled,  bool reminderNotificationsEnabled,  String notificationSound)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSnapshot() when $default != null:
return $default(_that.user,_that.family,_that.baby,_that.pregnancy,_that.mode,_that.records,_that.reminders,_that.notifications,_that.invites,_that.vaccines,_that.articles,_that.onboardingComplete,_that.localeCode,_that.notificationsEnabled,_that.healthNotificationsEnabled,_that.familyNotificationsEnabled,_that.reminderNotificationsEnabled,_that.notificationSound);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserProfile? user,  Family? family,  BabyProfile? baby,  PregnancyProfile? pregnancy,  CareMode mode,  List<TrackerRecord> records,  List<ReminderItem> reminders,  List<AppNotification> notifications,  List<FamilyInvite> invites,  List<VaccineEvent> vaccines,  List<Article> articles,  bool onboardingComplete,  String localeCode,  bool notificationsEnabled,  bool healthNotificationsEnabled,  bool familyNotificationsEnabled,  bool reminderNotificationsEnabled,  String notificationSound)  $default,) {final _that = this;
switch (_that) {
case _AppSnapshot():
return $default(_that.user,_that.family,_that.baby,_that.pregnancy,_that.mode,_that.records,_that.reminders,_that.notifications,_that.invites,_that.vaccines,_that.articles,_that.onboardingComplete,_that.localeCode,_that.notificationsEnabled,_that.healthNotificationsEnabled,_that.familyNotificationsEnabled,_that.reminderNotificationsEnabled,_that.notificationSound);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserProfile? user,  Family? family,  BabyProfile? baby,  PregnancyProfile? pregnancy,  CareMode mode,  List<TrackerRecord> records,  List<ReminderItem> reminders,  List<AppNotification> notifications,  List<FamilyInvite> invites,  List<VaccineEvent> vaccines,  List<Article> articles,  bool onboardingComplete,  String localeCode,  bool notificationsEnabled,  bool healthNotificationsEnabled,  bool familyNotificationsEnabled,  bool reminderNotificationsEnabled,  String notificationSound)?  $default,) {final _that = this;
switch (_that) {
case _AppSnapshot() when $default != null:
return $default(_that.user,_that.family,_that.baby,_that.pregnancy,_that.mode,_that.records,_that.reminders,_that.notifications,_that.invites,_that.vaccines,_that.articles,_that.onboardingComplete,_that.localeCode,_that.notificationsEnabled,_that.healthNotificationsEnabled,_that.familyNotificationsEnabled,_that.reminderNotificationsEnabled,_that.notificationSound);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSnapshot implements AppSnapshot {
  const _AppSnapshot({this.user, this.family, this.baby, this.pregnancy, this.mode = CareMode.pregnancy, final  List<TrackerRecord> records = const [], final  List<ReminderItem> reminders = const [], final  List<AppNotification> notifications = const [], final  List<FamilyInvite> invites = const [], final  List<VaccineEvent> vaccines = const [], final  List<Article> articles = const [], this.onboardingComplete = false, this.localeCode = 'tr', this.notificationsEnabled = true, this.healthNotificationsEnabled = true, this.familyNotificationsEnabled = true, this.reminderNotificationsEnabled = true, this.notificationSound = 'soft_chime'}): _records = records,_reminders = reminders,_notifications = notifications,_invites = invites,_vaccines = vaccines,_articles = articles;
  factory _AppSnapshot.fromJson(Map<String, dynamic> json) => _$AppSnapshotFromJson(json);

@override final  UserProfile? user;
@override final  Family? family;
@override final  BabyProfile? baby;
@override final  PregnancyProfile? pregnancy;
@override@JsonKey() final  CareMode mode;
 final  List<TrackerRecord> _records;
@override@JsonKey() List<TrackerRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

 final  List<ReminderItem> _reminders;
@override@JsonKey() List<ReminderItem> get reminders {
  if (_reminders is EqualUnmodifiableListView) return _reminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminders);
}

 final  List<AppNotification> _notifications;
@override@JsonKey() List<AppNotification> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

 final  List<FamilyInvite> _invites;
@override@JsonKey() List<FamilyInvite> get invites {
  if (_invites is EqualUnmodifiableListView) return _invites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invites);
}

 final  List<VaccineEvent> _vaccines;
@override@JsonKey() List<VaccineEvent> get vaccines {
  if (_vaccines is EqualUnmodifiableListView) return _vaccines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccines);
}

 final  List<Article> _articles;
@override@JsonKey() List<Article> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}

@override@JsonKey() final  bool onboardingComplete;
@override@JsonKey() final  String localeCode;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool healthNotificationsEnabled;
@override@JsonKey() final  bool familyNotificationsEnabled;
@override@JsonKey() final  bool reminderNotificationsEnabled;
@override@JsonKey() final  String notificationSound;

/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSnapshotCopyWith<_AppSnapshot> get copyWith => __$AppSnapshotCopyWithImpl<_AppSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSnapshot&&(identical(other.user, user) || other.user == user)&&(identical(other.family, family) || other.family == family)&&(identical(other.baby, baby) || other.baby == baby)&&(identical(other.pregnancy, pregnancy) || other.pregnancy == pregnancy)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._records, _records)&&const DeepCollectionEquality().equals(other._reminders, _reminders)&&const DeepCollectionEquality().equals(other._notifications, _notifications)&&const DeepCollectionEquality().equals(other._invites, _invites)&&const DeepCollectionEquality().equals(other._vaccines, _vaccines)&&const DeepCollectionEquality().equals(other._articles, _articles)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.healthNotificationsEnabled, healthNotificationsEnabled) || other.healthNotificationsEnabled == healthNotificationsEnabled)&&(identical(other.familyNotificationsEnabled, familyNotificationsEnabled) || other.familyNotificationsEnabled == familyNotificationsEnabled)&&(identical(other.reminderNotificationsEnabled, reminderNotificationsEnabled) || other.reminderNotificationsEnabled == reminderNotificationsEnabled)&&(identical(other.notificationSound, notificationSound) || other.notificationSound == notificationSound));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,family,baby,pregnancy,mode,const DeepCollectionEquality().hash(_records),const DeepCollectionEquality().hash(_reminders),const DeepCollectionEquality().hash(_notifications),const DeepCollectionEquality().hash(_invites),const DeepCollectionEquality().hash(_vaccines),const DeepCollectionEquality().hash(_articles),onboardingComplete,localeCode,notificationsEnabled,healthNotificationsEnabled,familyNotificationsEnabled,reminderNotificationsEnabled,notificationSound);

@override
String toString() {
  return 'AppSnapshot(user: $user, family: $family, baby: $baby, pregnancy: $pregnancy, mode: $mode, records: $records, reminders: $reminders, notifications: $notifications, invites: $invites, vaccines: $vaccines, articles: $articles, onboardingComplete: $onboardingComplete, localeCode: $localeCode, notificationsEnabled: $notificationsEnabled, healthNotificationsEnabled: $healthNotificationsEnabled, familyNotificationsEnabled: $familyNotificationsEnabled, reminderNotificationsEnabled: $reminderNotificationsEnabled, notificationSound: $notificationSound)';
}


}

/// @nodoc
abstract mixin class _$AppSnapshotCopyWith<$Res> implements $AppSnapshotCopyWith<$Res> {
  factory _$AppSnapshotCopyWith(_AppSnapshot value, $Res Function(_AppSnapshot) _then) = __$AppSnapshotCopyWithImpl;
@override @useResult
$Res call({
 UserProfile? user, Family? family, BabyProfile? baby, PregnancyProfile? pregnancy, CareMode mode, List<TrackerRecord> records, List<ReminderItem> reminders, List<AppNotification> notifications, List<FamilyInvite> invites, List<VaccineEvent> vaccines, List<Article> articles, bool onboardingComplete, String localeCode, bool notificationsEnabled, bool healthNotificationsEnabled, bool familyNotificationsEnabled, bool reminderNotificationsEnabled, String notificationSound
});


@override $UserProfileCopyWith<$Res>? get user;@override $FamilyCopyWith<$Res>? get family;@override $BabyProfileCopyWith<$Res>? get baby;@override $PregnancyProfileCopyWith<$Res>? get pregnancy;

}
/// @nodoc
class __$AppSnapshotCopyWithImpl<$Res>
    implements _$AppSnapshotCopyWith<$Res> {
  __$AppSnapshotCopyWithImpl(this._self, this._then);

  final _AppSnapshot _self;
  final $Res Function(_AppSnapshot) _then;

/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? family = freezed,Object? baby = freezed,Object? pregnancy = freezed,Object? mode = null,Object? records = null,Object? reminders = null,Object? notifications = null,Object? invites = null,Object? vaccines = null,Object? articles = null,Object? onboardingComplete = null,Object? localeCode = null,Object? notificationsEnabled = null,Object? healthNotificationsEnabled = null,Object? familyNotificationsEnabled = null,Object? reminderNotificationsEnabled = null,Object? notificationSound = null,}) {
  return _then(_AppSnapshot(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserProfile?,family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as Family?,baby: freezed == baby ? _self.baby : baby // ignore: cast_nullable_to_non_nullable
as BabyProfile?,pregnancy: freezed == pregnancy ? _self.pregnancy : pregnancy // ignore: cast_nullable_to_non_nullable
as PregnancyProfile?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CareMode,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<TrackerRecord>,reminders: null == reminders ? _self._reminders : reminders // ignore: cast_nullable_to_non_nullable
as List<ReminderItem>,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotification>,invites: null == invites ? _self._invites : invites // ignore: cast_nullable_to_non_nullable
as List<FamilyInvite>,vaccines: null == vaccines ? _self._vaccines : vaccines // ignore: cast_nullable_to_non_nullable
as List<VaccineEvent>,articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,localeCode: null == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,healthNotificationsEnabled: null == healthNotificationsEnabled ? _self.healthNotificationsEnabled : healthNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,familyNotificationsEnabled: null == familyNotificationsEnabled ? _self.familyNotificationsEnabled : familyNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderNotificationsEnabled: null == reminderNotificationsEnabled ? _self.reminderNotificationsEnabled : reminderNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,notificationSound: null == notificationSound ? _self.notificationSound : notificationSound // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyCopyWith<$Res>? get family {
    if (_self.family == null) {
    return null;
  }

  return $FamilyCopyWith<$Res>(_self.family!, (value) {
    return _then(_self.copyWith(family: value));
  });
}/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BabyProfileCopyWith<$Res>? get baby {
    if (_self.baby == null) {
    return null;
  }

  return $BabyProfileCopyWith<$Res>(_self.baby!, (value) {
    return _then(_self.copyWith(baby: value));
  });
}/// Create a copy of AppSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PregnancyProfileCopyWith<$Res>? get pregnancy {
    if (_self.pregnancy == null) {
    return null;
  }

  return $PregnancyProfileCopyWith<$Res>(_self.pregnancy!, (value) {
    return _then(_self.copyWith(pregnancy: value));
  });
}
}

// dart format on
