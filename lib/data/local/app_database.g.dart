// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailVerifiedMeta = const VerificationMeta(
    'emailVerified',
  );
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
    'email_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tr'),
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('light'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    emailVerified,
    avatarUrl,
    birthDate,
    phone,
    role,
    language,
    theme,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('email_verified')) {
      context.handle(
        _emailVerifiedMeta,
        emailVerified.isAcceptableOrUnknown(
          data['email_verified']!,
          _emailVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      emailVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_verified'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String? avatarUrl;
  final DateTime? birthDate;
  final String? phone;
  final String? role;
  final String language;
  final String theme;
  final DateTime createdAt;
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
    this.avatarUrl,
    this.birthDate,
    this.phone,
    this.role,
    required this.language,
    required this.theme,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['email_verified'] = Variable<bool>(emailVerified);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    map['language'] = Variable<String>(language);
    map['theme'] = Variable<String>(theme);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      emailVerified: Value(emailVerified),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      language: Value(language),
      theme: Value(theme),
      createdAt: Value(createdAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      phone: serializer.fromJson<String?>(json['phone']),
      role: serializer.fromJson<String?>(json['role']),
      language: serializer.fromJson<String>(json['language']),
      theme: serializer.fromJson<String>(json['theme']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'emailVerified': serializer.toJson<bool>(emailVerified),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'phone': serializer.toJson<String?>(phone),
      'role': serializer.toJson<String?>(role),
      'language': serializer.toJson<String>(language),
      'theme': serializer.toJson<String>(theme),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? emailVerified,
    Value<String?> avatarUrl = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> role = const Value.absent(),
    String? language,
    String? theme,
    DateTime? createdAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    emailVerified: emailVerified ?? this.emailVerified,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    phone: phone.present ? phone.value : this.phone,
    role: role.present ? role.value : this.role,
    language: language ?? this.language,
    theme: theme ?? this.theme,
    createdAt: createdAt ?? this.createdAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      phone: data.phone.present ? data.phone.value : this.phone,
      role: data.role.present ? data.role.value : this.role,
      language: data.language.present ? data.language.value : this.language,
      theme: data.theme.present ? data.theme.value : this.theme,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('birthDate: $birthDate, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('language: $language, ')
          ..write('theme: $theme, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    emailVerified,
    avatarUrl,
    birthDate,
    phone,
    role,
    language,
    theme,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.emailVerified == this.emailVerified &&
          other.avatarUrl == this.avatarUrl &&
          other.birthDate == this.birthDate &&
          other.phone == this.phone &&
          other.role == this.role &&
          other.language == this.language &&
          other.theme == this.theme &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<bool> emailVerified;
  final Value<String?> avatarUrl;
  final Value<DateTime?> birthDate;
  final Value<String?> phone;
  final Value<String?> role;
  final Value<String> language;
  final Value<String> theme;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.role = const Value.absent(),
    this.language = const Value.absent(),
    this.theme = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    required String email,
    this.emailVerified = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.role = const Value.absent(),
    this.language = const Value.absent(),
    this.theme = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email),
       createdAt = Value(createdAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<bool>? emailVerified,
    Expression<String>? avatarUrl,
    Expression<DateTime>? birthDate,
    Expression<String>? phone,
    Expression<String>? role,
    Expression<String>? language,
    Expression<String>? theme,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (emailVerified != null) 'email_verified': emailVerified,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (birthDate != null) 'birth_date': birthDate,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      if (language != null) 'language': language,
      if (theme != null) 'theme': theme,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<bool>? emailVerified,
    Value<String?>? avatarUrl,
    Value<DateTime?>? birthDate,
    Value<String?>? phone,
    Value<String?>? role,
    Value<String>? language,
    Value<String>? theme,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('birthDate: $birthDate, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('language: $language, ')
          ..write('theme: $theme, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsRowsTable extends SettingsRows
    with TableInfo<$SettingsRowsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsRowsTable createAlias(String alias) {
    return $SettingsRowsTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final String key;
  final String value;
  const SettingsRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return SettingsRowsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingsRow copyWith({String? key, String? value}) =>
      SettingsRow(key: key ?? this.key, value: value ?? this.value);
  SettingsRow copyWithCompanion(SettingsRowsCompanion data) {
    return SettingsRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsRowsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsRowsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsRowsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingsRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsRowsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsRowsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRowsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamiliesTable extends Families with TableInfo<$FamiliesTable, Family> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partnerUserIdsMeta = const VerificationMeta(
    'partnerUserIds',
  );
  @override
  late final GeneratedColumn<String> partnerUserIds = GeneratedColumn<String>(
    'partner_user_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _activeBabyIdMeta = const VerificationMeta(
    'activeBabyId',
  );
  @override
  late final GeneratedColumn<String> activeBabyId = GeneratedColumn<String>(
    'active_baby_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    partnerUserIds,
    activeBabyId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'families';
  @override
  VerificationContext validateIntegrity(
    Insertable<Family> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('partner_user_ids')) {
      context.handle(
        _partnerUserIdsMeta,
        partnerUserIds.isAcceptableOrUnknown(
          data['partner_user_ids']!,
          _partnerUserIdsMeta,
        ),
      );
    }
    if (data.containsKey('active_baby_id')) {
      context.handle(
        _activeBabyIdMeta,
        activeBabyId.isAcceptableOrUnknown(
          data['active_baby_id']!,
          _activeBabyIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Family map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Family(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      partnerUserIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partner_user_ids'],
      )!,
      activeBabyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_baby_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FamiliesTable createAlias(String alias) {
    return $FamiliesTable(attachedDatabase, alias);
  }
}

class Family extends DataClass implements Insertable<Family> {
  final String id;
  final String ownerUserId;
  final String partnerUserIds;
  final String? activeBabyId;
  final DateTime createdAt;
  const Family({
    required this.id,
    required this.ownerUserId,
    required this.partnerUserIds,
    this.activeBabyId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['partner_user_ids'] = Variable<String>(partnerUserIds);
    if (!nullToAbsent || activeBabyId != null) {
      map['active_baby_id'] = Variable<String>(activeBabyId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FamiliesCompanion toCompanion(bool nullToAbsent) {
    return FamiliesCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      partnerUserIds: Value(partnerUserIds),
      activeBabyId: activeBabyId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeBabyId),
      createdAt: Value(createdAt),
    );
  }

  factory Family.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Family(
      id: serializer.fromJson<String>(json['id']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      partnerUserIds: serializer.fromJson<String>(json['partnerUserIds']),
      activeBabyId: serializer.fromJson<String?>(json['activeBabyId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'partnerUserIds': serializer.toJson<String>(partnerUserIds),
      'activeBabyId': serializer.toJson<String?>(activeBabyId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Family copyWith({
    String? id,
    String? ownerUserId,
    String? partnerUserIds,
    Value<String?> activeBabyId = const Value.absent(),
    DateTime? createdAt,
  }) => Family(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    partnerUserIds: partnerUserIds ?? this.partnerUserIds,
    activeBabyId: activeBabyId.present ? activeBabyId.value : this.activeBabyId,
    createdAt: createdAt ?? this.createdAt,
  );
  Family copyWithCompanion(FamiliesCompanion data) {
    return Family(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      partnerUserIds: data.partnerUserIds.present
          ? data.partnerUserIds.value
          : this.partnerUserIds,
      activeBabyId: data.activeBabyId.present
          ? data.activeBabyId.value
          : this.activeBabyId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Family(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('partnerUserIds: $partnerUserIds, ')
          ..write('activeBabyId: $activeBabyId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerUserId, partnerUserIds, activeBabyId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Family &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.partnerUserIds == this.partnerUserIds &&
          other.activeBabyId == this.activeBabyId &&
          other.createdAt == this.createdAt);
}

class FamiliesCompanion extends UpdateCompanion<Family> {
  final Value<String> id;
  final Value<String> ownerUserId;
  final Value<String> partnerUserIds;
  final Value<String?> activeBabyId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FamiliesCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.partnerUserIds = const Value.absent(),
    this.activeBabyId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamiliesCompanion.insert({
    required String id,
    required String ownerUserId,
    this.partnerUserIds = const Value.absent(),
    this.activeBabyId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUserId = Value(ownerUserId),
       createdAt = Value(createdAt);
  static Insertable<Family> custom({
    Expression<String>? id,
    Expression<String>? ownerUserId,
    Expression<String>? partnerUserIds,
    Expression<String>? activeBabyId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (partnerUserIds != null) 'partner_user_ids': partnerUserIds,
      if (activeBabyId != null) 'active_baby_id': activeBabyId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamiliesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUserId,
    Value<String>? partnerUserIds,
    Value<String?>? activeBabyId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FamiliesCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      partnerUserIds: partnerUserIds ?? this.partnerUserIds,
      activeBabyId: activeBabyId ?? this.activeBabyId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (partnerUserIds.present) {
      map['partner_user_ids'] = Variable<String>(partnerUserIds.value);
    }
    if (activeBabyId.present) {
      map['active_baby_id'] = Variable<String>(activeBabyId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('partnerUserIds: $partnerUserIds, ')
          ..write('activeBabyId: $activeBabyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BabiesTable extends Babies with TableInfo<$BabiesTable, Baby> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BabiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthWeightMeta = const VerificationMeta(
    'birthWeight',
  );
  @override
  late final GeneratedColumn<double> birthWeight = GeneratedColumn<double>(
    'birth_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthHeightMeta = const VerificationMeta(
    'birthHeight',
  );
  @override
  late final GeneratedColumn<double> birthHeight = GeneratedColumn<double>(
    'birth_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthHeadCircumferenceMeta =
      const VerificationMeta('birthHeadCircumference');
  @override
  late final GeneratedColumn<double> birthHeadCircumference =
      GeneratedColumn<double>(
        'birth_head_circumference',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _currentWeightMeta = const VerificationMeta(
    'currentWeight',
  );
  @override
  late final GeneratedColumn<double> currentWeight = GeneratedColumn<double>(
    'current_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentHeightMeta = const VerificationMeta(
    'currentHeight',
  );
  @override
  late final GeneratedColumn<double> currentHeight = GeneratedColumn<double>(
    'current_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentHeadCircumferenceMeta =
      const VerificationMeta('currentHeadCircumference');
  @override
  late final GeneratedColumn<double> currentHeadCircumference =
      GeneratedColumn<double>(
        'current_head_circumference',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    name,
    birthDate,
    gender,
    birthWeight,
    birthHeight,
    birthHeadCircumference,
    currentWeight,
    currentHeight,
    currentHeadCircumference,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'babies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Baby> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('birth_weight')) {
      context.handle(
        _birthWeightMeta,
        birthWeight.isAcceptableOrUnknown(
          data['birth_weight']!,
          _birthWeightMeta,
        ),
      );
    }
    if (data.containsKey('birth_height')) {
      context.handle(
        _birthHeightMeta,
        birthHeight.isAcceptableOrUnknown(
          data['birth_height']!,
          _birthHeightMeta,
        ),
      );
    }
    if (data.containsKey('birth_head_circumference')) {
      context.handle(
        _birthHeadCircumferenceMeta,
        birthHeadCircumference.isAcceptableOrUnknown(
          data['birth_head_circumference']!,
          _birthHeadCircumferenceMeta,
        ),
      );
    }
    if (data.containsKey('current_weight')) {
      context.handle(
        _currentWeightMeta,
        currentWeight.isAcceptableOrUnknown(
          data['current_weight']!,
          _currentWeightMeta,
        ),
      );
    }
    if (data.containsKey('current_height')) {
      context.handle(
        _currentHeightMeta,
        currentHeight.isAcceptableOrUnknown(
          data['current_height']!,
          _currentHeightMeta,
        ),
      );
    }
    if (data.containsKey('current_head_circumference')) {
      context.handle(
        _currentHeadCircumferenceMeta,
        currentHeadCircumference.isAcceptableOrUnknown(
          data['current_head_circumference']!,
          _currentHeadCircumferenceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Baby map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Baby(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      birthWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_weight'],
      ),
      birthHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_height'],
      ),
      birthHeadCircumference: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_head_circumference'],
      ),
      currentWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight'],
      ),
      currentHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_height'],
      ),
      currentHeadCircumference: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_head_circumference'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BabiesTable createAlias(String alias) {
    return $BabiesTable(attachedDatabase, alias);
  }
}

class Baby extends DataClass implements Insertable<Baby> {
  final String id;
  final String familyId;
  final String name;
  final DateTime birthDate;
  final String? gender;
  final double? birthWeight;
  final double? birthHeight;
  final double? birthHeadCircumference;
  final double? currentWeight;
  final double? currentHeight;
  final double? currentHeadCircumference;
  final DateTime createdAt;
  const Baby({
    required this.id,
    required this.familyId,
    required this.name,
    required this.birthDate,
    this.gender,
    this.birthWeight,
    this.birthHeight,
    this.birthHeadCircumference,
    this.currentWeight,
    this.currentHeight,
    this.currentHeadCircumference,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || birthWeight != null) {
      map['birth_weight'] = Variable<double>(birthWeight);
    }
    if (!nullToAbsent || birthHeight != null) {
      map['birth_height'] = Variable<double>(birthHeight);
    }
    if (!nullToAbsent || birthHeadCircumference != null) {
      map['birth_head_circumference'] = Variable<double>(
        birthHeadCircumference,
      );
    }
    if (!nullToAbsent || currentWeight != null) {
      map['current_weight'] = Variable<double>(currentWeight);
    }
    if (!nullToAbsent || currentHeight != null) {
      map['current_height'] = Variable<double>(currentHeight);
    }
    if (!nullToAbsent || currentHeadCircumference != null) {
      map['current_head_circumference'] = Variable<double>(
        currentHeadCircumference,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BabiesCompanion toCompanion(bool nullToAbsent) {
    return BabiesCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      birthDate: Value(birthDate),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      birthWeight: birthWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(birthWeight),
      birthHeight: birthHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(birthHeight),
      birthHeadCircumference: birthHeadCircumference == null && nullToAbsent
          ? const Value.absent()
          : Value(birthHeadCircumference),
      currentWeight: currentWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(currentWeight),
      currentHeight: currentHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(currentHeight),
      currentHeadCircumference: currentHeadCircumference == null && nullToAbsent
          ? const Value.absent()
          : Value(currentHeadCircumference),
      createdAt: Value(createdAt),
    );
  }

  factory Baby.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Baby(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      birthWeight: serializer.fromJson<double?>(json['birthWeight']),
      birthHeight: serializer.fromJson<double?>(json['birthHeight']),
      birthHeadCircumference: serializer.fromJson<double?>(
        json['birthHeadCircumference'],
      ),
      currentWeight: serializer.fromJson<double?>(json['currentWeight']),
      currentHeight: serializer.fromJson<double?>(json['currentHeight']),
      currentHeadCircumference: serializer.fromJson<double?>(
        json['currentHeadCircumference'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'birthWeight': serializer.toJson<double?>(birthWeight),
      'birthHeight': serializer.toJson<double?>(birthHeight),
      'birthHeadCircumference': serializer.toJson<double?>(
        birthHeadCircumference,
      ),
      'currentWeight': serializer.toJson<double?>(currentWeight),
      'currentHeight': serializer.toJson<double?>(currentHeight),
      'currentHeadCircumference': serializer.toJson<double?>(
        currentHeadCircumference,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Baby copyWith({
    String? id,
    String? familyId,
    String? name,
    DateTime? birthDate,
    Value<String?> gender = const Value.absent(),
    Value<double?> birthWeight = const Value.absent(),
    Value<double?> birthHeight = const Value.absent(),
    Value<double?> birthHeadCircumference = const Value.absent(),
    Value<double?> currentWeight = const Value.absent(),
    Value<double?> currentHeight = const Value.absent(),
    Value<double?> currentHeadCircumference = const Value.absent(),
    DateTime? createdAt,
  }) => Baby(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    birthWeight: birthWeight.present ? birthWeight.value : this.birthWeight,
    birthHeight: birthHeight.present ? birthHeight.value : this.birthHeight,
    birthHeadCircumference: birthHeadCircumference.present
        ? birthHeadCircumference.value
        : this.birthHeadCircumference,
    currentWeight: currentWeight.present
        ? currentWeight.value
        : this.currentWeight,
    currentHeight: currentHeight.present
        ? currentHeight.value
        : this.currentHeight,
    currentHeadCircumference: currentHeadCircumference.present
        ? currentHeadCircumference.value
        : this.currentHeadCircumference,
    createdAt: createdAt ?? this.createdAt,
  );
  Baby copyWithCompanion(BabiesCompanion data) {
    return Baby(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthWeight: data.birthWeight.present
          ? data.birthWeight.value
          : this.birthWeight,
      birthHeight: data.birthHeight.present
          ? data.birthHeight.value
          : this.birthHeight,
      birthHeadCircumference: data.birthHeadCircumference.present
          ? data.birthHeadCircumference.value
          : this.birthHeadCircumference,
      currentWeight: data.currentWeight.present
          ? data.currentWeight.value
          : this.currentWeight,
      currentHeight: data.currentHeight.present
          ? data.currentHeight.value
          : this.currentHeight,
      currentHeadCircumference: data.currentHeadCircumference.present
          ? data.currentHeadCircumference.value
          : this.currentHeadCircumference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Baby(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('birthHeadCircumference: $birthHeadCircumference, ')
          ..write('currentWeight: $currentWeight, ')
          ..write('currentHeight: $currentHeight, ')
          ..write('currentHeadCircumference: $currentHeadCircumference, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    name,
    birthDate,
    gender,
    birthWeight,
    birthHeight,
    birthHeadCircumference,
    currentWeight,
    currentHeight,
    currentHeadCircumference,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Baby &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.birthWeight == this.birthWeight &&
          other.birthHeight == this.birthHeight &&
          other.birthHeadCircumference == this.birthHeadCircumference &&
          other.currentWeight == this.currentWeight &&
          other.currentHeight == this.currentHeight &&
          other.currentHeadCircumference == this.currentHeadCircumference &&
          other.createdAt == this.createdAt);
}

class BabiesCompanion extends UpdateCompanion<Baby> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<String?> gender;
  final Value<double?> birthWeight;
  final Value<double?> birthHeight;
  final Value<double?> birthHeadCircumference;
  final Value<double?> currentWeight;
  final Value<double?> currentHeight;
  final Value<double?> currentHeadCircumference;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BabiesCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.birthHeadCircumference = const Value.absent(),
    this.currentWeight = const Value.absent(),
    this.currentHeight = const Value.absent(),
    this.currentHeadCircumference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BabiesCompanion.insert({
    required String id,
    required String familyId,
    required String name,
    required DateTime birthDate,
    this.gender = const Value.absent(),
    this.birthWeight = const Value.absent(),
    this.birthHeight = const Value.absent(),
    this.birthHeadCircumference = const Value.absent(),
    this.currentWeight = const Value.absent(),
    this.currentHeight = const Value.absent(),
    this.currentHeadCircumference = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       name = Value(name),
       birthDate = Value(birthDate),
       createdAt = Value(createdAt);
  static Insertable<Baby> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<String>? gender,
    Expression<double>? birthWeight,
    Expression<double>? birthHeight,
    Expression<double>? birthHeadCircumference,
    Expression<double>? currentWeight,
    Expression<double>? currentHeight,
    Expression<double>? currentHeadCircumference,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (birthWeight != null) 'birth_weight': birthWeight,
      if (birthHeight != null) 'birth_height': birthHeight,
      if (birthHeadCircumference != null)
        'birth_head_circumference': birthHeadCircumference,
      if (currentWeight != null) 'current_weight': currentWeight,
      if (currentHeight != null) 'current_height': currentHeight,
      if (currentHeadCircumference != null)
        'current_head_circumference': currentHeadCircumference,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BabiesCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String>? name,
    Value<DateTime>? birthDate,
    Value<String?>? gender,
    Value<double?>? birthWeight,
    Value<double?>? birthHeight,
    Value<double?>? birthHeadCircumference,
    Value<double?>? currentWeight,
    Value<double?>? currentHeight,
    Value<double?>? currentHeadCircumference,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BabiesCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      birthWeight: birthWeight ?? this.birthWeight,
      birthHeight: birthHeight ?? this.birthHeight,
      birthHeadCircumference:
          birthHeadCircumference ?? this.birthHeadCircumference,
      currentWeight: currentWeight ?? this.currentWeight,
      currentHeight: currentHeight ?? this.currentHeight,
      currentHeadCircumference:
          currentHeadCircumference ?? this.currentHeadCircumference,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthWeight.present) {
      map['birth_weight'] = Variable<double>(birthWeight.value);
    }
    if (birthHeight.present) {
      map['birth_height'] = Variable<double>(birthHeight.value);
    }
    if (birthHeadCircumference.present) {
      map['birth_head_circumference'] = Variable<double>(
        birthHeadCircumference.value,
      );
    }
    if (currentWeight.present) {
      map['current_weight'] = Variable<double>(currentWeight.value);
    }
    if (currentHeight.present) {
      map['current_height'] = Variable<double>(currentHeight.value);
    }
    if (currentHeadCircumference.present) {
      map['current_head_circumference'] = Variable<double>(
        currentHeadCircumference.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BabiesCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('birthWeight: $birthWeight, ')
          ..write('birthHeight: $birthHeight, ')
          ..write('birthHeadCircumference: $birthHeadCircumference, ')
          ..write('currentWeight: $currentWeight, ')
          ..write('currentHeight: $currentHeight, ')
          ..write('currentHeadCircumference: $currentHeadCircumference, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PregnanciesTable extends Pregnancies
    with TableInfo<$PregnanciesTable, Pregnancy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PregnanciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthCompletedAtMeta = const VerificationMeta(
    'birthCompletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> birthCompletedAt =
      GeneratedColumn<DateTime>(
        'birth_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    startDate,
    dueDate,
    status,
    birthCompletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pregnancies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pregnancy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('birth_completed_at')) {
      context.handle(
        _birthCompletedAtMeta,
        birthCompletedAt.isAcceptableOrUnknown(
          data['birth_completed_at']!,
          _birthCompletedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pregnancy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pregnancy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      birthCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_completed_at'],
      ),
    );
  }

  @override
  $PregnanciesTable createAlias(String alias) {
    return $PregnanciesTable(attachedDatabase, alias);
  }
}

class Pregnancy extends DataClass implements Insertable<Pregnancy> {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime dueDate;
  final String status;
  final DateTime? birthCompletedAt;
  const Pregnancy({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.dueDate,
    required this.status,
    this.birthCompletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || birthCompletedAt != null) {
      map['birth_completed_at'] = Variable<DateTime>(birthCompletedAt);
    }
    return map;
  }

  PregnanciesCompanion toCompanion(bool nullToAbsent) {
    return PregnanciesCompanion(
      id: Value(id),
      userId: Value(userId),
      startDate: Value(startDate),
      dueDate: Value(dueDate),
      status: Value(status),
      birthCompletedAt: birthCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(birthCompletedAt),
    );
  }

  factory Pregnancy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pregnancy(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      birthCompletedAt: serializer.fromJson<DateTime?>(
        json['birthCompletedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(status),
      'birthCompletedAt': serializer.toJson<DateTime?>(birthCompletedAt),
    };
  }

  Pregnancy copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? dueDate,
    String? status,
    Value<DateTime?> birthCompletedAt = const Value.absent(),
  }) => Pregnancy(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    startDate: startDate ?? this.startDate,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    birthCompletedAt: birthCompletedAt.present
        ? birthCompletedAt.value
        : this.birthCompletedAt,
  );
  Pregnancy copyWithCompanion(PregnanciesCompanion data) {
    return Pregnancy(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      birthCompletedAt: data.birthCompletedAt.present
          ? data.birthCompletedAt.value
          : this.birthCompletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pregnancy(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('birthCompletedAt: $birthCompletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, startDate, dueDate, status, birthCompletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pregnancy &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startDate == this.startDate &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.birthCompletedAt == this.birthCompletedAt);
}

class PregnanciesCompanion extends UpdateCompanion<Pregnancy> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> startDate;
  final Value<DateTime> dueDate;
  final Value<String> status;
  final Value<DateTime?> birthCompletedAt;
  final Value<int> rowid;
  const PregnanciesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.birthCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PregnanciesCompanion.insert({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime dueDate,
    required String status,
    this.birthCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       startDate = Value(startDate),
       dueDate = Value(dueDate),
       status = Value(status);
  static Insertable<Pregnancy> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<DateTime>? birthCompletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startDate != null) 'start_date': startDate,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (birthCompletedAt != null) 'birth_completed_at': birthCompletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PregnanciesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? startDate,
    Value<DateTime>? dueDate,
    Value<String>? status,
    Value<DateTime?>? birthCompletedAt,
    Value<int>? rowid,
  }) {
    return PregnanciesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      birthCompletedAt: birthCompletedAt ?? this.birthCompletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (birthCompletedAt.present) {
      map['birth_completed_at'] = Variable<DateTime>(birthCompletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PregnanciesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startDate: $startDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('birthCompletedAt: $birthCompletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackerRecordsTable extends TrackerRecords
    with TableInfo<$TrackerRecordsTable, TrackerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<String> babyId = GeneratedColumn<String>(
    'baby_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByNameMeta = const VerificationMeta(
    'createdByName',
  );
  @override
  late final GeneratedColumn<String> createdByName = GeneratedColumn<String>(
    'created_by_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByUserIdMeta = const VerificationMeta(
    'updatedByUserId',
  );
  @override
  late final GeneratedColumn<String> updatedByUserId = GeneratedColumn<String>(
    'updated_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedByNameMeta = const VerificationMeta(
    'updatedByName',
  );
  @override
  late final GeneratedColumn<String> updatedByName = GeneratedColumn<String>(
    'updated_by_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    familyId,
    babyId,
    value,
    note,
    createdByUserId,
    createdByName,
    updatedByUserId,
    updatedByName,
    occurredAt,
    createdAt,
    updatedAt,
    syncStatus,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracker_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackerRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('created_by_name')) {
      context.handle(
        _createdByNameMeta,
        createdByName.isAcceptableOrUnknown(
          data['created_by_name']!,
          _createdByNameMeta,
        ),
      );
    }
    if (data.containsKey('updated_by_user_id')) {
      context.handle(
        _updatedByUserIdMeta,
        updatedByUserId.isAcceptableOrUnknown(
          data['updated_by_user_id']!,
          _updatedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_by_name')) {
      context.handle(
        _updatedByNameMeta,
        updatedByName.isAcceptableOrUnknown(
          data['updated_by_name']!,
          _updatedByNameMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackerRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      ),
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baby_id'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      ),
      createdByName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_name'],
      ),
      updatedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_user_id'],
      ),
      updatedByName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by_name'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TrackerRecordsTable createAlias(String alias) {
    return $TrackerRecordsTable(attachedDatabase, alias);
  }
}

class TrackerRecord extends DataClass implements Insertable<TrackerRecord> {
  final String id;
  final String type;
  final String title;
  final String? familyId;
  final String? babyId;
  final String? value;
  final String? note;
  final String? createdByUserId;
  final String? createdByName;
  final String? updatedByUserId;
  final String? updatedByName;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? deletedAt;
  const TrackerRecord({
    required this.id,
    required this.type,
    required this.title,
    this.familyId,
    this.babyId,
    this.value,
    this.note,
    this.createdByUserId,
    this.createdByName,
    this.updatedByUserId,
    this.updatedByName,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<String>(familyId);
    }
    if (!nullToAbsent || babyId != null) {
      map['baby_id'] = Variable<String>(babyId);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<String>(createdByUserId);
    }
    if (!nullToAbsent || createdByName != null) {
      map['created_by_name'] = Variable<String>(createdByName);
    }
    if (!nullToAbsent || updatedByUserId != null) {
      map['updated_by_user_id'] = Variable<String>(updatedByUserId);
    }
    if (!nullToAbsent || updatedByName != null) {
      map['updated_by_name'] = Variable<String>(updatedByName);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TrackerRecordsCompanion toCompanion(bool nullToAbsent) {
    return TrackerRecordsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      babyId: babyId == null && nullToAbsent
          ? const Value.absent()
          : Value(babyId),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
      createdByName: createdByName == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByName),
      updatedByUserId: updatedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByUserId),
      updatedByName: updatedByName == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedByName),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TrackerRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackerRecord(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      familyId: serializer.fromJson<String?>(json['familyId']),
      babyId: serializer.fromJson<String?>(json['babyId']),
      value: serializer.fromJson<String?>(json['value']),
      note: serializer.fromJson<String?>(json['note']),
      createdByUserId: serializer.fromJson<String?>(json['createdByUserId']),
      createdByName: serializer.fromJson<String?>(json['createdByName']),
      updatedByUserId: serializer.fromJson<String?>(json['updatedByUserId']),
      updatedByName: serializer.fromJson<String?>(json['updatedByName']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'familyId': serializer.toJson<String?>(familyId),
      'babyId': serializer.toJson<String?>(babyId),
      'value': serializer.toJson<String?>(value),
      'note': serializer.toJson<String?>(note),
      'createdByUserId': serializer.toJson<String?>(createdByUserId),
      'createdByName': serializer.toJson<String?>(createdByName),
      'updatedByUserId': serializer.toJson<String?>(updatedByUserId),
      'updatedByName': serializer.toJson<String?>(updatedByName),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TrackerRecord copyWith({
    String? id,
    String? type,
    String? title,
    Value<String?> familyId = const Value.absent(),
    Value<String?> babyId = const Value.absent(),
    Value<String?> value = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> createdByUserId = const Value.absent(),
    Value<String?> createdByName = const Value.absent(),
    Value<String?> updatedByUserId = const Value.absent(),
    Value<String?> updatedByName = const Value.absent(),
    DateTime? occurredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TrackerRecord(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    familyId: familyId.present ? familyId.value : this.familyId,
    babyId: babyId.present ? babyId.value : this.babyId,
    value: value.present ? value.value : this.value,
    note: note.present ? note.value : this.note,
    createdByUserId: createdByUserId.present
        ? createdByUserId.value
        : this.createdByUserId,
    createdByName: createdByName.present
        ? createdByName.value
        : this.createdByName,
    updatedByUserId: updatedByUserId.present
        ? updatedByUserId.value
        : this.updatedByUserId,
    updatedByName: updatedByName.present
        ? updatedByName.value
        : this.updatedByName,
    occurredAt: occurredAt ?? this.occurredAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TrackerRecord copyWithCompanion(TrackerRecordsCompanion data) {
    return TrackerRecord(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      value: data.value.present ? data.value.value : this.value,
      note: data.note.present ? data.note.value : this.note,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      createdByName: data.createdByName.present
          ? data.createdByName.value
          : this.createdByName,
      updatedByUserId: data.updatedByUserId.present
          ? data.updatedByUserId.value
          : this.updatedByUserId,
      updatedByName: data.updatedByName.present
          ? data.updatedByName.value
          : this.updatedByName,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackerRecord(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('familyId: $familyId, ')
          ..write('babyId: $babyId, ')
          ..write('value: $value, ')
          ..write('note: $note, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('createdByName: $createdByName, ')
          ..write('updatedByUserId: $updatedByUserId, ')
          ..write('updatedByName: $updatedByName, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    familyId,
    babyId,
    value,
    note,
    createdByUserId,
    createdByName,
    updatedByUserId,
    updatedByName,
    occurredAt,
    createdAt,
    updatedAt,
    syncStatus,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackerRecord &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.familyId == this.familyId &&
          other.babyId == this.babyId &&
          other.value == this.value &&
          other.note == this.note &&
          other.createdByUserId == this.createdByUserId &&
          other.createdByName == this.createdByName &&
          other.updatedByUserId == this.updatedByUserId &&
          other.updatedByName == this.updatedByName &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.deletedAt == this.deletedAt);
}

class TrackerRecordsCompanion extends UpdateCompanion<TrackerRecord> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> familyId;
  final Value<String?> babyId;
  final Value<String?> value;
  final Value<String?> note;
  final Value<String?> createdByUserId;
  final Value<String?> createdByName;
  final Value<String?> updatedByUserId;
  final Value<String?> updatedByName;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TrackerRecordsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.familyId = const Value.absent(),
    this.babyId = const Value.absent(),
    this.value = const Value.absent(),
    this.note = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.createdByName = const Value.absent(),
    this.updatedByUserId = const Value.absent(),
    this.updatedByName = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackerRecordsCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.familyId = const Value.absent(),
    this.babyId = const Value.absent(),
    this.value = const Value.absent(),
    this.note = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.createdByName = const Value.absent(),
    this.updatedByUserId = const Value.absent(),
    this.updatedByName = const Value.absent(),
    required DateTime occurredAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TrackerRecord> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? familyId,
    Expression<String>? babyId,
    Expression<String>? value,
    Expression<String>? note,
    Expression<String>? createdByUserId,
    Expression<String>? createdByName,
    Expression<String>? updatedByUserId,
    Expression<String>? updatedByName,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (familyId != null) 'family_id': familyId,
      if (babyId != null) 'baby_id': babyId,
      if (value != null) 'value': value,
      if (note != null) 'note': note,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (createdByName != null) 'created_by_name': createdByName,
      if (updatedByUserId != null) 'updated_by_user_id': updatedByUserId,
      if (updatedByName != null) 'updated_by_name': updatedByName,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackerRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? familyId,
    Value<String?>? babyId,
    Value<String?>? value,
    Value<String?>? note,
    Value<String?>? createdByUserId,
    Value<String?>? createdByName,
    Value<String?>? updatedByUserId,
    Value<String?>? updatedByName,
    Value<DateTime>? occurredAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? syncStatus,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TrackerRecordsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      familyId: familyId ?? this.familyId,
      babyId: babyId ?? this.babyId,
      value: value ?? this.value,
      note: note ?? this.note,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByName: createdByName ?? this.createdByName,
      updatedByUserId: updatedByUserId ?? this.updatedByUserId,
      updatedByName: updatedByName ?? this.updatedByName,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<String>(babyId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (createdByName.present) {
      map['created_by_name'] = Variable<String>(createdByName.value);
    }
    if (updatedByUserId.present) {
      map['updated_by_user_id'] = Variable<String>(updatedByUserId.value);
    }
    if (updatedByName.present) {
      map['updated_by_name'] = Variable<String>(updatedByName.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('familyId: $familyId, ')
          ..write('babyId: $babyId, ')
          ..write('value: $value, ')
          ..write('note: $note, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('createdByName: $createdByName, ')
          ..write('updatedByUserId: $updatedByUserId, ')
          ..write('updatedByName: $updatedByName, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    time,
    frequency,
    notes,
    isActive,
    ownerUserId,
    familyId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      ),
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String title;
  final String category;
  final DateTime time;
  final String frequency;
  final String? notes;
  final bool isActive;
  final String? ownerUserId;
  final String? familyId;
  final DateTime createdAt;
  const Reminder({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.frequency,
    this.notes,
    required this.isActive,
    this.ownerUserId,
    this.familyId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['time'] = Variable<DateTime>(time);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || ownerUserId != null) {
      map['owner_user_id'] = Variable<String>(ownerUserId);
    }
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<String>(familyId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      time: Value(time),
      frequency: Value(frequency),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      ownerUserId: ownerUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerUserId),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      createdAt: Value(createdAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      time: serializer.fromJson<DateTime>(json['time']),
      frequency: serializer.fromJson<String>(json['frequency']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      ownerUserId: serializer.fromJson<String?>(json['ownerUserId']),
      familyId: serializer.fromJson<String?>(json['familyId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'time': serializer.toJson<DateTime>(time),
      'frequency': serializer.toJson<String>(frequency),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'ownerUserId': serializer.toJson<String?>(ownerUserId),
      'familyId': serializer.toJson<String?>(familyId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reminder copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? time,
    String? frequency,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    Value<String?> ownerUserId = const Value.absent(),
    Value<String?> familyId = const Value.absent(),
    DateTime? createdAt,
  }) => Reminder(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    time: time ?? this.time,
    frequency: frequency ?? this.frequency,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    ownerUserId: ownerUserId.present ? ownerUserId.value : this.ownerUserId,
    familyId: familyId.present ? familyId.value : this.familyId,
    createdAt: createdAt ?? this.createdAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      time: data.time.present ? data.time.value : this.time,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('time: $time, ')
          ..write('frequency: $frequency, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('familyId: $familyId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    time,
    frequency,
    notes,
    isActive,
    ownerUserId,
    familyId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.time == this.time &&
          other.frequency == this.frequency &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.ownerUserId == this.ownerUserId &&
          other.familyId == this.familyId &&
          other.createdAt == this.createdAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<DateTime> time;
  final Value<String> frequency;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<String?> ownerUserId;
  final Value<String?> familyId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.time = const Value.absent(),
    this.frequency = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.familyId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String title,
    required String category,
    required DateTime time,
    this.frequency = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.familyId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       time = Value(time),
       createdAt = Value(createdAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<DateTime>? time,
    Expression<String>? frequency,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<String>? ownerUserId,
    Expression<String>? familyId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (time != null) 'time': time,
      if (frequency != null) 'frequency': frequency,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (familyId != null) 'family_id': familyId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? category,
    Value<DateTime>? time,
    Value<String>? frequency,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<String?>? ownerUserId,
    Value<String?>? familyId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      time: time ?? this.time,
      frequency: frequency ?? this.frequency,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      familyId: familyId ?? this.familyId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('time: $time, ')
          ..write('frequency: $frequency, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('familyId: $familyId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppNotificationsTable extends AppNotifications
    with TableInfo<$AppNotificationsTable, AppNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetUserIdsMeta = const VerificationMeta(
    'targetUserIds',
  );
  @override
  late final GeneratedColumn<String> targetUserIds = GeneratedColumn<String>(
    'target_user_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readByMeta = const VerificationMeta('readBy');
  @override
  late final GeneratedColumn<String> readBy = GeneratedColumn<String>(
    'read_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _seenByMeta = const VerificationMeta('seenBy');
  @override
  late final GeneratedColumn<String> seenBy = GeneratedColumn<String>(
    'seen_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unread'),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    targetUserIds,
    createdBy,
    type,
    category,
    title,
    body,
    payload,
    readBy,
    seenBy,
    isDeleted,
    status,
    userId,
    createdAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    }
    if (data.containsKey('target_user_ids')) {
      context.handle(
        _targetUserIdsMeta,
        targetUserIds.isAcceptableOrUnknown(
          data['target_user_ids']!,
          _targetUserIdsMeta,
        ),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('read_by')) {
      context.handle(
        _readByMeta,
        readBy.isAcceptableOrUnknown(data['read_by']!, _readByMeta),
      );
    }
    if (data.containsKey('seen_by')) {
      context.handle(
        _seenByMeta,
        seenBy.isAcceptableOrUnknown(data['seen_by']!, _seenByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      ),
      targetUserIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_user_ids'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      readBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}read_by'],
      )!,
      seenBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seen_by'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $AppNotificationsTable createAlias(String alias) {
    return $AppNotificationsTable(attachedDatabase, alias);
  }
}

class AppNotification extends DataClass implements Insertable<AppNotification> {
  final String id;
  final String? familyId;
  final String targetUserIds;
  final String? createdBy;
  final String type;
  final String category;
  final String title;
  final String body;
  final String? payload;
  final String readBy;
  final String seenBy;
  final bool isDeleted;
  final String status;
  final String? userId;
  final DateTime createdAt;
  final DateTime? readAt;
  const AppNotification({
    required this.id,
    this.familyId,
    required this.targetUserIds,
    this.createdBy,
    required this.type,
    required this.category,
    required this.title,
    required this.body,
    this.payload,
    required this.readBy,
    required this.seenBy,
    required this.isDeleted,
    required this.status,
    this.userId,
    required this.createdAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || familyId != null) {
      map['family_id'] = Variable<String>(familyId);
    }
    map['target_user_ids'] = Variable<String>(targetUserIds);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['read_by'] = Variable<String>(readBy);
    map['seen_by'] = Variable<String>(seenBy);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  AppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return AppNotificationsCompanion(
      id: Value(id),
      familyId: familyId == null && nullToAbsent
          ? const Value.absent()
          : Value(familyId),
      targetUserIds: Value(targetUserIds),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      type: Value(type),
      category: Value(category),
      title: Value(title),
      body: Value(body),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      readBy: Value(readBy),
      seenBy: Value(seenBy),
      isDeleted: Value(isDeleted),
      status: Value(status),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory AppNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppNotification(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String?>(json['familyId']),
      targetUserIds: serializer.fromJson<String>(json['targetUserIds']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      payload: serializer.fromJson<String?>(json['payload']),
      readBy: serializer.fromJson<String>(json['readBy']),
      seenBy: serializer.fromJson<String>(json['seenBy']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      status: serializer.fromJson<String>(json['status']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String?>(familyId),
      'targetUserIds': serializer.toJson<String>(targetUserIds),
      'createdBy': serializer.toJson<String?>(createdBy),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'payload': serializer.toJson<String?>(payload),
      'readBy': serializer.toJson<String>(readBy),
      'seenBy': serializer.toJson<String>(seenBy),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'status': serializer.toJson<String>(status),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  AppNotification copyWith({
    String? id,
    Value<String?> familyId = const Value.absent(),
    String? targetUserIds,
    Value<String?> createdBy = const Value.absent(),
    String? type,
    String? category,
    String? title,
    String? body,
    Value<String?> payload = const Value.absent(),
    String? readBy,
    String? seenBy,
    bool? isDeleted,
    String? status,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> readAt = const Value.absent(),
  }) => AppNotification(
    id: id ?? this.id,
    familyId: familyId.present ? familyId.value : this.familyId,
    targetUserIds: targetUserIds ?? this.targetUserIds,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    type: type ?? this.type,
    category: category ?? this.category,
    title: title ?? this.title,
    body: body ?? this.body,
    payload: payload.present ? payload.value : this.payload,
    readBy: readBy ?? this.readBy,
    seenBy: seenBy ?? this.seenBy,
    isDeleted: isDeleted ?? this.isDeleted,
    status: status ?? this.status,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  AppNotification copyWithCompanion(AppNotificationsCompanion data) {
    return AppNotification(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      targetUserIds: data.targetUserIds.present
          ? data.targetUserIds.value
          : this.targetUserIds,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      payload: data.payload.present ? data.payload.value : this.payload,
      readBy: data.readBy.present ? data.readBy.value : this.readBy,
      seenBy: data.seenBy.present ? data.seenBy.value : this.seenBy,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      status: data.status.present ? data.status.value : this.status,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppNotification(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('targetUserIds: $targetUserIds, ')
          ..write('createdBy: $createdBy, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('payload: $payload, ')
          ..write('readBy: $readBy, ')
          ..write('seenBy: $seenBy, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('status: $status, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    targetUserIds,
    createdBy,
    type,
    category,
    title,
    body,
    payload,
    readBy,
    seenBy,
    isDeleted,
    status,
    userId,
    createdAt,
    readAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppNotification &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.targetUserIds == this.targetUserIds &&
          other.createdBy == this.createdBy &&
          other.type == this.type &&
          other.category == this.category &&
          other.title == this.title &&
          other.body == this.body &&
          other.payload == this.payload &&
          other.readBy == this.readBy &&
          other.seenBy == this.seenBy &&
          other.isDeleted == this.isDeleted &&
          other.status == this.status &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class AppNotificationsCompanion extends UpdateCompanion<AppNotification> {
  final Value<String> id;
  final Value<String?> familyId;
  final Value<String> targetUserIds;
  final Value<String?> createdBy;
  final Value<String> type;
  final Value<String> category;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> payload;
  final Value<String> readBy;
  final Value<String> seenBy;
  final Value<bool> isDeleted;
  final Value<String> status;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const AppNotificationsCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.targetUserIds = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.payload = const Value.absent(),
    this.readBy = const Value.absent(),
    this.seenBy = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.status = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppNotificationsCompanion.insert({
    required String id,
    this.familyId = const Value.absent(),
    this.targetUserIds = const Value.absent(),
    this.createdBy = const Value.absent(),
    required String type,
    required String category,
    required String title,
    required String body,
    this.payload = const Value.absent(),
    this.readBy = const Value.absent(),
    this.seenBy = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.status = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime createdAt,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       category = Value(category),
       title = Value(title),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<AppNotification> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? targetUserIds,
    Expression<String>? createdBy,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? payload,
    Expression<String>? readBy,
    Expression<String>? seenBy,
    Expression<bool>? isDeleted,
    Expression<String>? status,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (targetUserIds != null) 'target_user_ids': targetUserIds,
      if (createdBy != null) 'created_by': createdBy,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (payload != null) 'payload': payload,
      if (readBy != null) 'read_by': readBy,
      if (seenBy != null) 'seen_by': seenBy,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (status != null) 'status': status,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String?>? familyId,
    Value<String>? targetUserIds,
    Value<String?>? createdBy,
    Value<String>? type,
    Value<String>? category,
    Value<String>? title,
    Value<String>? body,
    Value<String?>? payload,
    Value<String>? readBy,
    Value<String>? seenBy,
    Value<bool>? isDeleted,
    Value<String>? status,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? readAt,
    Value<int>? rowid,
  }) {
    return AppNotificationsCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      targetUserIds: targetUserIds ?? this.targetUserIds,
      createdBy: createdBy ?? this.createdBy,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      readBy: readBy ?? this.readBy,
      seenBy: seenBy ?? this.seenBy,
      isDeleted: isDeleted ?? this.isDeleted,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (targetUserIds.present) {
      map['target_user_ids'] = Variable<String>(targetUserIds.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (readBy.present) {
      map['read_by'] = Variable<String>(readBy.value);
    }
    if (seenBy.present) {
      map['seen_by'] = Variable<String>(seenBy.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('targetUserIds: $targetUserIds, ')
          ..write('createdBy: $createdBy, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('payload: $payload, ')
          ..write('readBy: $readBy, ')
          ..write('seenBy: $seenBy, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('status: $status, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyInvitesTable extends FamilyInvites
    with TableInfo<$FamilyInvitesTable, FamilyInvite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyInvitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invitedEmailMeta = const VerificationMeta(
    'invitedEmail',
  );
  @override
  late final GeneratedColumn<String> invitedEmail = GeneratedColumn<String>(
    'invited_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invitedByUserIdMeta = const VerificationMeta(
    'invitedByUserId',
  );
  @override
  late final GeneratedColumn<String> invitedByUserId = GeneratedColumn<String>(
    'invited_by_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invitedByNameMeta = const VerificationMeta(
    'invitedByName',
  );
  @override
  late final GeneratedColumn<String> invitedByName = GeneratedColumn<String>(
    'invited_by_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invitedDisplayNameMeta =
      const VerificationMeta('invitedDisplayName');
  @override
  late final GeneratedColumn<String> invitedDisplayName =
      GeneratedColumn<String>(
        'invited_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _roleLabelMeta = const VerificationMeta(
    'roleLabel',
  );
  @override
  late final GeneratedColumn<String> roleLabel = GeneratedColumn<String>(
    'role_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionsJsonMeta = const VerificationMeta(
    'permissionsJson',
  );
  @override
  late final GeneratedColumn<String> permissionsJson = GeneratedColumn<String>(
    'permissions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _acceptedUserIdMeta = const VerificationMeta(
    'acceptedUserId',
  );
  @override
  late final GeneratedColumn<String> acceptedUserId = GeneratedColumn<String>(
    'accepted_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _respondedAtMeta = const VerificationMeta(
    'respondedAt',
  );
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
    'responded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    invitedEmail,
    invitedByUserId,
    invitedByName,
    invitedDisplayName,
    roleLabel,
    permissionsJson,
    acceptedUserId,
    status,
    createdAt,
    respondedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_invites';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyInvite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('invited_email')) {
      context.handle(
        _invitedEmailMeta,
        invitedEmail.isAcceptableOrUnknown(
          data['invited_email']!,
          _invitedEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invitedEmailMeta);
    }
    if (data.containsKey('invited_by_user_id')) {
      context.handle(
        _invitedByUserIdMeta,
        invitedByUserId.isAcceptableOrUnknown(
          data['invited_by_user_id']!,
          _invitedByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invitedByUserIdMeta);
    }
    if (data.containsKey('invited_by_name')) {
      context.handle(
        _invitedByNameMeta,
        invitedByName.isAcceptableOrUnknown(
          data['invited_by_name']!,
          _invitedByNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invitedByNameMeta);
    }
    if (data.containsKey('invited_display_name')) {
      context.handle(
        _invitedDisplayNameMeta,
        invitedDisplayName.isAcceptableOrUnknown(
          data['invited_display_name']!,
          _invitedDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('role_label')) {
      context.handle(
        _roleLabelMeta,
        roleLabel.isAcceptableOrUnknown(data['role_label']!, _roleLabelMeta),
      );
    }
    if (data.containsKey('permissions_json')) {
      context.handle(
        _permissionsJsonMeta,
        permissionsJson.isAcceptableOrUnknown(
          data['permissions_json']!,
          _permissionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('accepted_user_id')) {
      context.handle(
        _acceptedUserIdMeta,
        acceptedUserId.isAcceptableOrUnknown(
          data['accepted_user_id']!,
          _acceptedUserIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('responded_at')) {
      context.handle(
        _respondedAtMeta,
        respondedAt.isAcceptableOrUnknown(
          data['responded_at']!,
          _respondedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyInvite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyInvite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      invitedEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invited_email'],
      )!,
      invitedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invited_by_user_id'],
      )!,
      invitedByName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invited_by_name'],
      )!,
      invitedDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invited_display_name'],
      ),
      roleLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role_label'],
      ),
      permissionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions_json'],
      )!,
      acceptedUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accepted_user_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      respondedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}responded_at'],
      ),
    );
  }

  @override
  $FamilyInvitesTable createAlias(String alias) {
    return $FamilyInvitesTable(attachedDatabase, alias);
  }
}

class FamilyInvite extends DataClass implements Insertable<FamilyInvite> {
  final String id;
  final String familyId;
  final String invitedEmail;
  final String invitedByUserId;
  final String invitedByName;
  final String? invitedDisplayName;
  final String? roleLabel;
  final String permissionsJson;
  final String? acceptedUserId;
  final String status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  const FamilyInvite({
    required this.id,
    required this.familyId,
    required this.invitedEmail,
    required this.invitedByUserId,
    required this.invitedByName,
    this.invitedDisplayName,
    this.roleLabel,
    required this.permissionsJson,
    this.acceptedUserId,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['invited_email'] = Variable<String>(invitedEmail);
    map['invited_by_user_id'] = Variable<String>(invitedByUserId);
    map['invited_by_name'] = Variable<String>(invitedByName);
    if (!nullToAbsent || invitedDisplayName != null) {
      map['invited_display_name'] = Variable<String>(invitedDisplayName);
    }
    if (!nullToAbsent || roleLabel != null) {
      map['role_label'] = Variable<String>(roleLabel);
    }
    map['permissions_json'] = Variable<String>(permissionsJson);
    if (!nullToAbsent || acceptedUserId != null) {
      map['accepted_user_id'] = Variable<String>(acceptedUserId);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    return map;
  }

  FamilyInvitesCompanion toCompanion(bool nullToAbsent) {
    return FamilyInvitesCompanion(
      id: Value(id),
      familyId: Value(familyId),
      invitedEmail: Value(invitedEmail),
      invitedByUserId: Value(invitedByUserId),
      invitedByName: Value(invitedByName),
      invitedDisplayName: invitedDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(invitedDisplayName),
      roleLabel: roleLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(roleLabel),
      permissionsJson: Value(permissionsJson),
      acceptedUserId: acceptedUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(acceptedUserId),
      status: Value(status),
      createdAt: Value(createdAt),
      respondedAt: respondedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(respondedAt),
    );
  }

  factory FamilyInvite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyInvite(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      invitedEmail: serializer.fromJson<String>(json['invitedEmail']),
      invitedByUserId: serializer.fromJson<String>(json['invitedByUserId']),
      invitedByName: serializer.fromJson<String>(json['invitedByName']),
      invitedDisplayName: serializer.fromJson<String?>(
        json['invitedDisplayName'],
      ),
      roleLabel: serializer.fromJson<String?>(json['roleLabel']),
      permissionsJson: serializer.fromJson<String>(json['permissionsJson']),
      acceptedUserId: serializer.fromJson<String?>(json['acceptedUserId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'invitedEmail': serializer.toJson<String>(invitedEmail),
      'invitedByUserId': serializer.toJson<String>(invitedByUserId),
      'invitedByName': serializer.toJson<String>(invitedByName),
      'invitedDisplayName': serializer.toJson<String?>(invitedDisplayName),
      'roleLabel': serializer.toJson<String?>(roleLabel),
      'permissionsJson': serializer.toJson<String>(permissionsJson),
      'acceptedUserId': serializer.toJson<String?>(acceptedUserId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
    };
  }

  FamilyInvite copyWith({
    String? id,
    String? familyId,
    String? invitedEmail,
    String? invitedByUserId,
    String? invitedByName,
    Value<String?> invitedDisplayName = const Value.absent(),
    Value<String?> roleLabel = const Value.absent(),
    String? permissionsJson,
    Value<String?> acceptedUserId = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<DateTime?> respondedAt = const Value.absent(),
  }) => FamilyInvite(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    invitedEmail: invitedEmail ?? this.invitedEmail,
    invitedByUserId: invitedByUserId ?? this.invitedByUserId,
    invitedByName: invitedByName ?? this.invitedByName,
    invitedDisplayName: invitedDisplayName.present
        ? invitedDisplayName.value
        : this.invitedDisplayName,
    roleLabel: roleLabel.present ? roleLabel.value : this.roleLabel,
    permissionsJson: permissionsJson ?? this.permissionsJson,
    acceptedUserId: acceptedUserId.present
        ? acceptedUserId.value
        : this.acceptedUserId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
  );
  FamilyInvite copyWithCompanion(FamilyInvitesCompanion data) {
    return FamilyInvite(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      invitedEmail: data.invitedEmail.present
          ? data.invitedEmail.value
          : this.invitedEmail,
      invitedByUserId: data.invitedByUserId.present
          ? data.invitedByUserId.value
          : this.invitedByUserId,
      invitedByName: data.invitedByName.present
          ? data.invitedByName.value
          : this.invitedByName,
      invitedDisplayName: data.invitedDisplayName.present
          ? data.invitedDisplayName.value
          : this.invitedDisplayName,
      roleLabel: data.roleLabel.present ? data.roleLabel.value : this.roleLabel,
      permissionsJson: data.permissionsJson.present
          ? data.permissionsJson.value
          : this.permissionsJson,
      acceptedUserId: data.acceptedUserId.present
          ? data.acceptedUserId.value
          : this.acceptedUserId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      respondedAt: data.respondedAt.present
          ? data.respondedAt.value
          : this.respondedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyInvite(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('invitedEmail: $invitedEmail, ')
          ..write('invitedByUserId: $invitedByUserId, ')
          ..write('invitedByName: $invitedByName, ')
          ..write('invitedDisplayName: $invitedDisplayName, ')
          ..write('roleLabel: $roleLabel, ')
          ..write('permissionsJson: $permissionsJson, ')
          ..write('acceptedUserId: $acceptedUserId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('respondedAt: $respondedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    invitedEmail,
    invitedByUserId,
    invitedByName,
    invitedDisplayName,
    roleLabel,
    permissionsJson,
    acceptedUserId,
    status,
    createdAt,
    respondedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyInvite &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.invitedEmail == this.invitedEmail &&
          other.invitedByUserId == this.invitedByUserId &&
          other.invitedByName == this.invitedByName &&
          other.invitedDisplayName == this.invitedDisplayName &&
          other.roleLabel == this.roleLabel &&
          other.permissionsJson == this.permissionsJson &&
          other.acceptedUserId == this.acceptedUserId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.respondedAt == this.respondedAt);
}

class FamilyInvitesCompanion extends UpdateCompanion<FamilyInvite> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> invitedEmail;
  final Value<String> invitedByUserId;
  final Value<String> invitedByName;
  final Value<String?> invitedDisplayName;
  final Value<String?> roleLabel;
  final Value<String> permissionsJson;
  final Value<String?> acceptedUserId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> respondedAt;
  final Value<int> rowid;
  const FamilyInvitesCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.invitedEmail = const Value.absent(),
    this.invitedByUserId = const Value.absent(),
    this.invitedByName = const Value.absent(),
    this.invitedDisplayName = const Value.absent(),
    this.roleLabel = const Value.absent(),
    this.permissionsJson = const Value.absent(),
    this.acceptedUserId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyInvitesCompanion.insert({
    required String id,
    required String familyId,
    required String invitedEmail,
    required String invitedByUserId,
    required String invitedByName,
    this.invitedDisplayName = const Value.absent(),
    this.roleLabel = const Value.absent(),
    this.permissionsJson = const Value.absent(),
    this.acceptedUserId = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.respondedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       invitedEmail = Value(invitedEmail),
       invitedByUserId = Value(invitedByUserId),
       invitedByName = Value(invitedByName),
       createdAt = Value(createdAt);
  static Insertable<FamilyInvite> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? invitedEmail,
    Expression<String>? invitedByUserId,
    Expression<String>? invitedByName,
    Expression<String>? invitedDisplayName,
    Expression<String>? roleLabel,
    Expression<String>? permissionsJson,
    Expression<String>? acceptedUserId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? respondedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (invitedEmail != null) 'invited_email': invitedEmail,
      if (invitedByUserId != null) 'invited_by_user_id': invitedByUserId,
      if (invitedByName != null) 'invited_by_name': invitedByName,
      if (invitedDisplayName != null)
        'invited_display_name': invitedDisplayName,
      if (roleLabel != null) 'role_label': roleLabel,
      if (permissionsJson != null) 'permissions_json': permissionsJson,
      if (acceptedUserId != null) 'accepted_user_id': acceptedUserId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (respondedAt != null) 'responded_at': respondedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyInvitesCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String>? invitedEmail,
    Value<String>? invitedByUserId,
    Value<String>? invitedByName,
    Value<String?>? invitedDisplayName,
    Value<String?>? roleLabel,
    Value<String>? permissionsJson,
    Value<String?>? acceptedUserId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? respondedAt,
    Value<int>? rowid,
  }) {
    return FamilyInvitesCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      invitedEmail: invitedEmail ?? this.invitedEmail,
      invitedByUserId: invitedByUserId ?? this.invitedByUserId,
      invitedByName: invitedByName ?? this.invitedByName,
      invitedDisplayName: invitedDisplayName ?? this.invitedDisplayName,
      roleLabel: roleLabel ?? this.roleLabel,
      permissionsJson: permissionsJson ?? this.permissionsJson,
      acceptedUserId: acceptedUserId ?? this.acceptedUserId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (invitedEmail.present) {
      map['invited_email'] = Variable<String>(invitedEmail.value);
    }
    if (invitedByUserId.present) {
      map['invited_by_user_id'] = Variable<String>(invitedByUserId.value);
    }
    if (invitedByName.present) {
      map['invited_by_name'] = Variable<String>(invitedByName.value);
    }
    if (invitedDisplayName.present) {
      map['invited_display_name'] = Variable<String>(invitedDisplayName.value);
    }
    if (roleLabel.present) {
      map['role_label'] = Variable<String>(roleLabel.value);
    }
    if (permissionsJson.present) {
      map['permissions_json'] = Variable<String>(permissionsJson.value);
    }
    if (acceptedUserId.present) {
      map['accepted_user_id'] = Variable<String>(acceptedUserId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyInvitesCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('invitedEmail: $invitedEmail, ')
          ..write('invitedByUserId: $invitedByUserId, ')
          ..write('invitedByName: $invitedByName, ')
          ..write('invitedDisplayName: $invitedDisplayName, ')
          ..write('roleLabel: $roleLabel, ')
          ..write('permissionsJson: $permissionsJson, ')
          ..write('acceptedUserId: $acceptedUserId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaccineEventsTable extends VaccineEvents
    with TableInfo<$VaccineEventsTable, VaccineEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccineEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<String> babyId = GeneratedColumn<String>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('upcoming'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    babyId,
    title,
    dose,
    dueDate,
    status,
    notes,
    completedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccine_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaccineEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccineEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccineEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baby_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VaccineEventsTable createAlias(String alias) {
    return $VaccineEventsTable(attachedDatabase, alias);
  }
}

class VaccineEvent extends DataClass implements Insertable<VaccineEvent> {
  final String id;
  final String babyId;
  final String title;
  final String dose;
  final DateTime dueDate;
  final String status;
  final String? notes;
  final DateTime? completedAt;
  final DateTime createdAt;
  const VaccineEvent({
    required this.id,
    required this.babyId,
    required this.title,
    required this.dose,
    required this.dueDate,
    required this.status,
    this.notes,
    this.completedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['baby_id'] = Variable<String>(babyId);
    map['title'] = Variable<String>(title);
    map['dose'] = Variable<String>(dose);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VaccineEventsCompanion toCompanion(bool nullToAbsent) {
    return VaccineEventsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      title: Value(title),
      dose: Value(dose),
      dueDate: Value(dueDate),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
    );
  }

  factory VaccineEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccineEvent(
      id: serializer.fromJson<String>(json['id']),
      babyId: serializer.fromJson<String>(json['babyId']),
      title: serializer.fromJson<String>(json['title']),
      dose: serializer.fromJson<String>(json['dose']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'babyId': serializer.toJson<String>(babyId),
      'title': serializer.toJson<String>(title),
      'dose': serializer.toJson<String>(dose),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VaccineEvent copyWith({
    String? id,
    String? babyId,
    String? title,
    String? dose,
    DateTime? dueDate,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
  }) => VaccineEvent(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    title: title ?? this.title,
    dose: dose ?? this.dose,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  VaccineEvent copyWithCompanion(VaccineEventsCompanion data) {
    return VaccineEvent(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      title: data.title.present ? data.title.value : this.title,
      dose: data.dose.present ? data.dose.value : this.dose,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccineEvent(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('title: $title, ')
          ..write('dose: $dose, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    babyId,
    title,
    dose,
    dueDate,
    status,
    notes,
    completedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccineEvent &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.title == this.title &&
          other.dose == this.dose &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt);
}

class VaccineEventsCompanion extends UpdateCompanion<VaccineEvent> {
  final Value<String> id;
  final Value<String> babyId;
  final Value<String> title;
  final Value<String> dose;
  final Value<DateTime> dueDate;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VaccineEventsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.title = const Value.absent(),
    this.dose = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaccineEventsCompanion.insert({
    required String id,
    required String babyId,
    required String title,
    required String dose,
    required DateTime dueDate,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       babyId = Value(babyId),
       title = Value(title),
       dose = Value(dose),
       dueDate = Value(dueDate),
       createdAt = Value(createdAt);
  static Insertable<VaccineEvent> custom({
    Expression<String>? id,
    Expression<String>? babyId,
    Expression<String>? title,
    Expression<String>? dose,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (title != null) 'title': title,
      if (dose != null) 'dose': dose,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaccineEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? babyId,
    Value<String>? title,
    Value<String>? dose,
    Value<DateTime>? dueDate,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VaccineEventsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      title: title ?? this.title,
      dose: dose ?? this.dose,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<String>(babyId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccineEventsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('title: $title, ')
          ..write('dose: $dose, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTable extends Articles with TableInfo<$ArticlesTable, Article> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _careModeMeta = const VerificationMeta(
    'careMode',
  );
  @override
  late final GeneratedColumn<String> careMode = GeneratedColumn<String>(
    'care_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('baby'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingMinutesMeta = const VerificationMeta(
    'readingMinutes',
  );
  @override
  late final GeneratedColumn<int> readingMinutes = GeneratedColumn<int>(
    'reading_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicalDisclaimerMeta = const VerificationMeta(
    'medicalDisclaimer',
  );
  @override
  late final GeneratedColumn<String> medicalDisclaimer =
      GeneratedColumn<String>(
        'medical_disclaimer',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    careMode,
    title,
    category,
    summary,
    content,
    readingMinutes,
    sourceName,
    sourceUrl,
    medicalDisclaimer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Article> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('care_mode')) {
      context.handle(
        _careModeMeta,
        careMode.isAcceptableOrUnknown(data['care_mode']!, _careModeMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('reading_minutes')) {
      context.handle(
        _readingMinutesMeta,
        readingMinutes.isAcceptableOrUnknown(
          data['reading_minutes']!,
          _readingMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readingMinutesMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('medical_disclaimer')) {
      context.handle(
        _medicalDisclaimerMeta,
        medicalDisclaimer.isAcceptableOrUnknown(
          data['medical_disclaimer']!,
          _medicalDisclaimerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalDisclaimerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Article map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Article(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      careMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}care_mode'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      readingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reading_minutes'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      medicalDisclaimer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_disclaimer'],
      )!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }
}

class Article extends DataClass implements Insertable<Article> {
  final String id;
  final String careMode;
  final String title;
  final String category;
  final String summary;
  final String content;
  final int readingMinutes;
  final String sourceName;
  final String sourceUrl;
  final String medicalDisclaimer;
  const Article({
    required this.id,
    required this.careMode,
    required this.title,
    required this.category,
    required this.summary,
    required this.content,
    required this.readingMinutes,
    required this.sourceName,
    required this.sourceUrl,
    required this.medicalDisclaimer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['care_mode'] = Variable<String>(careMode);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['summary'] = Variable<String>(summary);
    map['content'] = Variable<String>(content);
    map['reading_minutes'] = Variable<int>(readingMinutes);
    map['source_name'] = Variable<String>(sourceName);
    map['source_url'] = Variable<String>(sourceUrl);
    map['medical_disclaimer'] = Variable<String>(medicalDisclaimer);
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      id: Value(id),
      careMode: Value(careMode),
      title: Value(title),
      category: Value(category),
      summary: Value(summary),
      content: Value(content),
      readingMinutes: Value(readingMinutes),
      sourceName: Value(sourceName),
      sourceUrl: Value(sourceUrl),
      medicalDisclaimer: Value(medicalDisclaimer),
    );
  }

  factory Article.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Article(
      id: serializer.fromJson<String>(json['id']),
      careMode: serializer.fromJson<String>(json['careMode']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      summary: serializer.fromJson<String>(json['summary']),
      content: serializer.fromJson<String>(json['content']),
      readingMinutes: serializer.fromJson<int>(json['readingMinutes']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      medicalDisclaimer: serializer.fromJson<String>(json['medicalDisclaimer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'careMode': serializer.toJson<String>(careMode),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'summary': serializer.toJson<String>(summary),
      'content': serializer.toJson<String>(content),
      'readingMinutes': serializer.toJson<int>(readingMinutes),
      'sourceName': serializer.toJson<String>(sourceName),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'medicalDisclaimer': serializer.toJson<String>(medicalDisclaimer),
    };
  }

  Article copyWith({
    String? id,
    String? careMode,
    String? title,
    String? category,
    String? summary,
    String? content,
    int? readingMinutes,
    String? sourceName,
    String? sourceUrl,
    String? medicalDisclaimer,
  }) => Article(
    id: id ?? this.id,
    careMode: careMode ?? this.careMode,
    title: title ?? this.title,
    category: category ?? this.category,
    summary: summary ?? this.summary,
    content: content ?? this.content,
    readingMinutes: readingMinutes ?? this.readingMinutes,
    sourceName: sourceName ?? this.sourceName,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    medicalDisclaimer: medicalDisclaimer ?? this.medicalDisclaimer,
  );
  Article copyWithCompanion(ArticlesCompanion data) {
    return Article(
      id: data.id.present ? data.id.value : this.id,
      careMode: data.careMode.present ? data.careMode.value : this.careMode,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      readingMinutes: data.readingMinutes.present
          ? data.readingMinutes.value
          : this.readingMinutes,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      medicalDisclaimer: data.medicalDisclaimer.present
          ? data.medicalDisclaimer.value
          : this.medicalDisclaimer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('id: $id, ')
          ..write('careMode: $careMode, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('readingMinutes: $readingMinutes, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('medicalDisclaimer: $medicalDisclaimer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    careMode,
    title,
    category,
    summary,
    content,
    readingMinutes,
    sourceName,
    sourceUrl,
    medicalDisclaimer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Article &&
          other.id == this.id &&
          other.careMode == this.careMode &&
          other.title == this.title &&
          other.category == this.category &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.readingMinutes == this.readingMinutes &&
          other.sourceName == this.sourceName &&
          other.sourceUrl == this.sourceUrl &&
          other.medicalDisclaimer == this.medicalDisclaimer);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<String> id;
  final Value<String> careMode;
  final Value<String> title;
  final Value<String> category;
  final Value<String> summary;
  final Value<String> content;
  final Value<int> readingMinutes;
  final Value<String> sourceName;
  final Value<String> sourceUrl;
  final Value<String> medicalDisclaimer;
  final Value<int> rowid;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.careMode = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.readingMinutes = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.medicalDisclaimer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArticlesCompanion.insert({
    required String id,
    this.careMode = const Value.absent(),
    required String title,
    required String category,
    required String summary,
    required String content,
    required int readingMinutes,
    required String sourceName,
    required String sourceUrl,
    required String medicalDisclaimer,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       summary = Value(summary),
       content = Value(content),
       readingMinutes = Value(readingMinutes),
       sourceName = Value(sourceName),
       sourceUrl = Value(sourceUrl),
       medicalDisclaimer = Value(medicalDisclaimer);
  static Insertable<Article> custom({
    Expression<String>? id,
    Expression<String>? careMode,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<int>? readingMinutes,
    Expression<String>? sourceName,
    Expression<String>? sourceUrl,
    Expression<String>? medicalDisclaimer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (careMode != null) 'care_mode': careMode,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (readingMinutes != null) 'reading_minutes': readingMinutes,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (medicalDisclaimer != null) 'medical_disclaimer': medicalDisclaimer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArticlesCompanion copyWith({
    Value<String>? id,
    Value<String>? careMode,
    Value<String>? title,
    Value<String>? category,
    Value<String>? summary,
    Value<String>? content,
    Value<int>? readingMinutes,
    Value<String>? sourceName,
    Value<String>? sourceUrl,
    Value<String>? medicalDisclaimer,
    Value<int>? rowid,
  }) {
    return ArticlesCompanion(
      id: id ?? this.id,
      careMode: careMode ?? this.careMode,
      title: title ?? this.title,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      readingMinutes: readingMinutes ?? this.readingMinutes,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      medicalDisclaimer: medicalDisclaimer ?? this.medicalDisclaimer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (careMode.present) {
      map['care_mode'] = Variable<String>(careMode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (readingMinutes.present) {
      map['reading_minutes'] = Variable<int>(readingMinutes.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (medicalDisclaimer.present) {
      map['medical_disclaimer'] = Variable<String>(medicalDisclaimer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('careMode: $careMode, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('readingMinutes: $readingMinutes, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('medicalDisclaimer: $medicalDisclaimer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedArticlesTable extends SavedArticles
    with TableInfo<$SavedArticlesTable, SavedArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<String> articleId = GeneratedColumn<String>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [articleId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedArticle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {articleId};
  @override
  SavedArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedArticle(
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article_id'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedArticlesTable createAlias(String alias) {
    return $SavedArticlesTable(attachedDatabase, alias);
  }
}

class SavedArticle extends DataClass implements Insertable<SavedArticle> {
  final String articleId;
  final DateTime savedAt;
  const SavedArticle({required this.articleId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['article_id'] = Variable<String>(articleId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedArticlesCompanion toCompanion(bool nullToAbsent) {
    return SavedArticlesCompanion(
      articleId: Value(articleId),
      savedAt: Value(savedAt),
    );
  }

  factory SavedArticle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedArticle(
      articleId: serializer.fromJson<String>(json['articleId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'articleId': serializer.toJson<String>(articleId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedArticle copyWith({String? articleId, DateTime? savedAt}) => SavedArticle(
    articleId: articleId ?? this.articleId,
    savedAt: savedAt ?? this.savedAt,
  );
  SavedArticle copyWithCompanion(SavedArticlesCompanion data) {
    return SavedArticle(
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedArticle(')
          ..write('articleId: $articleId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(articleId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedArticle &&
          other.articleId == this.articleId &&
          other.savedAt == this.savedAt);
}

class SavedArticlesCompanion extends UpdateCompanion<SavedArticle> {
  final Value<String> articleId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const SavedArticlesCompanion({
    this.articleId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedArticlesCompanion.insert({
    required String articleId,
    required DateTime savedAt,
    this.rowid = const Value.absent(),
  }) : articleId = Value(articleId),
       savedAt = Value(savedAt);
  static Insertable<SavedArticle> custom({
    Expression<String>? articleId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (articleId != null) 'article_id': articleId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedArticlesCompanion copyWith({
    Value<String>? articleId,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return SavedArticlesCompanion(
      articleId: articleId ?? this.articleId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (articleId.present) {
      map['article_id'] = Variable<String>(articleId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedArticlesCompanion(')
          ..write('articleId: $articleId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityKindMeta = const VerificationMeta(
    'entityKind',
  );
  @override
  late final GeneratedColumn<String> entityKind = GeneratedColumn<String>(
    'entity_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityKind,
    entityId,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_kind')) {
      context.handle(
        _entityKindMeta,
        entityKind.isAcceptableOrUnknown(data['entity_kind']!, _entityKindMeta),
      );
    } else if (isInserting) {
      context.missing(_entityKindMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_kind'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final String id;
  final String entityKind;
  final String entityId;
  final String status;
  final DateTime createdAt;
  const SyncQueueItem({
    required this.id,
    required this.entityKind,
    required this.entityId,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_kind'] = Variable<String>(entityKind);
    map['entity_id'] = Variable<String>(entityId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      entityKind: Value(entityKind),
      entityId: Value(entityId),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<String>(json['id']),
      entityKind: serializer.fromJson<String>(json['entityKind']),
      entityId: serializer.fromJson<String>(json['entityId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityKind': serializer.toJson<String>(entityKind),
      'entityId': serializer.toJson<String>(entityId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueItem copyWith({
    String? id,
    String? entityKind,
    String? entityId,
    String? status,
    DateTime? createdAt,
  }) => SyncQueueItem(
    id: id ?? this.id,
    entityKind: entityKind ?? this.entityKind,
    entityId: entityId ?? this.entityId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      entityKind: data.entityKind.present
          ? data.entityKind.value
          : this.entityKind,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('entityKind: $entityKind, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityKind, entityId, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.entityKind == this.entityKind &&
          other.entityId == this.entityId &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<String> id;
  final Value<String> entityKind;
  final Value<String> entityId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.entityKind = const Value.absent(),
    this.entityId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    required String id,
    required String entityKind,
    required String entityId,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityKind = Value(entityKind),
       entityId = Value(entityId),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueItem> custom({
    Expression<String>? id,
    Expression<String>? entityKind,
    Expression<String>? entityId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityKind != null) 'entity_kind': entityKind,
      if (entityId != null) 'entity_id': entityId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityKind,
    Value<String>? entityId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      entityKind: entityKind ?? this.entityKind,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityKind.present) {
      map['entity_kind'] = Variable<String>(entityKind.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityKind: $entityKind, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SettingsRowsTable settingsRows = $SettingsRowsTable(this);
  late final $FamiliesTable families = $FamiliesTable(this);
  late final $BabiesTable babies = $BabiesTable(this);
  late final $PregnanciesTable pregnancies = $PregnanciesTable(this);
  late final $TrackerRecordsTable trackerRecords = $TrackerRecordsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $AppNotificationsTable appNotifications = $AppNotificationsTable(
    this,
  );
  late final $FamilyInvitesTable familyInvites = $FamilyInvitesTable(this);
  late final $VaccineEventsTable vaccineEvents = $VaccineEventsTable(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final $SavedArticlesTable savedArticles = $SavedArticlesTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    settingsRows,
    families,
    babies,
    pregnancies,
    trackerRecords,
    reminders,
    appNotifications,
    familyInvites,
    vaccineEvents,
    articles,
    savedArticles,
    syncQueueItems,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String name,
      required String email,
      Value<bool> emailVerified,
      Value<String?> avatarUrl,
      Value<DateTime?> birthDate,
      Value<String?> phone,
      Value<String?> role,
      Value<String> language,
      Value<String> theme,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<bool> emailVerified,
      Value<String?> avatarUrl,
      Value<DateTime?> birthDate,
      Value<String?> phone,
      Value<String?> role,
      Value<String> language,
      Value<String> theme,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                emailVerified: emailVerified,
                avatarUrl: avatarUrl,
                birthDate: birthDate,
                phone: phone,
                role: role,
                language: language,
                theme: theme,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                Value<bool> emailVerified = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> theme = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                emailVerified: emailVerified,
                avatarUrl: avatarUrl,
                birthDate: birthDate,
                phone: phone,
                role: role,
                language: language,
                theme: theme,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$SettingsRowsTableCreateCompanionBuilder =
    SettingsRowsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsRowsTableUpdateCompanionBuilder =
    SettingsRowsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsRowsTable> {
  $$SettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsRowsTable> {
  $$SettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsRowsTable> {
  $$SettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsRowsTable,
          SettingsRow,
          $$SettingsRowsTableFilterComposer,
          $$SettingsRowsTableOrderingComposer,
          $$SettingsRowsTableAnnotationComposer,
          $$SettingsRowsTableCreateCompanionBuilder,
          $$SettingsRowsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsRowsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsRowsTableTableManager(_$AppDatabase db, $SettingsRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsRowsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsRowsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsRowsTable,
      SettingsRow,
      $$SettingsRowsTableFilterComposer,
      $$SettingsRowsTableOrderingComposer,
      $$SettingsRowsTableAnnotationComposer,
      $$SettingsRowsTableCreateCompanionBuilder,
      $$SettingsRowsTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $SettingsRowsTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$FamiliesTableCreateCompanionBuilder =
    FamiliesCompanion Function({
      required String id,
      required String ownerUserId,
      Value<String> partnerUserIds,
      Value<String?> activeBabyId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$FamiliesTableUpdateCompanionBuilder =
    FamiliesCompanion Function({
      Value<String> id,
      Value<String> ownerUserId,
      Value<String> partnerUserIds,
      Value<String?> activeBabyId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$FamiliesTableFilterComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partnerUserIds => $composableBuilder(
    column: $table.partnerUserIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeBabyId => $composableBuilder(
    column: $table.activeBabyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamiliesTableOrderingComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partnerUserIds => $composableBuilder(
    column: $table.partnerUserIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeBabyId => $composableBuilder(
    column: $table.activeBabyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamiliesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partnerUserIds => $composableBuilder(
    column: $table.partnerUserIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeBabyId => $composableBuilder(
    column: $table.activeBabyId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FamiliesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamiliesTable,
          Family,
          $$FamiliesTableFilterComposer,
          $$FamiliesTableOrderingComposer,
          $$FamiliesTableAnnotationComposer,
          $$FamiliesTableCreateCompanionBuilder,
          $$FamiliesTableUpdateCompanionBuilder,
          (Family, BaseReferences<_$AppDatabase, $FamiliesTable, Family>),
          Family,
          PrefetchHooks Function()
        > {
  $$FamiliesTableTableManager(_$AppDatabase db, $FamiliesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamiliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamiliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamiliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<String> partnerUserIds = const Value.absent(),
                Value<String?> activeBabyId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamiliesCompanion(
                id: id,
                ownerUserId: ownerUserId,
                partnerUserIds: partnerUserIds,
                activeBabyId: activeBabyId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUserId,
                Value<String> partnerUserIds = const Value.absent(),
                Value<String?> activeBabyId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FamiliesCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                partnerUserIds: partnerUserIds,
                activeBabyId: activeBabyId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamiliesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamiliesTable,
      Family,
      $$FamiliesTableFilterComposer,
      $$FamiliesTableOrderingComposer,
      $$FamiliesTableAnnotationComposer,
      $$FamiliesTableCreateCompanionBuilder,
      $$FamiliesTableUpdateCompanionBuilder,
      (Family, BaseReferences<_$AppDatabase, $FamiliesTable, Family>),
      Family,
      PrefetchHooks Function()
    >;
typedef $$BabiesTableCreateCompanionBuilder =
    BabiesCompanion Function({
      required String id,
      required String familyId,
      required String name,
      required DateTime birthDate,
      Value<String?> gender,
      Value<double?> birthWeight,
      Value<double?> birthHeight,
      Value<double?> birthHeadCircumference,
      Value<double?> currentWeight,
      Value<double?> currentHeight,
      Value<double?> currentHeadCircumference,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BabiesTableUpdateCompanionBuilder =
    BabiesCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String> name,
      Value<DateTime> birthDate,
      Value<String?> gender,
      Value<double?> birthWeight,
      Value<double?> birthHeight,
      Value<double?> birthHeadCircumference,
      Value<double?> currentWeight,
      Value<double?> currentHeight,
      Value<double?> currentHeadCircumference,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BabiesTableFilterComposer
    extends Composer<_$AppDatabase, $BabiesTable> {
  $$BabiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthWeight => $composableBuilder(
    column: $table.birthWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthHeight => $composableBuilder(
    column: $table.birthHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthHeadCircumference => $composableBuilder(
    column: $table.birthHeadCircumference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentWeight => $composableBuilder(
    column: $table.currentWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentHeight => $composableBuilder(
    column: $table.currentHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentHeadCircumference => $composableBuilder(
    column: $table.currentHeadCircumference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BabiesTableOrderingComposer
    extends Composer<_$AppDatabase, $BabiesTable> {
  $$BabiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthWeight => $composableBuilder(
    column: $table.birthWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthHeight => $composableBuilder(
    column: $table.birthHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthHeadCircumference => $composableBuilder(
    column: $table.birthHeadCircumference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeight => $composableBuilder(
    column: $table.currentWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentHeight => $composableBuilder(
    column: $table.currentHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentHeadCircumference => $composableBuilder(
    column: $table.currentHeadCircumference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BabiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BabiesTable> {
  $$BabiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get birthWeight => $composableBuilder(
    column: $table.birthWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthHeight => $composableBuilder(
    column: $table.birthHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthHeadCircumference => $composableBuilder(
    column: $table.birthHeadCircumference,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentWeight => $composableBuilder(
    column: $table.currentWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentHeight => $composableBuilder(
    column: $table.currentHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentHeadCircumference => $composableBuilder(
    column: $table.currentHeadCircumference,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BabiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BabiesTable,
          Baby,
          $$BabiesTableFilterComposer,
          $$BabiesTableOrderingComposer,
          $$BabiesTableAnnotationComposer,
          $$BabiesTableCreateCompanionBuilder,
          $$BabiesTableUpdateCompanionBuilder,
          (Baby, BaseReferences<_$AppDatabase, $BabiesTable, Baby>),
          Baby,
          PrefetchHooks Function()
        > {
  $$BabiesTableTableManager(_$AppDatabase db, $BabiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BabiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BabiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BabiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<double?> birthWeight = const Value.absent(),
                Value<double?> birthHeight = const Value.absent(),
                Value<double?> birthHeadCircumference = const Value.absent(),
                Value<double?> currentWeight = const Value.absent(),
                Value<double?> currentHeight = const Value.absent(),
                Value<double?> currentHeadCircumference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BabiesCompanion(
                id: id,
                familyId: familyId,
                name: name,
                birthDate: birthDate,
                gender: gender,
                birthWeight: birthWeight,
                birthHeight: birthHeight,
                birthHeadCircumference: birthHeadCircumference,
                currentWeight: currentWeight,
                currentHeight: currentHeight,
                currentHeadCircumference: currentHeadCircumference,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                required String name,
                required DateTime birthDate,
                Value<String?> gender = const Value.absent(),
                Value<double?> birthWeight = const Value.absent(),
                Value<double?> birthHeight = const Value.absent(),
                Value<double?> birthHeadCircumference = const Value.absent(),
                Value<double?> currentWeight = const Value.absent(),
                Value<double?> currentHeight = const Value.absent(),
                Value<double?> currentHeadCircumference = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BabiesCompanion.insert(
                id: id,
                familyId: familyId,
                name: name,
                birthDate: birthDate,
                gender: gender,
                birthWeight: birthWeight,
                birthHeight: birthHeight,
                birthHeadCircumference: birthHeadCircumference,
                currentWeight: currentWeight,
                currentHeight: currentHeight,
                currentHeadCircumference: currentHeadCircumference,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BabiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BabiesTable,
      Baby,
      $$BabiesTableFilterComposer,
      $$BabiesTableOrderingComposer,
      $$BabiesTableAnnotationComposer,
      $$BabiesTableCreateCompanionBuilder,
      $$BabiesTableUpdateCompanionBuilder,
      (Baby, BaseReferences<_$AppDatabase, $BabiesTable, Baby>),
      Baby,
      PrefetchHooks Function()
    >;
typedef $$PregnanciesTableCreateCompanionBuilder =
    PregnanciesCompanion Function({
      required String id,
      required String userId,
      required DateTime startDate,
      required DateTime dueDate,
      required String status,
      Value<DateTime?> birthCompletedAt,
      Value<int> rowid,
    });
typedef $$PregnanciesTableUpdateCompanionBuilder =
    PregnanciesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> startDate,
      Value<DateTime> dueDate,
      Value<String> status,
      Value<DateTime?> birthCompletedAt,
      Value<int> rowid,
    });

class $$PregnanciesTableFilterComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthCompletedAt => $composableBuilder(
    column: $table.birthCompletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PregnanciesTableOrderingComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthCompletedAt => $composableBuilder(
    column: $table.birthCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PregnanciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get birthCompletedAt => $composableBuilder(
    column: $table.birthCompletedAt,
    builder: (column) => column,
  );
}

class $$PregnanciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PregnanciesTable,
          Pregnancy,
          $$PregnanciesTableFilterComposer,
          $$PregnanciesTableOrderingComposer,
          $$PregnanciesTableAnnotationComposer,
          $$PregnanciesTableCreateCompanionBuilder,
          $$PregnanciesTableUpdateCompanionBuilder,
          (
            Pregnancy,
            BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>,
          ),
          Pregnancy,
          PrefetchHooks Function()
        > {
  $$PregnanciesTableTableManager(_$AppDatabase db, $PregnanciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PregnanciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PregnanciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PregnanciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> birthCompletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PregnanciesCompanion(
                id: id,
                userId: userId,
                startDate: startDate,
                dueDate: dueDate,
                status: status,
                birthCompletedAt: birthCompletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime startDate,
                required DateTime dueDate,
                required String status,
                Value<DateTime?> birthCompletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PregnanciesCompanion.insert(
                id: id,
                userId: userId,
                startDate: startDate,
                dueDate: dueDate,
                status: status,
                birthCompletedAt: birthCompletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PregnanciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PregnanciesTable,
      Pregnancy,
      $$PregnanciesTableFilterComposer,
      $$PregnanciesTableOrderingComposer,
      $$PregnanciesTableAnnotationComposer,
      $$PregnanciesTableCreateCompanionBuilder,
      $$PregnanciesTableUpdateCompanionBuilder,
      (Pregnancy, BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>),
      Pregnancy,
      PrefetchHooks Function()
    >;
typedef $$TrackerRecordsTableCreateCompanionBuilder =
    TrackerRecordsCompanion Function({
      required String id,
      required String type,
      required String title,
      Value<String?> familyId,
      Value<String?> babyId,
      Value<String?> value,
      Value<String?> note,
      Value<String?> createdByUserId,
      Value<String?> createdByName,
      Value<String?> updatedByUserId,
      Value<String?> updatedByName,
      required DateTime occurredAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TrackerRecordsTableUpdateCompanionBuilder =
    TrackerRecordsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<String?> familyId,
      Value<String?> babyId,
      Value<String?> value,
      Value<String?> note,
      Value<String?> createdByUserId,
      Value<String?> createdByName,
      Value<String?> updatedByUserId,
      Value<String?> updatedByName,
      Value<DateTime> occurredAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> syncStatus,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$TrackerRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackerRecordsTable> {
  $$TrackerRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByName => $composableBuilder(
    column: $table.createdByName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByUserId => $composableBuilder(
    column: $table.updatedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedByName => $composableBuilder(
    column: $table.updatedByName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackerRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackerRecordsTable> {
  $$TrackerRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByName => $composableBuilder(
    column: $table.createdByName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByUserId => $composableBuilder(
    column: $table.updatedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedByName => $composableBuilder(
    column: $table.updatedByName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackerRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackerRecordsTable> {
  $$TrackerRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdByName => $composableBuilder(
    column: $table.createdByName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByUserId => $composableBuilder(
    column: $table.updatedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedByName => $composableBuilder(
    column: $table.updatedByName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TrackerRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackerRecordsTable,
          TrackerRecord,
          $$TrackerRecordsTableFilterComposer,
          $$TrackerRecordsTableOrderingComposer,
          $$TrackerRecordsTableAnnotationComposer,
          $$TrackerRecordsTableCreateCompanionBuilder,
          $$TrackerRecordsTableUpdateCompanionBuilder,
          (
            TrackerRecord,
            BaseReferences<_$AppDatabase, $TrackerRecordsTable, TrackerRecord>,
          ),
          TrackerRecord,
          PrefetchHooks Function()
        > {
  $$TrackerRecordsTableTableManager(
    _$AppDatabase db,
    $TrackerRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackerRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackerRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackerRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> familyId = const Value.absent(),
                Value<String?> babyId = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> createdByUserId = const Value.absent(),
                Value<String?> createdByName = const Value.absent(),
                Value<String?> updatedByUserId = const Value.absent(),
                Value<String?> updatedByName = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerRecordsCompanion(
                id: id,
                type: type,
                title: title,
                familyId: familyId,
                babyId: babyId,
                value: value,
                note: note,
                createdByUserId: createdByUserId,
                createdByName: createdByName,
                updatedByUserId: updatedByUserId,
                updatedByName: updatedByName,
                occurredAt: occurredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                Value<String?> familyId = const Value.absent(),
                Value<String?> babyId = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> createdByUserId = const Value.absent(),
                Value<String?> createdByName = const Value.absent(),
                Value<String?> updatedByUserId = const Value.absent(),
                Value<String?> updatedByName = const Value.absent(),
                required DateTime occurredAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackerRecordsCompanion.insert(
                id: id,
                type: type,
                title: title,
                familyId: familyId,
                babyId: babyId,
                value: value,
                note: note,
                createdByUserId: createdByUserId,
                createdByName: createdByName,
                updatedByUserId: updatedByUserId,
                updatedByName: updatedByName,
                occurredAt: occurredAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                syncStatus: syncStatus,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackerRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackerRecordsTable,
      TrackerRecord,
      $$TrackerRecordsTableFilterComposer,
      $$TrackerRecordsTableOrderingComposer,
      $$TrackerRecordsTableAnnotationComposer,
      $$TrackerRecordsTableCreateCompanionBuilder,
      $$TrackerRecordsTableUpdateCompanionBuilder,
      (
        TrackerRecord,
        BaseReferences<_$AppDatabase, $TrackerRecordsTable, TrackerRecord>,
      ),
      TrackerRecord,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String title,
      required String category,
      required DateTime time,
      Value<String> frequency,
      Value<String?> notes,
      Value<bool> isActive,
      Value<String?> ownerUserId,
      Value<String?> familyId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> category,
      Value<DateTime> time,
      Value<String> frequency,
      Value<String?> notes,
      Value<bool> isActive,
      Value<String?> ownerUserId,
      Value<String?> familyId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> ownerUserId = const Value.absent(),
                Value<String?> familyId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                title: title,
                category: category,
                time: time,
                frequency: frequency,
                notes: notes,
                isActive: isActive,
                ownerUserId: ownerUserId,
                familyId: familyId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String category,
                required DateTime time,
                Value<String> frequency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> ownerUserId = const Value.absent(),
                Value<String?> familyId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                title: title,
                category: category,
                time: time,
                frequency: frequency,
                notes: notes,
                isActive: isActive,
                ownerUserId: ownerUserId,
                familyId: familyId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$AppNotificationsTableCreateCompanionBuilder =
    AppNotificationsCompanion Function({
      required String id,
      Value<String?> familyId,
      Value<String> targetUserIds,
      Value<String?> createdBy,
      required String type,
      required String category,
      required String title,
      required String body,
      Value<String?> payload,
      Value<String> readBy,
      Value<String> seenBy,
      Value<bool> isDeleted,
      Value<String> status,
      Value<String?> userId,
      required DateTime createdAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });
typedef $$AppNotificationsTableUpdateCompanionBuilder =
    AppNotificationsCompanion Function({
      Value<String> id,
      Value<String?> familyId,
      Value<String> targetUserIds,
      Value<String?> createdBy,
      Value<String> type,
      Value<String> category,
      Value<String> title,
      Value<String> body,
      Value<String?> payload,
      Value<String> readBy,
      Value<String> seenBy,
      Value<bool> isDeleted,
      Value<String> status,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });

class $$AppNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetUserIds => $composableBuilder(
    column: $table.targetUserIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readBy => $composableBuilder(
    column: $table.readBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seenBy => $composableBuilder(
    column: $table.seenBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetUserIds => $composableBuilder(
    column: $table.targetUserIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readBy => $composableBuilder(
    column: $table.readBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seenBy => $composableBuilder(
    column: $table.seenBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get targetUserIds => $composableBuilder(
    column: $table.targetUserIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get readBy =>
      $composableBuilder(column: $table.readBy, builder: (column) => column);

  GeneratedColumn<String> get seenBy =>
      $composableBuilder(column: $table.seenBy, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$AppNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppNotificationsTable,
          AppNotification,
          $$AppNotificationsTableFilterComposer,
          $$AppNotificationsTableOrderingComposer,
          $$AppNotificationsTableAnnotationComposer,
          $$AppNotificationsTableCreateCompanionBuilder,
          $$AppNotificationsTableUpdateCompanionBuilder,
          (
            AppNotification,
            BaseReferences<
              _$AppDatabase,
              $AppNotificationsTable,
              AppNotification
            >,
          ),
          AppNotification,
          PrefetchHooks Function()
        > {
  $$AppNotificationsTableTableManager(
    _$AppDatabase db,
    $AppNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppNotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> familyId = const Value.absent(),
                Value<String> targetUserIds = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<String> readBy = const Value.absent(),
                Value<String> seenBy = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppNotificationsCompanion(
                id: id,
                familyId: familyId,
                targetUserIds: targetUserIds,
                createdBy: createdBy,
                type: type,
                category: category,
                title: title,
                body: body,
                payload: payload,
                readBy: readBy,
                seenBy: seenBy,
                isDeleted: isDeleted,
                status: status,
                userId: userId,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> familyId = const Value.absent(),
                Value<String> targetUserIds = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                required String type,
                required String category,
                required String title,
                required String body,
                Value<String?> payload = const Value.absent(),
                Value<String> readBy = const Value.absent(),
                Value<String> seenBy = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppNotificationsCompanion.insert(
                id: id,
                familyId: familyId,
                targetUserIds: targetUserIds,
                createdBy: createdBy,
                type: type,
                category: category,
                title: title,
                body: body,
                payload: payload,
                readBy: readBy,
                seenBy: seenBy,
                isDeleted: isDeleted,
                status: status,
                userId: userId,
                createdAt: createdAt,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppNotificationsTable,
      AppNotification,
      $$AppNotificationsTableFilterComposer,
      $$AppNotificationsTableOrderingComposer,
      $$AppNotificationsTableAnnotationComposer,
      $$AppNotificationsTableCreateCompanionBuilder,
      $$AppNotificationsTableUpdateCompanionBuilder,
      (
        AppNotification,
        BaseReferences<_$AppDatabase, $AppNotificationsTable, AppNotification>,
      ),
      AppNotification,
      PrefetchHooks Function()
    >;
typedef $$FamilyInvitesTableCreateCompanionBuilder =
    FamilyInvitesCompanion Function({
      required String id,
      required String familyId,
      required String invitedEmail,
      required String invitedByUserId,
      required String invitedByName,
      Value<String?> invitedDisplayName,
      Value<String?> roleLabel,
      Value<String> permissionsJson,
      Value<String?> acceptedUserId,
      Value<String> status,
      required DateTime createdAt,
      Value<DateTime?> respondedAt,
      Value<int> rowid,
    });
typedef $$FamilyInvitesTableUpdateCompanionBuilder =
    FamilyInvitesCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String> invitedEmail,
      Value<String> invitedByUserId,
      Value<String> invitedByName,
      Value<String?> invitedDisplayName,
      Value<String?> roleLabel,
      Value<String> permissionsJson,
      Value<String?> acceptedUserId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> respondedAt,
      Value<int> rowid,
    });

class $$FamilyInvitesTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyInvitesTable> {
  $$FamilyInvitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invitedEmail => $composableBuilder(
    column: $table.invitedEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invitedByUserId => $composableBuilder(
    column: $table.invitedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invitedByName => $composableBuilder(
    column: $table.invitedByName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invitedDisplayName => $composableBuilder(
    column: $table.invitedDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roleLabel => $composableBuilder(
    column: $table.roleLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissionsJson => $composableBuilder(
    column: $table.permissionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get acceptedUserId => $composableBuilder(
    column: $table.acceptedUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyInvitesTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyInvitesTable> {
  $$FamilyInvitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invitedEmail => $composableBuilder(
    column: $table.invitedEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invitedByUserId => $composableBuilder(
    column: $table.invitedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invitedByName => $composableBuilder(
    column: $table.invitedByName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invitedDisplayName => $composableBuilder(
    column: $table.invitedDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleLabel => $composableBuilder(
    column: $table.roleLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissionsJson => $composableBuilder(
    column: $table.permissionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get acceptedUserId => $composableBuilder(
    column: $table.acceptedUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyInvitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyInvitesTable> {
  $$FamilyInvitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get invitedEmail => $composableBuilder(
    column: $table.invitedEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invitedByUserId => $composableBuilder(
    column: $table.invitedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invitedByName => $composableBuilder(
    column: $table.invitedByName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invitedDisplayName => $composableBuilder(
    column: $table.invitedDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get roleLabel =>
      $composableBuilder(column: $table.roleLabel, builder: (column) => column);

  GeneratedColumn<String> get permissionsJson => $composableBuilder(
    column: $table.permissionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get acceptedUserId => $composableBuilder(
    column: $table.acceptedUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => column,
  );
}

class $$FamilyInvitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyInvitesTable,
          FamilyInvite,
          $$FamilyInvitesTableFilterComposer,
          $$FamilyInvitesTableOrderingComposer,
          $$FamilyInvitesTableAnnotationComposer,
          $$FamilyInvitesTableCreateCompanionBuilder,
          $$FamilyInvitesTableUpdateCompanionBuilder,
          (
            FamilyInvite,
            BaseReferences<_$AppDatabase, $FamilyInvitesTable, FamilyInvite>,
          ),
          FamilyInvite,
          PrefetchHooks Function()
        > {
  $$FamilyInvitesTableTableManager(_$AppDatabase db, $FamilyInvitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyInvitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyInvitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyInvitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String> invitedEmail = const Value.absent(),
                Value<String> invitedByUserId = const Value.absent(),
                Value<String> invitedByName = const Value.absent(),
                Value<String?> invitedDisplayName = const Value.absent(),
                Value<String?> roleLabel = const Value.absent(),
                Value<String> permissionsJson = const Value.absent(),
                Value<String?> acceptedUserId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> respondedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyInvitesCompanion(
                id: id,
                familyId: familyId,
                invitedEmail: invitedEmail,
                invitedByUserId: invitedByUserId,
                invitedByName: invitedByName,
                invitedDisplayName: invitedDisplayName,
                roleLabel: roleLabel,
                permissionsJson: permissionsJson,
                acceptedUserId: acceptedUserId,
                status: status,
                createdAt: createdAt,
                respondedAt: respondedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                required String invitedEmail,
                required String invitedByUserId,
                required String invitedByName,
                Value<String?> invitedDisplayName = const Value.absent(),
                Value<String?> roleLabel = const Value.absent(),
                Value<String> permissionsJson = const Value.absent(),
                Value<String?> acceptedUserId = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> respondedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyInvitesCompanion.insert(
                id: id,
                familyId: familyId,
                invitedEmail: invitedEmail,
                invitedByUserId: invitedByUserId,
                invitedByName: invitedByName,
                invitedDisplayName: invitedDisplayName,
                roleLabel: roleLabel,
                permissionsJson: permissionsJson,
                acceptedUserId: acceptedUserId,
                status: status,
                createdAt: createdAt,
                respondedAt: respondedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyInvitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyInvitesTable,
      FamilyInvite,
      $$FamilyInvitesTableFilterComposer,
      $$FamilyInvitesTableOrderingComposer,
      $$FamilyInvitesTableAnnotationComposer,
      $$FamilyInvitesTableCreateCompanionBuilder,
      $$FamilyInvitesTableUpdateCompanionBuilder,
      (
        FamilyInvite,
        BaseReferences<_$AppDatabase, $FamilyInvitesTable, FamilyInvite>,
      ),
      FamilyInvite,
      PrefetchHooks Function()
    >;
typedef $$VaccineEventsTableCreateCompanionBuilder =
    VaccineEventsCompanion Function({
      required String id,
      required String babyId,
      required String title,
      required String dose,
      required DateTime dueDate,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VaccineEventsTableUpdateCompanionBuilder =
    VaccineEventsCompanion Function({
      Value<String> id,
      Value<String> babyId,
      Value<String> title,
      Value<String> dose,
      Value<DateTime> dueDate,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$VaccineEventsTableFilterComposer
    extends Composer<_$AppDatabase, $VaccineEventsTable> {
  $$VaccineEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaccineEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccineEventsTable> {
  $$VaccineEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaccineEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccineEventsTable> {
  $$VaccineEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VaccineEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaccineEventsTable,
          VaccineEvent,
          $$VaccineEventsTableFilterComposer,
          $$VaccineEventsTableOrderingComposer,
          $$VaccineEventsTableAnnotationComposer,
          $$VaccineEventsTableCreateCompanionBuilder,
          $$VaccineEventsTableUpdateCompanionBuilder,
          (
            VaccineEvent,
            BaseReferences<_$AppDatabase, $VaccineEventsTable, VaccineEvent>,
          ),
          VaccineEvent,
          PrefetchHooks Function()
        > {
  $$VaccineEventsTableTableManager(_$AppDatabase db, $VaccineEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccineEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccineEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccineEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> babyId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> dose = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaccineEventsCompanion(
                id: id,
                babyId: babyId,
                title: title,
                dose: dose,
                dueDate: dueDate,
                status: status,
                notes: notes,
                completedAt: completedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String babyId,
                required String title,
                required String dose,
                required DateTime dueDate,
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VaccineEventsCompanion.insert(
                id: id,
                babyId: babyId,
                title: title,
                dose: dose,
                dueDate: dueDate,
                status: status,
                notes: notes,
                completedAt: completedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaccineEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaccineEventsTable,
      VaccineEvent,
      $$VaccineEventsTableFilterComposer,
      $$VaccineEventsTableOrderingComposer,
      $$VaccineEventsTableAnnotationComposer,
      $$VaccineEventsTableCreateCompanionBuilder,
      $$VaccineEventsTableUpdateCompanionBuilder,
      (
        VaccineEvent,
        BaseReferences<_$AppDatabase, $VaccineEventsTable, VaccineEvent>,
      ),
      VaccineEvent,
      PrefetchHooks Function()
    >;
typedef $$ArticlesTableCreateCompanionBuilder =
    ArticlesCompanion Function({
      required String id,
      Value<String> careMode,
      required String title,
      required String category,
      required String summary,
      required String content,
      required int readingMinutes,
      required String sourceName,
      required String sourceUrl,
      required String medicalDisclaimer,
      Value<int> rowid,
    });
typedef $$ArticlesTableUpdateCompanionBuilder =
    ArticlesCompanion Function({
      Value<String> id,
      Value<String> careMode,
      Value<String> title,
      Value<String> category,
      Value<String> summary,
      Value<String> content,
      Value<int> readingMinutes,
      Value<String> sourceName,
      Value<String> sourceUrl,
      Value<String> medicalDisclaimer,
      Value<int> rowid,
    });

class $$ArticlesTableFilterComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get careMode => $composableBuilder(
    column: $table.careMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readingMinutes => $composableBuilder(
    column: $table.readingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalDisclaimer => $composableBuilder(
    column: $table.medicalDisclaimer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get careMode => $composableBuilder(
    column: $table.careMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readingMinutes => $composableBuilder(
    column: $table.readingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalDisclaimer => $composableBuilder(
    column: $table.medicalDisclaimer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get careMode =>
      $composableBuilder(column: $table.careMode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get readingMinutes => $composableBuilder(
    column: $table.readingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get medicalDisclaimer => $composableBuilder(
    column: $table.medicalDisclaimer,
    builder: (column) => column,
  );
}

class $$ArticlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArticlesTable,
          Article,
          $$ArticlesTableFilterComposer,
          $$ArticlesTableOrderingComposer,
          $$ArticlesTableAnnotationComposer,
          $$ArticlesTableCreateCompanionBuilder,
          $$ArticlesTableUpdateCompanionBuilder,
          (Article, BaseReferences<_$AppDatabase, $ArticlesTable, Article>),
          Article,
          PrefetchHooks Function()
        > {
  $$ArticlesTableTableManager(_$AppDatabase db, $ArticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> careMode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> readingMinutes = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> medicalDisclaimer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticlesCompanion(
                id: id,
                careMode: careMode,
                title: title,
                category: category,
                summary: summary,
                content: content,
                readingMinutes: readingMinutes,
                sourceName: sourceName,
                sourceUrl: sourceUrl,
                medicalDisclaimer: medicalDisclaimer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> careMode = const Value.absent(),
                required String title,
                required String category,
                required String summary,
                required String content,
                required int readingMinutes,
                required String sourceName,
                required String sourceUrl,
                required String medicalDisclaimer,
                Value<int> rowid = const Value.absent(),
              }) => ArticlesCompanion.insert(
                id: id,
                careMode: careMode,
                title: title,
                category: category,
                summary: summary,
                content: content,
                readingMinutes: readingMinutes,
                sourceName: sourceName,
                sourceUrl: sourceUrl,
                medicalDisclaimer: medicalDisclaimer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArticlesTable,
      Article,
      $$ArticlesTableFilterComposer,
      $$ArticlesTableOrderingComposer,
      $$ArticlesTableAnnotationComposer,
      $$ArticlesTableCreateCompanionBuilder,
      $$ArticlesTableUpdateCompanionBuilder,
      (Article, BaseReferences<_$AppDatabase, $ArticlesTable, Article>),
      Article,
      PrefetchHooks Function()
    >;
typedef $$SavedArticlesTableCreateCompanionBuilder =
    SavedArticlesCompanion Function({
      required String articleId,
      required DateTime savedAt,
      Value<int> rowid,
    });
typedef $$SavedArticlesTableUpdateCompanionBuilder =
    SavedArticlesCompanion Function({
      Value<String> articleId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

class $$SavedArticlesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedArticlesTable> {
  $$SavedArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedArticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedArticlesTable> {
  $$SavedArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedArticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedArticlesTable> {
  $$SavedArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$SavedArticlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedArticlesTable,
          SavedArticle,
          $$SavedArticlesTableFilterComposer,
          $$SavedArticlesTableOrderingComposer,
          $$SavedArticlesTableAnnotationComposer,
          $$SavedArticlesTableCreateCompanionBuilder,
          $$SavedArticlesTableUpdateCompanionBuilder,
          (
            SavedArticle,
            BaseReferences<_$AppDatabase, $SavedArticlesTable, SavedArticle>,
          ),
          SavedArticle,
          PrefetchHooks Function()
        > {
  $$SavedArticlesTableTableManager(_$AppDatabase db, $SavedArticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> articleId = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedArticlesCompanion(
                articleId: articleId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String articleId,
                required DateTime savedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedArticlesCompanion.insert(
                articleId: articleId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedArticlesTable,
      SavedArticle,
      $$SavedArticlesTableFilterComposer,
      $$SavedArticlesTableOrderingComposer,
      $$SavedArticlesTableAnnotationComposer,
      $$SavedArticlesTableCreateCompanionBuilder,
      $$SavedArticlesTableUpdateCompanionBuilder,
      (
        SavedArticle,
        BaseReferences<_$AppDatabase, $SavedArticlesTable, SavedArticle>,
      ),
      SavedArticle,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      required String id,
      required String entityKind,
      required String entityId,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<String> id,
      Value<String> entityKind,
      Value<String> entityId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityKind => $composableBuilder(
    column: $table.entityKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityKind => $composableBuilder(
    column: $table.entityKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityKind => $composableBuilder(
    column: $table.entityKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$AppDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityKind = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                id: id,
                entityKind: entityKind,
                entityId: entityId,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityKind,
                required String entityId,
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueItemsCompanion.insert(
                id: id,
                entityKind: entityKind,
                entityId: entityId,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SettingsRowsTableTableManager get settingsRows =>
      $$SettingsRowsTableTableManager(_db, _db.settingsRows);
  $$FamiliesTableTableManager get families =>
      $$FamiliesTableTableManager(_db, _db.families);
  $$BabiesTableTableManager get babies =>
      $$BabiesTableTableManager(_db, _db.babies);
  $$PregnanciesTableTableManager get pregnancies =>
      $$PregnanciesTableTableManager(_db, _db.pregnancies);
  $$TrackerRecordsTableTableManager get trackerRecords =>
      $$TrackerRecordsTableTableManager(_db, _db.trackerRecords);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$AppNotificationsTableTableManager get appNotifications =>
      $$AppNotificationsTableTableManager(_db, _db.appNotifications);
  $$FamilyInvitesTableTableManager get familyInvites =>
      $$FamilyInvitesTableTableManager(_db, _db.familyInvites);
  $$VaccineEventsTableTableManager get vaccineEvents =>
      $$VaccineEventsTableTableManager(_db, _db.vaccineEvents);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db, _db.articles);
  $$SavedArticlesTableTableManager get savedArticles =>
      $$SavedArticlesTableTableManager(_db, _db.savedArticles);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
}
