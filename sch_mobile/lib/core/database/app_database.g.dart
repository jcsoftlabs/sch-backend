// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nationalIdMeta =
      const VerificationMeta('nationalId');
  @override
  late final GeneratedColumn<String> nationalId = GeneratedColumn<String>(
      'national_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        dateOfBirth,
        gender,
        address,
        phone,
        nationalId,
        householdId,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<Patient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('national_id')) {
      context.handle(
          _nationalIdMeta,
          nationalId.isAcceptableOrUnknown(
              data['national_id']!, _nationalIdMeta));
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      dateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      nationalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}national_id']),
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String? phone;
  final String? nationalId;
  final String? householdId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const Patient(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.address,
      this.phone,
      this.nationalId,
      this.householdId,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    map['gender'] = Variable<String>(gender);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || nationalId != null) {
      map['national_id'] = Variable<String>(nationalId);
    }
    if (!nullToAbsent || householdId != null) {
      map['household_id'] = Variable<String>(householdId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      dateOfBirth: Value(dateOfBirth),
      gender: Value(gender),
      address: Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      nationalId: nationalId == null && nullToAbsent
          ? const Value.absent()
          : Value(nationalId),
      householdId: householdId == null && nullToAbsent
          ? const Value.absent()
          : Value(householdId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      gender: serializer.fromJson<String>(json['gender']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      nationalId: serializer.fromJson<String?>(json['nationalId']),
      householdId: serializer.fromJson<String?>(json['householdId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'gender': serializer.toJson<String>(gender),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String?>(phone),
      'nationalId': serializer.toJson<String?>(nationalId),
      'householdId': serializer.toJson<String?>(householdId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Patient copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          DateTime? dateOfBirth,
          String? gender,
          String? address,
          Value<String?> phone = const Value.absent(),
          Value<String?> nationalId = const Value.absent(),
          Value<String?> householdId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus}) =>
      Patient(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        address: address ?? this.address,
        phone: phone.present ? phone.value : this.phone,
        nationalId: nationalId.present ? nationalId.value : this.nationalId,
        householdId: householdId.present ? householdId.value : this.householdId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      nationalId:
          data.nationalId.present ? data.nationalId.value : this.nationalId,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('nationalId: $nationalId, ')
          ..write('householdId: $householdId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      firstName,
      lastName,
      dateOfBirth,
      gender,
      address,
      phone,
      nationalId,
      householdId,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.nationalId == this.nationalId &&
          other.householdId == this.householdId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<DateTime> dateOfBirth;
  final Value<String> gender;
  final Value<String> address;
  final Value<String?> phone;
  final Value<String?> nationalId;
  final Value<String?> householdId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.householdId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String gender,
    required String address,
    this.phone = const Value.absent(),
    this.nationalId = const Value.absent(),
    this.householdId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName),
        dateOfBirth = Value(dateOfBirth),
        gender = Value(gender),
        address = Value(address),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Patient> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? nationalId,
    Expression<String>? householdId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (nationalId != null) 'national_id': nationalId,
      if (householdId != null) 'household_id': householdId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<DateTime>? dateOfBirth,
      Value<String>? gender,
      Value<String>? address,
      Value<String?>? phone,
      Value<String?>? nationalId,
      Value<String?>? householdId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return PatientsCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      householdId: householdId ?? this.householdId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (nationalId.present) {
      map['national_id'] = Variable<String>(nationalId.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('nationalId: $nationalId, ')
          ..write('householdId: $householdId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, Household> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdHeadNameMeta =
      const VerificationMeta('householdHeadName');
  @override
  late final GeneratedColumn<String> householdHeadName =
      GeneratedColumn<String>('household_head_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _neighborhoodMeta =
      const VerificationMeta('neighborhood');
  @override
  late final GeneratedColumn<String> neighborhood = GeneratedColumn<String>(
      'neighborhood', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _communeMeta =
      const VerificationMeta('commune');
  @override
  late final GeneratedColumn<String> commune = GeneratedColumn<String>(
      'commune', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gpsLatMeta = const VerificationMeta('gpsLat');
  @override
  late final GeneratedColumn<double> gpsLat = GeneratedColumn<double>(
      'gps_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _gpsLngMeta = const VerificationMeta('gpsLng');
  @override
  late final GeneratedColumn<double> gpsLng = GeneratedColumn<double>(
      'gps_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _gpsAccuracyMeta =
      const VerificationMeta('gpsAccuracy');
  @override
  late final GeneratedColumn<double> gpsAccuracy = GeneratedColumn<double>(
      'gps_accuracy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
      'zone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _housingTypeMeta =
      const VerificationMeta('housingType');
  @override
  late final GeneratedColumn<String> housingType = GeneratedColumn<String>(
      'housing_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numberOfRoomsMeta =
      const VerificationMeta('numberOfRooms');
  @override
  late final GeneratedColumn<int> numberOfRooms = GeneratedColumn<int>(
      'number_of_rooms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _waterSourceMeta =
      const VerificationMeta('waterSource');
  @override
  late final GeneratedColumn<String> waterSource = GeneratedColumn<String>(
      'water_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sanitationTypeMeta =
      const VerificationMeta('sanitationType');
  @override
  late final GeneratedColumn<String> sanitationType = GeneratedColumn<String>(
      'sanitation_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hasElectricityMeta =
      const VerificationMeta('hasElectricity');
  @override
  late final GeneratedColumn<bool> hasElectricity = GeneratedColumn<bool>(
      'has_electricity', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_electricity" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
      'member_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _agentIdMeta =
      const VerificationMeta('agentId');
  @override
  late final GeneratedColumn<String> agentId = GeneratedColumn<String>(
      'agent_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdHeadName,
        address,
        neighborhood,
        commune,
        phone,
        gpsLat,
        gpsLng,
        gpsAccuracy,
        zone,
        housingType,
        numberOfRooms,
        waterSource,
        sanitationType,
        hasElectricity,
        memberCount,
        agentId,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(Insertable<Household> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_head_name')) {
      context.handle(
          _householdHeadNameMeta,
          householdHeadName.isAcceptableOrUnknown(
              data['household_head_name']!, _householdHeadNameMeta));
    } else if (isInserting) {
      context.missing(_householdHeadNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('neighborhood')) {
      context.handle(
          _neighborhoodMeta,
          neighborhood.isAcceptableOrUnknown(
              data['neighborhood']!, _neighborhoodMeta));
    }
    if (data.containsKey('commune')) {
      context.handle(_communeMeta,
          commune.isAcceptableOrUnknown(data['commune']!, _communeMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('gps_lat')) {
      context.handle(_gpsLatMeta,
          gpsLat.isAcceptableOrUnknown(data['gps_lat']!, _gpsLatMeta));
    }
    if (data.containsKey('gps_lng')) {
      context.handle(_gpsLngMeta,
          gpsLng.isAcceptableOrUnknown(data['gps_lng']!, _gpsLngMeta));
    }
    if (data.containsKey('gps_accuracy')) {
      context.handle(
          _gpsAccuracyMeta,
          gpsAccuracy.isAcceptableOrUnknown(
              data['gps_accuracy']!, _gpsAccuracyMeta));
    }
    if (data.containsKey('zone')) {
      context.handle(
          _zoneMeta, zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta));
    } else if (isInserting) {
      context.missing(_zoneMeta);
    }
    if (data.containsKey('housing_type')) {
      context.handle(
          _housingTypeMeta,
          housingType.isAcceptableOrUnknown(
              data['housing_type']!, _housingTypeMeta));
    }
    if (data.containsKey('number_of_rooms')) {
      context.handle(
          _numberOfRoomsMeta,
          numberOfRooms.isAcceptableOrUnknown(
              data['number_of_rooms']!, _numberOfRoomsMeta));
    }
    if (data.containsKey('water_source')) {
      context.handle(
          _waterSourceMeta,
          waterSource.isAcceptableOrUnknown(
              data['water_source']!, _waterSourceMeta));
    }
    if (data.containsKey('sanitation_type')) {
      context.handle(
          _sanitationTypeMeta,
          sanitationType.isAcceptableOrUnknown(
              data['sanitation_type']!, _sanitationTypeMeta));
    }
    if (data.containsKey('has_electricity')) {
      context.handle(
          _hasElectricityMeta,
          hasElectricity.isAcceptableOrUnknown(
              data['has_electricity']!, _hasElectricityMeta));
    }
    if (data.containsKey('member_count')) {
      context.handle(
          _memberCountMeta,
          memberCount.isAcceptableOrUnknown(
              data['member_count']!, _memberCountMeta));
    }
    if (data.containsKey('agent_id')) {
      context.handle(_agentIdMeta,
          agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta));
    } else if (isInserting) {
      context.missing(_agentIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Household map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Household(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdHeadName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}household_head_name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      neighborhood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}neighborhood']),
      commune: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}commune']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      gpsLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_lat']),
      gpsLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_lng']),
      gpsAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gps_accuracy']),
      zone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone'])!,
      housingType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}housing_type']),
      numberOfRooms: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_of_rooms']),
      waterSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}water_source']),
      sanitationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sanitation_type']),
      hasElectricity: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_electricity'])!,
      memberCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}member_count'])!,
      agentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agent_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }
}

class Household extends DataClass implements Insertable<Household> {
  final String id;
  final String householdHeadName;
  final String address;
  final String? neighborhood;
  final String? commune;
  final String? phone;
  final double? gpsLat;
  final double? gpsLng;
  final double? gpsAccuracy;
  final String zone;
  final String? housingType;
  final int? numberOfRooms;
  final String? waterSource;
  final String? sanitationType;
  final bool hasElectricity;
  final int memberCount;
  final String agentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const Household(
      {required this.id,
      required this.householdHeadName,
      required this.address,
      this.neighborhood,
      this.commune,
      this.phone,
      this.gpsLat,
      this.gpsLng,
      this.gpsAccuracy,
      required this.zone,
      this.housingType,
      this.numberOfRooms,
      this.waterSource,
      this.sanitationType,
      required this.hasElectricity,
      required this.memberCount,
      required this.agentId,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_head_name'] = Variable<String>(householdHeadName);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || neighborhood != null) {
      map['neighborhood'] = Variable<String>(neighborhood);
    }
    if (!nullToAbsent || commune != null) {
      map['commune'] = Variable<String>(commune);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || gpsLat != null) {
      map['gps_lat'] = Variable<double>(gpsLat);
    }
    if (!nullToAbsent || gpsLng != null) {
      map['gps_lng'] = Variable<double>(gpsLng);
    }
    if (!nullToAbsent || gpsAccuracy != null) {
      map['gps_accuracy'] = Variable<double>(gpsAccuracy);
    }
    map['zone'] = Variable<String>(zone);
    if (!nullToAbsent || housingType != null) {
      map['housing_type'] = Variable<String>(housingType);
    }
    if (!nullToAbsent || numberOfRooms != null) {
      map['number_of_rooms'] = Variable<int>(numberOfRooms);
    }
    if (!nullToAbsent || waterSource != null) {
      map['water_source'] = Variable<String>(waterSource);
    }
    if (!nullToAbsent || sanitationType != null) {
      map['sanitation_type'] = Variable<String>(sanitationType);
    }
    map['has_electricity'] = Variable<bool>(hasElectricity);
    map['member_count'] = Variable<int>(memberCount);
    map['agent_id'] = Variable<String>(agentId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      id: Value(id),
      householdHeadName: Value(householdHeadName),
      address: Value(address),
      neighborhood: neighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(neighborhood),
      commune: commune == null && nullToAbsent
          ? const Value.absent()
          : Value(commune),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      gpsLat:
          gpsLat == null && nullToAbsent ? const Value.absent() : Value(gpsLat),
      gpsLng:
          gpsLng == null && nullToAbsent ? const Value.absent() : Value(gpsLng),
      gpsAccuracy: gpsAccuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsAccuracy),
      zone: Value(zone),
      housingType: housingType == null && nullToAbsent
          ? const Value.absent()
          : Value(housingType),
      numberOfRooms: numberOfRooms == null && nullToAbsent
          ? const Value.absent()
          : Value(numberOfRooms),
      waterSource: waterSource == null && nullToAbsent
          ? const Value.absent()
          : Value(waterSource),
      sanitationType: sanitationType == null && nullToAbsent
          ? const Value.absent()
          : Value(sanitationType),
      hasElectricity: Value(hasElectricity),
      memberCount: Value(memberCount),
      agentId: Value(agentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Household.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Household(
      id: serializer.fromJson<String>(json['id']),
      householdHeadName: serializer.fromJson<String>(json['householdHeadName']),
      address: serializer.fromJson<String>(json['address']),
      neighborhood: serializer.fromJson<String?>(json['neighborhood']),
      commune: serializer.fromJson<String?>(json['commune']),
      phone: serializer.fromJson<String?>(json['phone']),
      gpsLat: serializer.fromJson<double?>(json['gpsLat']),
      gpsLng: serializer.fromJson<double?>(json['gpsLng']),
      gpsAccuracy: serializer.fromJson<double?>(json['gpsAccuracy']),
      zone: serializer.fromJson<String>(json['zone']),
      housingType: serializer.fromJson<String?>(json['housingType']),
      numberOfRooms: serializer.fromJson<int?>(json['numberOfRooms']),
      waterSource: serializer.fromJson<String?>(json['waterSource']),
      sanitationType: serializer.fromJson<String?>(json['sanitationType']),
      hasElectricity: serializer.fromJson<bool>(json['hasElectricity']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      agentId: serializer.fromJson<String>(json['agentId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdHeadName': serializer.toJson<String>(householdHeadName),
      'address': serializer.toJson<String>(address),
      'neighborhood': serializer.toJson<String?>(neighborhood),
      'commune': serializer.toJson<String?>(commune),
      'phone': serializer.toJson<String?>(phone),
      'gpsLat': serializer.toJson<double?>(gpsLat),
      'gpsLng': serializer.toJson<double?>(gpsLng),
      'gpsAccuracy': serializer.toJson<double?>(gpsAccuracy),
      'zone': serializer.toJson<String>(zone),
      'housingType': serializer.toJson<String?>(housingType),
      'numberOfRooms': serializer.toJson<int?>(numberOfRooms),
      'waterSource': serializer.toJson<String?>(waterSource),
      'sanitationType': serializer.toJson<String?>(sanitationType),
      'hasElectricity': serializer.toJson<bool>(hasElectricity),
      'memberCount': serializer.toJson<int>(memberCount),
      'agentId': serializer.toJson<String>(agentId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Household copyWith(
          {String? id,
          String? householdHeadName,
          String? address,
          Value<String?> neighborhood = const Value.absent(),
          Value<String?> commune = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<double?> gpsLat = const Value.absent(),
          Value<double?> gpsLng = const Value.absent(),
          Value<double?> gpsAccuracy = const Value.absent(),
          String? zone,
          Value<String?> housingType = const Value.absent(),
          Value<int?> numberOfRooms = const Value.absent(),
          Value<String?> waterSource = const Value.absent(),
          Value<String?> sanitationType = const Value.absent(),
          bool? hasElectricity,
          int? memberCount,
          String? agentId,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus}) =>
      Household(
        id: id ?? this.id,
        householdHeadName: householdHeadName ?? this.householdHeadName,
        address: address ?? this.address,
        neighborhood:
            neighborhood.present ? neighborhood.value : this.neighborhood,
        commune: commune.present ? commune.value : this.commune,
        phone: phone.present ? phone.value : this.phone,
        gpsLat: gpsLat.present ? gpsLat.value : this.gpsLat,
        gpsLng: gpsLng.present ? gpsLng.value : this.gpsLng,
        gpsAccuracy: gpsAccuracy.present ? gpsAccuracy.value : this.gpsAccuracy,
        zone: zone ?? this.zone,
        housingType: housingType.present ? housingType.value : this.housingType,
        numberOfRooms:
            numberOfRooms.present ? numberOfRooms.value : this.numberOfRooms,
        waterSource: waterSource.present ? waterSource.value : this.waterSource,
        sanitationType:
            sanitationType.present ? sanitationType.value : this.sanitationType,
        hasElectricity: hasElectricity ?? this.hasElectricity,
        memberCount: memberCount ?? this.memberCount,
        agentId: agentId ?? this.agentId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Household copyWithCompanion(HouseholdsCompanion data) {
    return Household(
      id: data.id.present ? data.id.value : this.id,
      householdHeadName: data.householdHeadName.present
          ? data.householdHeadName.value
          : this.householdHeadName,
      address: data.address.present ? data.address.value : this.address,
      neighborhood: data.neighborhood.present
          ? data.neighborhood.value
          : this.neighborhood,
      commune: data.commune.present ? data.commune.value : this.commune,
      phone: data.phone.present ? data.phone.value : this.phone,
      gpsLat: data.gpsLat.present ? data.gpsLat.value : this.gpsLat,
      gpsLng: data.gpsLng.present ? data.gpsLng.value : this.gpsLng,
      gpsAccuracy:
          data.gpsAccuracy.present ? data.gpsAccuracy.value : this.gpsAccuracy,
      zone: data.zone.present ? data.zone.value : this.zone,
      housingType:
          data.housingType.present ? data.housingType.value : this.housingType,
      numberOfRooms: data.numberOfRooms.present
          ? data.numberOfRooms.value
          : this.numberOfRooms,
      waterSource:
          data.waterSource.present ? data.waterSource.value : this.waterSource,
      sanitationType: data.sanitationType.present
          ? data.sanitationType.value
          : this.sanitationType,
      hasElectricity: data.hasElectricity.present
          ? data.hasElectricity.value
          : this.hasElectricity,
      memberCount:
          data.memberCount.present ? data.memberCount.value : this.memberCount,
      agentId: data.agentId.present ? data.agentId.value : this.agentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Household(')
          ..write('id: $id, ')
          ..write('householdHeadName: $householdHeadName, ')
          ..write('address: $address, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('commune: $commune, ')
          ..write('phone: $phone, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('gpsAccuracy: $gpsAccuracy, ')
          ..write('zone: $zone, ')
          ..write('housingType: $housingType, ')
          ..write('numberOfRooms: $numberOfRooms, ')
          ..write('waterSource: $waterSource, ')
          ..write('sanitationType: $sanitationType, ')
          ..write('hasElectricity: $hasElectricity, ')
          ..write('memberCount: $memberCount, ')
          ..write('agentId: $agentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdHeadName,
      address,
      neighborhood,
      commune,
      phone,
      gpsLat,
      gpsLng,
      gpsAccuracy,
      zone,
      housingType,
      numberOfRooms,
      waterSource,
      sanitationType,
      hasElectricity,
      memberCount,
      agentId,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Household &&
          other.id == this.id &&
          other.householdHeadName == this.householdHeadName &&
          other.address == this.address &&
          other.neighborhood == this.neighborhood &&
          other.commune == this.commune &&
          other.phone == this.phone &&
          other.gpsLat == this.gpsLat &&
          other.gpsLng == this.gpsLng &&
          other.gpsAccuracy == this.gpsAccuracy &&
          other.zone == this.zone &&
          other.housingType == this.housingType &&
          other.numberOfRooms == this.numberOfRooms &&
          other.waterSource == this.waterSource &&
          other.sanitationType == this.sanitationType &&
          other.hasElectricity == this.hasElectricity &&
          other.memberCount == this.memberCount &&
          other.agentId == this.agentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class HouseholdsCompanion extends UpdateCompanion<Household> {
  final Value<String> id;
  final Value<String> householdHeadName;
  final Value<String> address;
  final Value<String?> neighborhood;
  final Value<String?> commune;
  final Value<String?> phone;
  final Value<double?> gpsLat;
  final Value<double?> gpsLng;
  final Value<double?> gpsAccuracy;
  final Value<String> zone;
  final Value<String?> housingType;
  final Value<int?> numberOfRooms;
  final Value<String?> waterSource;
  final Value<String?> sanitationType;
  final Value<bool> hasElectricity;
  final Value<int> memberCount;
  final Value<String> agentId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const HouseholdsCompanion({
    this.id = const Value.absent(),
    this.householdHeadName = const Value.absent(),
    this.address = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.commune = const Value.absent(),
    this.phone = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.gpsAccuracy = const Value.absent(),
    this.zone = const Value.absent(),
    this.housingType = const Value.absent(),
    this.numberOfRooms = const Value.absent(),
    this.waterSource = const Value.absent(),
    this.sanitationType = const Value.absent(),
    this.hasElectricity = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.agentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    required String id,
    required String householdHeadName,
    required String address,
    this.neighborhood = const Value.absent(),
    this.commune = const Value.absent(),
    this.phone = const Value.absent(),
    this.gpsLat = const Value.absent(),
    this.gpsLng = const Value.absent(),
    this.gpsAccuracy = const Value.absent(),
    required String zone,
    this.housingType = const Value.absent(),
    this.numberOfRooms = const Value.absent(),
    this.waterSource = const Value.absent(),
    this.sanitationType = const Value.absent(),
    this.hasElectricity = const Value.absent(),
    this.memberCount = const Value.absent(),
    required String agentId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdHeadName = Value(householdHeadName),
        address = Value(address),
        zone = Value(zone),
        agentId = Value(agentId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Household> custom({
    Expression<String>? id,
    Expression<String>? householdHeadName,
    Expression<String>? address,
    Expression<String>? neighborhood,
    Expression<String>? commune,
    Expression<String>? phone,
    Expression<double>? gpsLat,
    Expression<double>? gpsLng,
    Expression<double>? gpsAccuracy,
    Expression<String>? zone,
    Expression<String>? housingType,
    Expression<int>? numberOfRooms,
    Expression<String>? waterSource,
    Expression<String>? sanitationType,
    Expression<bool>? hasElectricity,
    Expression<int>? memberCount,
    Expression<String>? agentId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdHeadName != null) 'household_head_name': householdHeadName,
      if (address != null) 'address': address,
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (commune != null) 'commune': commune,
      if (phone != null) 'phone': phone,
      if (gpsLat != null) 'gps_lat': gpsLat,
      if (gpsLng != null) 'gps_lng': gpsLng,
      if (gpsAccuracy != null) 'gps_accuracy': gpsAccuracy,
      if (zone != null) 'zone': zone,
      if (housingType != null) 'housing_type': housingType,
      if (numberOfRooms != null) 'number_of_rooms': numberOfRooms,
      if (waterSource != null) 'water_source': waterSource,
      if (sanitationType != null) 'sanitation_type': sanitationType,
      if (hasElectricity != null) 'has_electricity': hasElectricity,
      if (memberCount != null) 'member_count': memberCount,
      if (agentId != null) 'agent_id': agentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdHeadName,
      Value<String>? address,
      Value<String?>? neighborhood,
      Value<String?>? commune,
      Value<String?>? phone,
      Value<double?>? gpsLat,
      Value<double?>? gpsLng,
      Value<double?>? gpsAccuracy,
      Value<String>? zone,
      Value<String?>? housingType,
      Value<int?>? numberOfRooms,
      Value<String?>? waterSource,
      Value<String?>? sanitationType,
      Value<bool>? hasElectricity,
      Value<int>? memberCount,
      Value<String>? agentId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return HouseholdsCompanion(
      id: id ?? this.id,
      householdHeadName: householdHeadName ?? this.householdHeadName,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      commune: commune ?? this.commune,
      phone: phone ?? this.phone,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      gpsAccuracy: gpsAccuracy ?? this.gpsAccuracy,
      zone: zone ?? this.zone,
      housingType: housingType ?? this.housingType,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      waterSource: waterSource ?? this.waterSource,
      sanitationType: sanitationType ?? this.sanitationType,
      hasElectricity: hasElectricity ?? this.hasElectricity,
      memberCount: memberCount ?? this.memberCount,
      agentId: agentId ?? this.agentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdHeadName.present) {
      map['household_head_name'] = Variable<String>(householdHeadName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (neighborhood.present) {
      map['neighborhood'] = Variable<String>(neighborhood.value);
    }
    if (commune.present) {
      map['commune'] = Variable<String>(commune.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (gpsLat.present) {
      map['gps_lat'] = Variable<double>(gpsLat.value);
    }
    if (gpsLng.present) {
      map['gps_lng'] = Variable<double>(gpsLng.value);
    }
    if (gpsAccuracy.present) {
      map['gps_accuracy'] = Variable<double>(gpsAccuracy.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (housingType.present) {
      map['housing_type'] = Variable<String>(housingType.value);
    }
    if (numberOfRooms.present) {
      map['number_of_rooms'] = Variable<int>(numberOfRooms.value);
    }
    if (waterSource.present) {
      map['water_source'] = Variable<String>(waterSource.value);
    }
    if (sanitationType.present) {
      map['sanitation_type'] = Variable<String>(sanitationType.value);
    }
    if (hasElectricity.present) {
      map['has_electricity'] = Variable<bool>(hasElectricity.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<String>(agentId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('householdHeadName: $householdHeadName, ')
          ..write('address: $address, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('commune: $commune, ')
          ..write('phone: $phone, ')
          ..write('gpsLat: $gpsLat, ')
          ..write('gpsLng: $gpsLng, ')
          ..write('gpsAccuracy: $gpsAccuracy, ')
          ..write('zone: $zone, ')
          ..write('housingType: $housingType, ')
          ..write('numberOfRooms: $numberOfRooms, ')
          ..write('waterSource: $waterSource, ')
          ..write('sanitationType: $sanitationType, ')
          ..write('hasElectricity: $hasElectricity, ')
          ..write('memberCount: $memberCount, ')
          ..write('agentId: $agentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdMembersTable extends HouseholdMembers
    with TableInfo<$HouseholdMembersTable, HouseholdMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
      'date_of_birth', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationshipToHeadMeta =
      const VerificationMeta('relationshipToHead');
  @override
  late final GeneratedColumn<String> relationshipToHead =
      GeneratedColumn<String>('relationship_to_head', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _educationLevelMeta =
      const VerificationMeta('educationLevel');
  @override
  late final GeneratedColumn<String> educationLevel = GeneratedColumn<String>(
      'education_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occupationMeta =
      const VerificationMeta('occupation');
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
      'occupation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hasHealthInsuranceMeta =
      const VerificationMeta('hasHealthInsurance');
  @override
  late final GeneratedColumn<bool> hasHealthInsurance = GeneratedColumn<bool>(
      'has_health_insurance', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_health_insurance" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _insuranceProviderMeta =
      const VerificationMeta('insuranceProvider');
  @override
  late final GeneratedColumn<String> insuranceProvider =
      GeneratedColumn<String>('insurance_provider', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chronicConditionsMeta =
      const VerificationMeta('chronicConditions');
  @override
  late final GeneratedColumn<String> chronicConditions =
      GeneratedColumn<String>('chronic_conditions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        fullName,
        dateOfBirth,
        gender,
        relationshipToHead,
        educationLevel,
        occupation,
        hasHealthInsurance,
        insuranceProvider,
        chronicConditions,
        patientId,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_members';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('relationship_to_head')) {
      context.handle(
          _relationshipToHeadMeta,
          relationshipToHead.isAcceptableOrUnknown(
              data['relationship_to_head']!, _relationshipToHeadMeta));
    } else if (isInserting) {
      context.missing(_relationshipToHeadMeta);
    }
    if (data.containsKey('education_level')) {
      context.handle(
          _educationLevelMeta,
          educationLevel.isAcceptableOrUnknown(
              data['education_level']!, _educationLevelMeta));
    }
    if (data.containsKey('occupation')) {
      context.handle(
          _occupationMeta,
          occupation.isAcceptableOrUnknown(
              data['occupation']!, _occupationMeta));
    }
    if (data.containsKey('has_health_insurance')) {
      context.handle(
          _hasHealthInsuranceMeta,
          hasHealthInsurance.isAcceptableOrUnknown(
              data['has_health_insurance']!, _hasHealthInsuranceMeta));
    }
    if (data.containsKey('insurance_provider')) {
      context.handle(
          _insuranceProviderMeta,
          insuranceProvider.isAcceptableOrUnknown(
              data['insurance_provider']!, _insuranceProviderMeta));
    }
    if (data.containsKey('chronic_conditions')) {
      context.handle(
          _chronicConditionsMeta,
          chronicConditions.isAcceptableOrUnknown(
              data['chronic_conditions']!, _chronicConditionsMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      dateOfBirth: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_of_birth'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      relationshipToHead: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}relationship_to_head'])!,
      educationLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}education_level']),
      occupation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}occupation']),
      hasHealthInsurance: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}has_health_insurance'])!,
      insuranceProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}insurance_provider']),
      chronicConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chronic_conditions']),
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $HouseholdMembersTable createAlias(String alias) {
    return $HouseholdMembersTable(attachedDatabase, alias);
  }
}

class HouseholdMember extends DataClass implements Insertable<HouseholdMember> {
  final String id;
  final String householdId;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String relationshipToHead;
  final String? educationLevel;
  final String? occupation;
  final bool hasHealthInsurance;
  final String? insuranceProvider;
  final String? chronicConditions;
  final String? patientId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const HouseholdMember(
      {required this.id,
      required this.householdId,
      required this.fullName,
      required this.dateOfBirth,
      required this.gender,
      required this.relationshipToHead,
      this.educationLevel,
      this.occupation,
      required this.hasHealthInsurance,
      this.insuranceProvider,
      this.chronicConditions,
      this.patientId,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['full_name'] = Variable<String>(fullName);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    map['gender'] = Variable<String>(gender);
    map['relationship_to_head'] = Variable<String>(relationshipToHead);
    if (!nullToAbsent || educationLevel != null) {
      map['education_level'] = Variable<String>(educationLevel);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    map['has_health_insurance'] = Variable<bool>(hasHealthInsurance);
    if (!nullToAbsent || insuranceProvider != null) {
      map['insurance_provider'] = Variable<String>(insuranceProvider);
    }
    if (!nullToAbsent || chronicConditions != null) {
      map['chronic_conditions'] = Variable<String>(chronicConditions);
    }
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<String>(patientId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  HouseholdMembersCompanion toCompanion(bool nullToAbsent) {
    return HouseholdMembersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      fullName: Value(fullName),
      dateOfBirth: Value(dateOfBirth),
      gender: Value(gender),
      relationshipToHead: Value(relationshipToHead),
      educationLevel: educationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(educationLevel),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      hasHealthInsurance: Value(hasHealthInsurance),
      insuranceProvider: insuranceProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceProvider),
      chronicConditions: chronicConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(chronicConditions),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory HouseholdMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdMember(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      gender: serializer.fromJson<String>(json['gender']),
      relationshipToHead:
          serializer.fromJson<String>(json['relationshipToHead']),
      educationLevel: serializer.fromJson<String?>(json['educationLevel']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      hasHealthInsurance: serializer.fromJson<bool>(json['hasHealthInsurance']),
      insuranceProvider:
          serializer.fromJson<String?>(json['insuranceProvider']),
      chronicConditions:
          serializer.fromJson<String?>(json['chronicConditions']),
      patientId: serializer.fromJson<String?>(json['patientId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'fullName': serializer.toJson<String>(fullName),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'gender': serializer.toJson<String>(gender),
      'relationshipToHead': serializer.toJson<String>(relationshipToHead),
      'educationLevel': serializer.toJson<String?>(educationLevel),
      'occupation': serializer.toJson<String?>(occupation),
      'hasHealthInsurance': serializer.toJson<bool>(hasHealthInsurance),
      'insuranceProvider': serializer.toJson<String?>(insuranceProvider),
      'chronicConditions': serializer.toJson<String?>(chronicConditions),
      'patientId': serializer.toJson<String?>(patientId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  HouseholdMember copyWith(
          {String? id,
          String? householdId,
          String? fullName,
          DateTime? dateOfBirth,
          String? gender,
          String? relationshipToHead,
          Value<String?> educationLevel = const Value.absent(),
          Value<String?> occupation = const Value.absent(),
          bool? hasHealthInsurance,
          Value<String?> insuranceProvider = const Value.absent(),
          Value<String?> chronicConditions = const Value.absent(),
          Value<String?> patientId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus}) =>
      HouseholdMember(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        fullName: fullName ?? this.fullName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        relationshipToHead: relationshipToHead ?? this.relationshipToHead,
        educationLevel:
            educationLevel.present ? educationLevel.value : this.educationLevel,
        occupation: occupation.present ? occupation.value : this.occupation,
        hasHealthInsurance: hasHealthInsurance ?? this.hasHealthInsurance,
        insuranceProvider: insuranceProvider.present
            ? insuranceProvider.value
            : this.insuranceProvider,
        chronicConditions: chronicConditions.present
            ? chronicConditions.value
            : this.chronicConditions,
        patientId: patientId.present ? patientId.value : this.patientId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  HouseholdMember copyWithCompanion(HouseholdMembersCompanion data) {
    return HouseholdMember(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      relationshipToHead: data.relationshipToHead.present
          ? data.relationshipToHead.value
          : this.relationshipToHead,
      educationLevel: data.educationLevel.present
          ? data.educationLevel.value
          : this.educationLevel,
      occupation:
          data.occupation.present ? data.occupation.value : this.occupation,
      hasHealthInsurance: data.hasHealthInsurance.present
          ? data.hasHealthInsurance.value
          : this.hasHealthInsurance,
      insuranceProvider: data.insuranceProvider.present
          ? data.insuranceProvider.value
          : this.insuranceProvider,
      chronicConditions: data.chronicConditions.present
          ? data.chronicConditions.value
          : this.chronicConditions,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMember(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('fullName: $fullName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('relationshipToHead: $relationshipToHead, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('occupation: $occupation, ')
          ..write('hasHealthInsurance: $hasHealthInsurance, ')
          ..write('insuranceProvider: $insuranceProvider, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('patientId: $patientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      fullName,
      dateOfBirth,
      gender,
      relationshipToHead,
      educationLevel,
      occupation,
      hasHealthInsurance,
      insuranceProvider,
      chronicConditions,
      patientId,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdMember &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.fullName == this.fullName &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.relationshipToHead == this.relationshipToHead &&
          other.educationLevel == this.educationLevel &&
          other.occupation == this.occupation &&
          other.hasHealthInsurance == this.hasHealthInsurance &&
          other.insuranceProvider == this.insuranceProvider &&
          other.chronicConditions == this.chronicConditions &&
          other.patientId == this.patientId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class HouseholdMembersCompanion extends UpdateCompanion<HouseholdMember> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> fullName;
  final Value<DateTime> dateOfBirth;
  final Value<String> gender;
  final Value<String> relationshipToHead;
  final Value<String?> educationLevel;
  final Value<String?> occupation;
  final Value<bool> hasHealthInsurance;
  final Value<String?> insuranceProvider;
  final Value<String?> chronicConditions;
  final Value<String?> patientId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const HouseholdMembersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.relationshipToHead = const Value.absent(),
    this.educationLevel = const Value.absent(),
    this.occupation = const Value.absent(),
    this.hasHealthInsurance = const Value.absent(),
    this.insuranceProvider = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.patientId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdMembersCompanion.insert({
    required String id,
    required String householdId,
    required String fullName,
    required DateTime dateOfBirth,
    required String gender,
    required String relationshipToHead,
    this.educationLevel = const Value.absent(),
    this.occupation = const Value.absent(),
    this.hasHealthInsurance = const Value.absent(),
    this.insuranceProvider = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.patientId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        fullName = Value(fullName),
        dateOfBirth = Value(dateOfBirth),
        gender = Value(gender),
        relationshipToHead = Value(relationshipToHead),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<HouseholdMember> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? fullName,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? relationshipToHead,
    Expression<String>? educationLevel,
    Expression<String>? occupation,
    Expression<bool>? hasHealthInsurance,
    Expression<String>? insuranceProvider,
    Expression<String>? chronicConditions,
    Expression<String>? patientId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (fullName != null) 'full_name': fullName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (relationshipToHead != null)
        'relationship_to_head': relationshipToHead,
      if (educationLevel != null) 'education_level': educationLevel,
      if (occupation != null) 'occupation': occupation,
      if (hasHealthInsurance != null)
        'has_health_insurance': hasHealthInsurance,
      if (insuranceProvider != null) 'insurance_provider': insuranceProvider,
      if (chronicConditions != null) 'chronic_conditions': chronicConditions,
      if (patientId != null) 'patient_id': patientId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? fullName,
      Value<DateTime>? dateOfBirth,
      Value<String>? gender,
      Value<String>? relationshipToHead,
      Value<String?>? educationLevel,
      Value<String?>? occupation,
      Value<bool>? hasHealthInsurance,
      Value<String?>? insuranceProvider,
      Value<String?>? chronicConditions,
      Value<String?>? patientId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return HouseholdMembersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      relationshipToHead: relationshipToHead ?? this.relationshipToHead,
      educationLevel: educationLevel ?? this.educationLevel,
      occupation: occupation ?? this.occupation,
      hasHealthInsurance: hasHealthInsurance ?? this.hasHealthInsurance,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (relationshipToHead.present) {
      map['relationship_to_head'] = Variable<String>(relationshipToHead.value);
    }
    if (educationLevel.present) {
      map['education_level'] = Variable<String>(educationLevel.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (hasHealthInsurance.present) {
      map['has_health_insurance'] = Variable<bool>(hasHealthInsurance.value);
    }
    if (insuranceProvider.present) {
      map['insurance_provider'] = Variable<String>(insuranceProvider.value);
    }
    if (chronicConditions.present) {
      map['chronic_conditions'] = Variable<String>(chronicConditions.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMembersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('fullName: $fullName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('relationshipToHead: $relationshipToHead, ')
          ..write('educationLevel: $educationLevel, ')
          ..write('occupation: $occupation, ')
          ..write('hasHealthInsurance: $hasHealthInsurance, ')
          ..write('insuranceProvider: $insuranceProvider, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('patientId: $patientId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsultationsTable extends Consultations
    with TableInfo<$ConsultationsTable, Consultation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsultationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _agentIdMeta =
      const VerificationMeta('agentId');
  @override
  late final GeneratedColumn<String> agentId = GeneratedColumn<String>(
      'agent_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _chiefComplaintMeta =
      const VerificationMeta('chiefComplaint');
  @override
  late final GeneratedColumn<String> chiefComplaint = GeneratedColumn<String>(
      'chief_complaint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _symptomsMeta =
      const VerificationMeta('symptoms');
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
      'symptoms', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diagnosisMeta =
      const VerificationMeta('diagnosis');
  @override
  late final GeneratedColumn<String> diagnosis = GeneratedColumn<String>(
      'diagnosis', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _treatmentMeta =
      const VerificationMeta('treatment');
  @override
  late final GeneratedColumn<String> treatment = GeneratedColumn<String>(
      'treatment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vitalSignsMeta =
      const VerificationMeta('vitalSigns');
  @override
  late final GeneratedColumn<String> vitalSigns = GeneratedColumn<String>(
      'vital_signs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photosMeta = const VerificationMeta('photos');
  @override
  late final GeneratedColumn<String> photos = GeneratedColumn<String>(
      'photos', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        agentId,
        date,
        chiefComplaint,
        symptoms,
        diagnosis,
        treatment,
        vitalSigns,
        photos,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consultations';
  @override
  VerificationContext validateIntegrity(Insertable<Consultation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('agent_id')) {
      context.handle(_agentIdMeta,
          agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta));
    } else if (isInserting) {
      context.missing(_agentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('chief_complaint')) {
      context.handle(
          _chiefComplaintMeta,
          chiefComplaint.isAcceptableOrUnknown(
              data['chief_complaint']!, _chiefComplaintMeta));
    } else if (isInserting) {
      context.missing(_chiefComplaintMeta);
    }
    if (data.containsKey('symptoms')) {
      context.handle(_symptomsMeta,
          symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta));
    } else if (isInserting) {
      context.missing(_symptomsMeta);
    }
    if (data.containsKey('diagnosis')) {
      context.handle(_diagnosisMeta,
          diagnosis.isAcceptableOrUnknown(data['diagnosis']!, _diagnosisMeta));
    }
    if (data.containsKey('treatment')) {
      context.handle(_treatmentMeta,
          treatment.isAcceptableOrUnknown(data['treatment']!, _treatmentMeta));
    }
    if (data.containsKey('vital_signs')) {
      context.handle(
          _vitalSignsMeta,
          vitalSigns.isAcceptableOrUnknown(
              data['vital_signs']!, _vitalSignsMeta));
    }
    if (data.containsKey('photos')) {
      context.handle(_photosMeta,
          photos.isAcceptableOrUnknown(data['photos']!, _photosMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Consultation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Consultation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      agentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agent_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      chiefComplaint: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chief_complaint'])!,
      symptoms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptoms'])!,
      diagnosis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}diagnosis']),
      treatment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}treatment']),
      vitalSigns: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vital_signs']),
      photos: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photos']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $ConsultationsTable createAlias(String alias) {
    return $ConsultationsTable(attachedDatabase, alias);
  }
}

class Consultation extends DataClass implements Insertable<Consultation> {
  final String id;
  final String patientId;
  final String agentId;
  final DateTime date;
  final String chiefComplaint;
  final String symptoms;
  final String? diagnosis;
  final String? treatment;
  final String? vitalSigns;
  final String? photos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const Consultation(
      {required this.id,
      required this.patientId,
      required this.agentId,
      required this.date,
      required this.chiefComplaint,
      required this.symptoms,
      this.diagnosis,
      this.treatment,
      this.vitalSigns,
      this.photos,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['agent_id'] = Variable<String>(agentId);
    map['date'] = Variable<DateTime>(date);
    map['chief_complaint'] = Variable<String>(chiefComplaint);
    map['symptoms'] = Variable<String>(symptoms);
    if (!nullToAbsent || diagnosis != null) {
      map['diagnosis'] = Variable<String>(diagnosis);
    }
    if (!nullToAbsent || treatment != null) {
      map['treatment'] = Variable<String>(treatment);
    }
    if (!nullToAbsent || vitalSigns != null) {
      map['vital_signs'] = Variable<String>(vitalSigns);
    }
    if (!nullToAbsent || photos != null) {
      map['photos'] = Variable<String>(photos);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  ConsultationsCompanion toCompanion(bool nullToAbsent) {
    return ConsultationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      agentId: Value(agentId),
      date: Value(date),
      chiefComplaint: Value(chiefComplaint),
      symptoms: Value(symptoms),
      diagnosis: diagnosis == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosis),
      treatment: treatment == null && nullToAbsent
          ? const Value.absent()
          : Value(treatment),
      vitalSigns: vitalSigns == null && nullToAbsent
          ? const Value.absent()
          : Value(vitalSigns),
      photos:
          photos == null && nullToAbsent ? const Value.absent() : Value(photos),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Consultation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Consultation(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      agentId: serializer.fromJson<String>(json['agentId']),
      date: serializer.fromJson<DateTime>(json['date']),
      chiefComplaint: serializer.fromJson<String>(json['chiefComplaint']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      diagnosis: serializer.fromJson<String?>(json['diagnosis']),
      treatment: serializer.fromJson<String?>(json['treatment']),
      vitalSigns: serializer.fromJson<String?>(json['vitalSigns']),
      photos: serializer.fromJson<String?>(json['photos']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'agentId': serializer.toJson<String>(agentId),
      'date': serializer.toJson<DateTime>(date),
      'chiefComplaint': serializer.toJson<String>(chiefComplaint),
      'symptoms': serializer.toJson<String>(symptoms),
      'diagnosis': serializer.toJson<String?>(diagnosis),
      'treatment': serializer.toJson<String?>(treatment),
      'vitalSigns': serializer.toJson<String?>(vitalSigns),
      'photos': serializer.toJson<String?>(photos),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Consultation copyWith(
          {String? id,
          String? patientId,
          String? agentId,
          DateTime? date,
          String? chiefComplaint,
          String? symptoms,
          Value<String?> diagnosis = const Value.absent(),
          Value<String?> treatment = const Value.absent(),
          Value<String?> vitalSigns = const Value.absent(),
          Value<String?> photos = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus}) =>
      Consultation(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        agentId: agentId ?? this.agentId,
        date: date ?? this.date,
        chiefComplaint: chiefComplaint ?? this.chiefComplaint,
        symptoms: symptoms ?? this.symptoms,
        diagnosis: diagnosis.present ? diagnosis.value : this.diagnosis,
        treatment: treatment.present ? treatment.value : this.treatment,
        vitalSigns: vitalSigns.present ? vitalSigns.value : this.vitalSigns,
        photos: photos.present ? photos.value : this.photos,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  Consultation copyWithCompanion(ConsultationsCompanion data) {
    return Consultation(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      agentId: data.agentId.present ? data.agentId.value : this.agentId,
      date: data.date.present ? data.date.value : this.date,
      chiefComplaint: data.chiefComplaint.present
          ? data.chiefComplaint.value
          : this.chiefComplaint,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      diagnosis: data.diagnosis.present ? data.diagnosis.value : this.diagnosis,
      treatment: data.treatment.present ? data.treatment.value : this.treatment,
      vitalSigns:
          data.vitalSigns.present ? data.vitalSigns.value : this.vitalSigns,
      photos: data.photos.present ? data.photos.value : this.photos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Consultation(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('agentId: $agentId, ')
          ..write('date: $date, ')
          ..write('chiefComplaint: $chiefComplaint, ')
          ..write('symptoms: $symptoms, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('treatment: $treatment, ')
          ..write('vitalSigns: $vitalSigns, ')
          ..write('photos: $photos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      agentId,
      date,
      chiefComplaint,
      symptoms,
      diagnosis,
      treatment,
      vitalSigns,
      photos,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Consultation &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.agentId == this.agentId &&
          other.date == this.date &&
          other.chiefComplaint == this.chiefComplaint &&
          other.symptoms == this.symptoms &&
          other.diagnosis == this.diagnosis &&
          other.treatment == this.treatment &&
          other.vitalSigns == this.vitalSigns &&
          other.photos == this.photos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class ConsultationsCompanion extends UpdateCompanion<Consultation> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> agentId;
  final Value<DateTime> date;
  final Value<String> chiefComplaint;
  final Value<String> symptoms;
  final Value<String?> diagnosis;
  final Value<String?> treatment;
  final Value<String?> vitalSigns;
  final Value<String?> photos;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const ConsultationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.agentId = const Value.absent(),
    this.date = const Value.absent(),
    this.chiefComplaint = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.diagnosis = const Value.absent(),
    this.treatment = const Value.absent(),
    this.vitalSigns = const Value.absent(),
    this.photos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsultationsCompanion.insert({
    required String id,
    required String patientId,
    required String agentId,
    required DateTime date,
    required String chiefComplaint,
    required String symptoms,
    this.diagnosis = const Value.absent(),
    this.treatment = const Value.absent(),
    this.vitalSigns = const Value.absent(),
    this.photos = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        agentId = Value(agentId),
        date = Value(date),
        chiefComplaint = Value(chiefComplaint),
        symptoms = Value(symptoms),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Consultation> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? agentId,
    Expression<DateTime>? date,
    Expression<String>? chiefComplaint,
    Expression<String>? symptoms,
    Expression<String>? diagnosis,
    Expression<String>? treatment,
    Expression<String>? vitalSigns,
    Expression<String>? photos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (agentId != null) 'agent_id': agentId,
      if (date != null) 'date': date,
      if (chiefComplaint != null) 'chief_complaint': chiefComplaint,
      if (symptoms != null) 'symptoms': symptoms,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (treatment != null) 'treatment': treatment,
      if (vitalSigns != null) 'vital_signs': vitalSigns,
      if (photos != null) 'photos': photos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsultationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? agentId,
      Value<DateTime>? date,
      Value<String>? chiefComplaint,
      Value<String>? symptoms,
      Value<String?>? diagnosis,
      Value<String?>? treatment,
      Value<String?>? vitalSigns,
      Value<String?>? photos,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return ConsultationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      agentId: agentId ?? this.agentId,
      date: date ?? this.date,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<String>(agentId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (chiefComplaint.present) {
      map['chief_complaint'] = Variable<String>(chiefComplaint.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (diagnosis.present) {
      map['diagnosis'] = Variable<String>(diagnosis.value);
    }
    if (treatment.present) {
      map['treatment'] = Variable<String>(treatment.value);
    }
    if (vitalSigns.present) {
      map['vital_signs'] = Variable<String>(vitalSigns.value);
    }
    if (photos.present) {
      map['photos'] = Variable<String>(photos.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsultationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('agentId: $agentId, ')
          ..write('date: $date, ')
          ..write('chiefComplaint: $chiefComplaint, ')
          ..write('symptoms: $symptoms, ')
          ..write('diagnosis: $diagnosis, ')
          ..write('treatment: $treatment, ')
          ..write('vitalSigns: $vitalSigns, ')
          ..write('photos: $photos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        operation,
        entityType,
        entityId,
        payload,
        createdAt,
        retryCount,
        status,
        errorMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String operation;
  final String entityType;
  final String entityId;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String status;
  final String? errorMessage;
  const SyncQueueData(
      {required this.id,
      required this.operation,
      required this.entityType,
      required this.entityId,
      required this.payload,
      required this.createdAt,
      required this.retryCount,
      required this.status,
      this.errorMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? operation,
          String? entityType,
          String? entityId,
          String? payload,
          DateTime? createdAt,
          int? retryCount,
          String? status,
          Value<String?> errorMessage = const Value.absent()}) =>
      SyncQueueData(
        id: id ?? this.id,
        operation: operation ?? this.operation,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        status: status ?? this.status,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operation, entityType, entityId, payload,
      createdAt, retryCount, status, errorMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<String?> errorMessage;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String entityType,
    required String entityId,
    required String payload,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
  })  : operation = Value(operation),
        entityType = Value(entityType),
        entityId = Value(entityId),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<String>? errorMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? operation,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<String>? status,
      Value<String?>? errorMessage}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }
}

class $CaseReportsTable extends CaseReports
    with TableInfo<$CaseReportsTable, CaseReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaseReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _agentIdMeta =
      const VerificationMeta('agentId');
  @override
  late final GeneratedColumn<String> agentId = GeneratedColumn<String>(
      'agent_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _symptomsMeta =
      const VerificationMeta('symptoms');
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
      'symptoms', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urgencyMeta =
      const VerificationMeta('urgency');
  @override
  late final GeneratedColumn<String> urgency = GeneratedColumn<String>(
      'urgency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _channelMeta =
      const VerificationMeta('channel');
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
      'channel', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('APP'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _doctorIdMeta =
      const VerificationMeta('doctorId');
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
      'doctor_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _responseMeta =
      const VerificationMeta('response');
  @override
  late final GeneratedColumn<String> response = GeneratedColumn<String>(
      'response', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referralMeta =
      const VerificationMeta('referral');
  @override
  late final GeneratedColumn<bool> referral = GeneratedColumn<bool>(
      'referral', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("referral" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
      'zone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resolvedAtMeta =
      const VerificationMeta('resolvedAt');
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
      'resolved_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        agentId,
        patientId,
        symptoms,
        urgency,
        channel,
        status,
        doctorId,
        response,
        referral,
        imageUrl,
        latitude,
        longitude,
        zone,
        resolvedAt,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'case_reports';
  @override
  VerificationContext validateIntegrity(Insertable<CaseReport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('agent_id')) {
      context.handle(_agentIdMeta,
          agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta));
    } else if (isInserting) {
      context.missing(_agentIdMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    }
    if (data.containsKey('symptoms')) {
      context.handle(_symptomsMeta,
          symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta));
    } else if (isInserting) {
      context.missing(_symptomsMeta);
    }
    if (data.containsKey('urgency')) {
      context.handle(_urgencyMeta,
          urgency.isAcceptableOrUnknown(data['urgency']!, _urgencyMeta));
    } else if (isInserting) {
      context.missing(_urgencyMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(_channelMeta,
          channel.isAcceptableOrUnknown(data['channel']!, _channelMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('doctor_id')) {
      context.handle(_doctorIdMeta,
          doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta));
    }
    if (data.containsKey('response')) {
      context.handle(_responseMeta,
          response.isAcceptableOrUnknown(data['response']!, _responseMeta));
    }
    if (data.containsKey('referral')) {
      context.handle(_referralMeta,
          referral.isAcceptableOrUnknown(data['referral']!, _referralMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('zone')) {
      context.handle(
          _zoneMeta, zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta));
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
          _resolvedAtMeta,
          resolvedAt.isAcceptableOrUnknown(
              data['resolved_at']!, _resolvedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaseReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseReport(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      agentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agent_id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id']),
      symptoms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symptoms'])!,
      urgency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}urgency'])!,
      channel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}channel'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      doctorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doctor_id']),
      response: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}response']),
      referral: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}referral'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      zone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zone']),
      resolvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}resolved_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $CaseReportsTable createAlias(String alias) {
    return $CaseReportsTable(attachedDatabase, alias);
  }
}

class CaseReport extends DataClass implements Insertable<CaseReport> {
  final String id;
  final String agentId;
  final String? patientId;
  final String symptoms;
  final String urgency;
  final String channel;
  final String status;
  final String? doctorId;
  final String? response;
  final bool referral;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? zone;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  const CaseReport(
      {required this.id,
      required this.agentId,
      this.patientId,
      required this.symptoms,
      required this.urgency,
      required this.channel,
      required this.status,
      this.doctorId,
      this.response,
      required this.referral,
      this.imageUrl,
      this.latitude,
      this.longitude,
      this.zone,
      this.resolvedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['agent_id'] = Variable<String>(agentId);
    if (!nullToAbsent || patientId != null) {
      map['patient_id'] = Variable<String>(patientId);
    }
    map['symptoms'] = Variable<String>(symptoms);
    map['urgency'] = Variable<String>(urgency);
    map['channel'] = Variable<String>(channel);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || doctorId != null) {
      map['doctor_id'] = Variable<String>(doctorId);
    }
    if (!nullToAbsent || response != null) {
      map['response'] = Variable<String>(response);
    }
    map['referral'] = Variable<bool>(referral);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<String>(zone);
    }
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  CaseReportsCompanion toCompanion(bool nullToAbsent) {
    return CaseReportsCompanion(
      id: Value(id),
      agentId: Value(agentId),
      patientId: patientId == null && nullToAbsent
          ? const Value.absent()
          : Value(patientId),
      symptoms: Value(symptoms),
      urgency: Value(urgency),
      channel: Value(channel),
      status: Value(status),
      doctorId: doctorId == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorId),
      response: response == null && nullToAbsent
          ? const Value.absent()
          : Value(response),
      referral: Value(referral),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory CaseReport.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseReport(
      id: serializer.fromJson<String>(json['id']),
      agentId: serializer.fromJson<String>(json['agentId']),
      patientId: serializer.fromJson<String?>(json['patientId']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      urgency: serializer.fromJson<String>(json['urgency']),
      channel: serializer.fromJson<String>(json['channel']),
      status: serializer.fromJson<String>(json['status']),
      doctorId: serializer.fromJson<String?>(json['doctorId']),
      response: serializer.fromJson<String?>(json['response']),
      referral: serializer.fromJson<bool>(json['referral']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      zone: serializer.fromJson<String?>(json['zone']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'agentId': serializer.toJson<String>(agentId),
      'patientId': serializer.toJson<String?>(patientId),
      'symptoms': serializer.toJson<String>(symptoms),
      'urgency': serializer.toJson<String>(urgency),
      'channel': serializer.toJson<String>(channel),
      'status': serializer.toJson<String>(status),
      'doctorId': serializer.toJson<String?>(doctorId),
      'response': serializer.toJson<String?>(response),
      'referral': serializer.toJson<bool>(referral),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'zone': serializer.toJson<String?>(zone),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  CaseReport copyWith(
          {String? id,
          String? agentId,
          Value<String?> patientId = const Value.absent(),
          String? symptoms,
          String? urgency,
          String? channel,
          String? status,
          Value<String?> doctorId = const Value.absent(),
          Value<String?> response = const Value.absent(),
          bool? referral,
          Value<String?> imageUrl = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<String?> zone = const Value.absent(),
          Value<DateTime?> resolvedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus}) =>
      CaseReport(
        id: id ?? this.id,
        agentId: agentId ?? this.agentId,
        patientId: patientId.present ? patientId.value : this.patientId,
        symptoms: symptoms ?? this.symptoms,
        urgency: urgency ?? this.urgency,
        channel: channel ?? this.channel,
        status: status ?? this.status,
        doctorId: doctorId.present ? doctorId.value : this.doctorId,
        response: response.present ? response.value : this.response,
        referral: referral ?? this.referral,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        zone: zone.present ? zone.value : this.zone,
        resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  CaseReport copyWithCompanion(CaseReportsCompanion data) {
    return CaseReport(
      id: data.id.present ? data.id.value : this.id,
      agentId: data.agentId.present ? data.agentId.value : this.agentId,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      urgency: data.urgency.present ? data.urgency.value : this.urgency,
      channel: data.channel.present ? data.channel.value : this.channel,
      status: data.status.present ? data.status.value : this.status,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      response: data.response.present ? data.response.value : this.response,
      referral: data.referral.present ? data.referral.value : this.referral,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      zone: data.zone.present ? data.zone.value : this.zone,
      resolvedAt:
          data.resolvedAt.present ? data.resolvedAt.value : this.resolvedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseReport(')
          ..write('id: $id, ')
          ..write('agentId: $agentId, ')
          ..write('patientId: $patientId, ')
          ..write('symptoms: $symptoms, ')
          ..write('urgency: $urgency, ')
          ..write('channel: $channel, ')
          ..write('status: $status, ')
          ..write('doctorId: $doctorId, ')
          ..write('response: $response, ')
          ..write('referral: $referral, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('zone: $zone, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      agentId,
      patientId,
      symptoms,
      urgency,
      channel,
      status,
      doctorId,
      response,
      referral,
      imageUrl,
      latitude,
      longitude,
      zone,
      resolvedAt,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseReport &&
          other.id == this.id &&
          other.agentId == this.agentId &&
          other.patientId == this.patientId &&
          other.symptoms == this.symptoms &&
          other.urgency == this.urgency &&
          other.channel == this.channel &&
          other.status == this.status &&
          other.doctorId == this.doctorId &&
          other.response == this.response &&
          other.referral == this.referral &&
          other.imageUrl == this.imageUrl &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.zone == this.zone &&
          other.resolvedAt == this.resolvedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class CaseReportsCompanion extends UpdateCompanion<CaseReport> {
  final Value<String> id;
  final Value<String> agentId;
  final Value<String?> patientId;
  final Value<String> symptoms;
  final Value<String> urgency;
  final Value<String> channel;
  final Value<String> status;
  final Value<String?> doctorId;
  final Value<String?> response;
  final Value<bool> referral;
  final Value<String?> imageUrl;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> zone;
  final Value<DateTime?> resolvedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const CaseReportsCompanion({
    this.id = const Value.absent(),
    this.agentId = const Value.absent(),
    this.patientId = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.urgency = const Value.absent(),
    this.channel = const Value.absent(),
    this.status = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.response = const Value.absent(),
    this.referral = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.zone = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaseReportsCompanion.insert({
    required String id,
    required String agentId,
    this.patientId = const Value.absent(),
    required String symptoms,
    required String urgency,
    this.channel = const Value.absent(),
    this.status = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.response = const Value.absent(),
    this.referral = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.zone = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        agentId = Value(agentId),
        symptoms = Value(symptoms),
        urgency = Value(urgency),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CaseReport> custom({
    Expression<String>? id,
    Expression<String>? agentId,
    Expression<String>? patientId,
    Expression<String>? symptoms,
    Expression<String>? urgency,
    Expression<String>? channel,
    Expression<String>? status,
    Expression<String>? doctorId,
    Expression<String>? response,
    Expression<bool>? referral,
    Expression<String>? imageUrl,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? zone,
    Expression<DateTime>? resolvedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (agentId != null) 'agent_id': agentId,
      if (patientId != null) 'patient_id': patientId,
      if (symptoms != null) 'symptoms': symptoms,
      if (urgency != null) 'urgency': urgency,
      if (channel != null) 'channel': channel,
      if (status != null) 'status': status,
      if (doctorId != null) 'doctor_id': doctorId,
      if (response != null) 'response': response,
      if (referral != null) 'referral': referral,
      if (imageUrl != null) 'image_url': imageUrl,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (zone != null) 'zone': zone,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaseReportsCompanion copyWith(
      {Value<String>? id,
      Value<String>? agentId,
      Value<String?>? patientId,
      Value<String>? symptoms,
      Value<String>? urgency,
      Value<String>? channel,
      Value<String>? status,
      Value<String?>? doctorId,
      Value<String?>? response,
      Value<bool>? referral,
      Value<String?>? imageUrl,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String?>? zone,
      Value<DateTime?>? resolvedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return CaseReportsCompanion(
      id: id ?? this.id,
      agentId: agentId ?? this.agentId,
      patientId: patientId ?? this.patientId,
      symptoms: symptoms ?? this.symptoms,
      urgency: urgency ?? this.urgency,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      doctorId: doctorId ?? this.doctorId,
      response: response ?? this.response,
      referral: referral ?? this.referral,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zone: zone ?? this.zone,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<String>(agentId.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (urgency.present) {
      map['urgency'] = Variable<String>(urgency.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (response.present) {
      map['response'] = Variable<String>(response.value);
    }
    if (referral.present) {
      map['referral'] = Variable<bool>(referral.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaseReportsCompanion(')
          ..write('id: $id, ')
          ..write('agentId: $agentId, ')
          ..write('patientId: $patientId, ')
          ..write('symptoms: $symptoms, ')
          ..write('urgency: $urgency, ')
          ..write('channel: $channel, ')
          ..write('status: $status, ')
          ..write('doctorId: $doctorId, ')
          ..write('response: $response, ')
          ..write('referral: $referral, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('zone: $zone, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalProtocolsTable extends MedicalProtocols
    with TableInfo<$MedicalProtocolsTable, MedicalProtocol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalProtocolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameKrMeta = const VerificationMeta('nameKr');
  @override
  late final GeneratedColumn<String> nameKr = GeneratedColumn<String>(
      'name_kr', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _keywordsMeta =
      const VerificationMeta('keywords');
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
      'keywords', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<String> steps = GeneratedColumn<String>(
      'steps', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urgencyLevelMeta =
      const VerificationMeta('urgencyLevel');
  @override
  late final GeneratedColumn<String> urgencyLevel = GeneratedColumn<String>(
      'urgency_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        nameKr,
        keywords,
        steps,
        urgencyLevel,
        category,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_protocols';
  @override
  VerificationContext validateIntegrity(Insertable<MedicalProtocol> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_kr')) {
      context.handle(_nameKrMeta,
          nameKr.isAcceptableOrUnknown(data['name_kr']!, _nameKrMeta));
    }
    if (data.containsKey('keywords')) {
      context.handle(_keywordsMeta,
          keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta));
    } else if (isInserting) {
      context.missing(_keywordsMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('urgency_level')) {
      context.handle(
          _urgencyLevelMeta,
          urgencyLevel.isAcceptableOrUnknown(
              data['urgency_level']!, _urgencyLevelMeta));
    } else if (isInserting) {
      context.missing(_urgencyLevelMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalProtocol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalProtocol(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameKr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_kr']),
      keywords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords'])!,
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}steps'])!,
      urgencyLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}urgency_level'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MedicalProtocolsTable createAlias(String alias) {
    return $MedicalProtocolsTable(attachedDatabase, alias);
  }
}

class MedicalProtocol extends DataClass implements Insertable<MedicalProtocol> {
  final String id;
  final String name;
  final String? nameKr;
  final String keywords;
  final String steps;
  final String urgencyLevel;
  final String? category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicalProtocol(
      {required this.id,
      required this.name,
      this.nameKr,
      required this.keywords,
      required this.steps,
      required this.urgencyLevel,
      this.category,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameKr != null) {
      map['name_kr'] = Variable<String>(nameKr);
    }
    map['keywords'] = Variable<String>(keywords);
    map['steps'] = Variable<String>(steps);
    map['urgency_level'] = Variable<String>(urgencyLevel);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalProtocolsCompanion toCompanion(bool nullToAbsent) {
    return MedicalProtocolsCompanion(
      id: Value(id),
      name: Value(name),
      nameKr:
          nameKr == null && nullToAbsent ? const Value.absent() : Value(nameKr),
      keywords: Value(keywords),
      steps: Value(steps),
      urgencyLevel: Value(urgencyLevel),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicalProtocol.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalProtocol(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameKr: serializer.fromJson<String?>(json['nameKr']),
      keywords: serializer.fromJson<String>(json['keywords']),
      steps: serializer.fromJson<String>(json['steps']),
      urgencyLevel: serializer.fromJson<String>(json['urgencyLevel']),
      category: serializer.fromJson<String?>(json['category']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameKr': serializer.toJson<String?>(nameKr),
      'keywords': serializer.toJson<String>(keywords),
      'steps': serializer.toJson<String>(steps),
      'urgencyLevel': serializer.toJson<String>(urgencyLevel),
      'category': serializer.toJson<String?>(category),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalProtocol copyWith(
          {String? id,
          String? name,
          Value<String?> nameKr = const Value.absent(),
          String? keywords,
          String? steps,
          String? urgencyLevel,
          Value<String?> category = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MedicalProtocol(
        id: id ?? this.id,
        name: name ?? this.name,
        nameKr: nameKr.present ? nameKr.value : this.nameKr,
        keywords: keywords ?? this.keywords,
        steps: steps ?? this.steps,
        urgencyLevel: urgencyLevel ?? this.urgencyLevel,
        category: category.present ? category.value : this.category,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MedicalProtocol copyWithCompanion(MedicalProtocolsCompanion data) {
    return MedicalProtocol(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameKr: data.nameKr.present ? data.nameKr.value : this.nameKr,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      steps: data.steps.present ? data.steps.value : this.steps,
      urgencyLevel: data.urgencyLevel.present
          ? data.urgencyLevel.value
          : this.urgencyLevel,
      category: data.category.present ? data.category.value : this.category,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalProtocol(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKr: $nameKr, ')
          ..write('keywords: $keywords, ')
          ..write('steps: $steps, ')
          ..write('urgencyLevel: $urgencyLevel, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameKr, keywords, steps,
      urgencyLevel, category, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalProtocol &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameKr == this.nameKr &&
          other.keywords == this.keywords &&
          other.steps == this.steps &&
          other.urgencyLevel == this.urgencyLevel &&
          other.category == this.category &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicalProtocolsCompanion extends UpdateCompanion<MedicalProtocol> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameKr;
  final Value<String> keywords;
  final Value<String> steps;
  final Value<String> urgencyLevel;
  final Value<String?> category;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicalProtocolsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKr = const Value.absent(),
    this.keywords = const Value.absent(),
    this.steps = const Value.absent(),
    this.urgencyLevel = const Value.absent(),
    this.category = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalProtocolsCompanion.insert({
    required String id,
    required String name,
    this.nameKr = const Value.absent(),
    required String keywords,
    required String steps,
    required String urgencyLevel,
    this.category = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        keywords = Value(keywords),
        steps = Value(steps),
        urgencyLevel = Value(urgencyLevel),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MedicalProtocol> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameKr,
    Expression<String>? keywords,
    Expression<String>? steps,
    Expression<String>? urgencyLevel,
    Expression<String>? category,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameKr != null) 'name_kr': nameKr,
      if (keywords != null) 'keywords': keywords,
      if (steps != null) 'steps': steps,
      if (urgencyLevel != null) 'urgency_level': urgencyLevel,
      if (category != null) 'category': category,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalProtocolsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? nameKr,
      Value<String>? keywords,
      Value<String>? steps,
      Value<String>? urgencyLevel,
      Value<String?>? category,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MedicalProtocolsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKr: nameKr ?? this.nameKr,
      keywords: keywords ?? this.keywords,
      steps: steps ?? this.steps,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (nameKr.present) {
      map['name_kr'] = Variable<String>(nameKr.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (steps.present) {
      map['steps'] = Variable<String>(steps.value);
    }
    if (urgencyLevel.present) {
      map['urgency_level'] = Variable<String>(urgencyLevel.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalProtocolsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKr: $nameKr, ')
          ..write('keywords: $keywords, ')
          ..write('steps: $steps, ')
          ..write('urgencyLevel: $urgencyLevel, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaccinationsTable extends Vaccinations
    with TableInfo<$VaccinationsTable, Vaccination> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccinationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vaccineMeta =
      const VerificationMeta('vaccine');
  @override
  late final GeneratedColumn<String> vaccine = GeneratedColumn<String>(
      'vaccine', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doseNumberMeta =
      const VerificationMeta('doseNumber');
  @override
  late final GeneratedColumn<int> doseNumber = GeneratedColumn<int>(
      'dose_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateGivenMeta =
      const VerificationMeta('dateGiven');
  @override
  late final GeneratedColumn<DateTime> dateGiven = GeneratedColumn<DateTime>(
      'date_given', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _batchNumberMeta =
      const VerificationMeta('batchNumber');
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
      'batch_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _agentIdMeta =
      const VerificationMeta('agentId');
  @override
  late final GeneratedColumn<String> agentId = GeneratedColumn<String>(
      'agent_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        vaccine,
        doseNumber,
        dateGiven,
        nextDueDate,
        batchNumber,
        agentId,
        notes,
        createdAt,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccinations';
  @override
  VerificationContext validateIntegrity(Insertable<Vaccination> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('vaccine')) {
      context.handle(_vaccineMeta,
          vaccine.isAcceptableOrUnknown(data['vaccine']!, _vaccineMeta));
    } else if (isInserting) {
      context.missing(_vaccineMeta);
    }
    if (data.containsKey('dose_number')) {
      context.handle(
          _doseNumberMeta,
          doseNumber.isAcceptableOrUnknown(
              data['dose_number']!, _doseNumberMeta));
    } else if (isInserting) {
      context.missing(_doseNumberMeta);
    }
    if (data.containsKey('date_given')) {
      context.handle(_dateGivenMeta,
          dateGiven.isAcceptableOrUnknown(data['date_given']!, _dateGivenMeta));
    } else if (isInserting) {
      context.missing(_dateGivenMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    }
    if (data.containsKey('batch_number')) {
      context.handle(
          _batchNumberMeta,
          batchNumber.isAcceptableOrUnknown(
              data['batch_number']!, _batchNumberMeta));
    }
    if (data.containsKey('agent_id')) {
      context.handle(_agentIdMeta,
          agentId.isAcceptableOrUnknown(data['agent_id']!, _agentIdMeta));
    } else if (isInserting) {
      context.missing(_agentIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vaccination map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vaccination(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      vaccine: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vaccine'])!,
      doseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dose_number'])!,
      dateGiven: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_given'])!,
      nextDueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due_date']),
      batchNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_number']),
      agentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}agent_id'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $VaccinationsTable createAlias(String alias) {
    return $VaccinationsTable(attachedDatabase, alias);
  }
}

class Vaccination extends DataClass implements Insertable<Vaccination> {
  final String id;
  final String patientId;
  final String vaccine;
  final int doseNumber;
  final DateTime dateGiven;
  final DateTime? nextDueDate;
  final String? batchNumber;
  final String agentId;
  final String? notes;
  final DateTime createdAt;
  final bool isSynced;
  const Vaccination(
      {required this.id,
      required this.patientId,
      required this.vaccine,
      required this.doseNumber,
      required this.dateGiven,
      this.nextDueDate,
      this.batchNumber,
      required this.agentId,
      this.notes,
      required this.createdAt,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['vaccine'] = Variable<String>(vaccine);
    map['dose_number'] = Variable<int>(doseNumber);
    map['date_given'] = Variable<DateTime>(dateGiven);
    if (!nullToAbsent || nextDueDate != null) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate);
    }
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    map['agent_id'] = Variable<String>(agentId);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  VaccinationsCompanion toCompanion(bool nullToAbsent) {
    return VaccinationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      vaccine: Value(vaccine),
      doseNumber: Value(doseNumber),
      dateGiven: Value(dateGiven),
      nextDueDate: nextDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueDate),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      agentId: Value(agentId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory Vaccination.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vaccination(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      vaccine: serializer.fromJson<String>(json['vaccine']),
      doseNumber: serializer.fromJson<int>(json['doseNumber']),
      dateGiven: serializer.fromJson<DateTime>(json['dateGiven']),
      nextDueDate: serializer.fromJson<DateTime?>(json['nextDueDate']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      agentId: serializer.fromJson<String>(json['agentId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'vaccine': serializer.toJson<String>(vaccine),
      'doseNumber': serializer.toJson<int>(doseNumber),
      'dateGiven': serializer.toJson<DateTime>(dateGiven),
      'nextDueDate': serializer.toJson<DateTime?>(nextDueDate),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'agentId': serializer.toJson<String>(agentId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Vaccination copyWith(
          {String? id,
          String? patientId,
          String? vaccine,
          int? doseNumber,
          DateTime? dateGiven,
          Value<DateTime?> nextDueDate = const Value.absent(),
          Value<String?> batchNumber = const Value.absent(),
          String? agentId,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          bool? isSynced}) =>
      Vaccination(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        vaccine: vaccine ?? this.vaccine,
        doseNumber: doseNumber ?? this.doseNumber,
        dateGiven: dateGiven ?? this.dateGiven,
        nextDueDate: nextDueDate.present ? nextDueDate.value : this.nextDueDate,
        batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
        agentId: agentId ?? this.agentId,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
      );
  Vaccination copyWithCompanion(VaccinationsCompanion data) {
    return Vaccination(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      vaccine: data.vaccine.present ? data.vaccine.value : this.vaccine,
      doseNumber:
          data.doseNumber.present ? data.doseNumber.value : this.doseNumber,
      dateGiven: data.dateGiven.present ? data.dateGiven.value : this.dateGiven,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      batchNumber:
          data.batchNumber.present ? data.batchNumber.value : this.batchNumber,
      agentId: data.agentId.present ? data.agentId.value : this.agentId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vaccination(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('vaccine: $vaccine, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('dateGiven: $dateGiven, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('agentId: $agentId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, vaccine, doseNumber, dateGiven,
      nextDueDate, batchNumber, agentId, notes, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vaccination &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.vaccine == this.vaccine &&
          other.doseNumber == this.doseNumber &&
          other.dateGiven == this.dateGiven &&
          other.nextDueDate == this.nextDueDate &&
          other.batchNumber == this.batchNumber &&
          other.agentId == this.agentId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class VaccinationsCompanion extends UpdateCompanion<Vaccination> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> vaccine;
  final Value<int> doseNumber;
  final Value<DateTime> dateGiven;
  final Value<DateTime?> nextDueDate;
  final Value<String?> batchNumber;
  final Value<String> agentId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const VaccinationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.vaccine = const Value.absent(),
    this.doseNumber = const Value.absent(),
    this.dateGiven = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.agentId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaccinationsCompanion.insert({
    required String id,
    required String patientId,
    required String vaccine,
    required int doseNumber,
    required DateTime dateGiven,
    this.nextDueDate = const Value.absent(),
    this.batchNumber = const Value.absent(),
    required String agentId,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        vaccine = Value(vaccine),
        doseNumber = Value(doseNumber),
        dateGiven = Value(dateGiven),
        agentId = Value(agentId),
        createdAt = Value(createdAt);
  static Insertable<Vaccination> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? vaccine,
    Expression<int>? doseNumber,
    Expression<DateTime>? dateGiven,
    Expression<DateTime>? nextDueDate,
    Expression<String>? batchNumber,
    Expression<String>? agentId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (vaccine != null) 'vaccine': vaccine,
      if (doseNumber != null) 'dose_number': doseNumber,
      if (dateGiven != null) 'date_given': dateGiven,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (agentId != null) 'agent_id': agentId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaccinationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? vaccine,
      Value<int>? doseNumber,
      Value<DateTime>? dateGiven,
      Value<DateTime?>? nextDueDate,
      Value<String?>? batchNumber,
      Value<String>? agentId,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return VaccinationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      vaccine: vaccine ?? this.vaccine,
      doseNumber: doseNumber ?? this.doseNumber,
      dateGiven: dateGiven ?? this.dateGiven,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      batchNumber: batchNumber ?? this.batchNumber,
      agentId: agentId ?? this.agentId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (vaccine.present) {
      map['vaccine'] = Variable<String>(vaccine.value);
    }
    if (doseNumber.present) {
      map['dose_number'] = Variable<int>(doseNumber.value);
    }
    if (dateGiven.present) {
      map['date_given'] = Variable<DateTime>(dateGiven.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (agentId.present) {
      map['agent_id'] = Variable<String>(agentId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccinationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('vaccine: $vaccine, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('dateGiven: $dateGiven, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('agentId: $agentId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $HouseholdMembersTable householdMembers =
      $HouseholdMembersTable(this);
  late final $ConsultationsTable consultations = $ConsultationsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $CaseReportsTable caseReports = $CaseReportsTable(this);
  late final $MedicalProtocolsTable medicalProtocols =
      $MedicalProtocolsTable(this);
  late final $VaccinationsTable vaccinations = $VaccinationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        patients,
        households,
        householdMembers,
        consultations,
        syncQueue,
        caseReports,
        medicalProtocols,
        vaccinations
      ];
}

typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String id,
  required String firstName,
  required String lastName,
  required DateTime dateOfBirth,
  required String gender,
  required String address,
  Value<String?> phone,
  Value<String?> nationalId,
  Value<String?> householdId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<DateTime> dateOfBirth,
  Value<String> gender,
  Value<String> address,
  Value<String?> phone,
  Value<String?> nationalId,
  Value<String?> householdId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get nationalId => $composableBuilder(
      column: $table.nationalId, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, BaseReferences<_$AppDatabase, $PatientsTable, Patient>),
    Patient,
    PrefetchHooks Function()> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<DateTime> dateOfBirth = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> nationalId = const Value.absent(),
            Value<String?> householdId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            address: address,
            phone: phone,
            nationalId: nationalId,
            householdId: householdId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            required String lastName,
            required DateTime dateOfBirth,
            required String gender,
            required String address,
            Value<String?> phone = const Value.absent(),
            Value<String?> nationalId = const Value.absent(),
            Value<String?> householdId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            address: address,
            phone: phone,
            nationalId: nationalId,
            householdId: householdId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, BaseReferences<_$AppDatabase, $PatientsTable, Patient>),
    Patient,
    PrefetchHooks Function()>;
typedef $$HouseholdsTableCreateCompanionBuilder = HouseholdsCompanion Function({
  required String id,
  required String householdHeadName,
  required String address,
  Value<String?> neighborhood,
  Value<String?> commune,
  Value<String?> phone,
  Value<double?> gpsLat,
  Value<double?> gpsLng,
  Value<double?> gpsAccuracy,
  required String zone,
  Value<String?> housingType,
  Value<int?> numberOfRooms,
  Value<String?> waterSource,
  Value<String?> sanitationType,
  Value<bool> hasElectricity,
  Value<int> memberCount,
  required String agentId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$HouseholdsTableUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<String> id,
  Value<String> householdHeadName,
  Value<String> address,
  Value<String?> neighborhood,
  Value<String?> commune,
  Value<String?> phone,
  Value<double?> gpsLat,
  Value<double?> gpsLng,
  Value<double?> gpsAccuracy,
  Value<String> zone,
  Value<String?> housingType,
  Value<int?> numberOfRooms,
  Value<String?> waterSource,
  Value<String?> sanitationType,
  Value<bool> hasElectricity,
  Value<int> memberCount,
  Value<String> agentId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdHeadName => $composableBuilder(
      column: $table.householdHeadName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get neighborhood => $composableBuilder(
      column: $table.neighborhood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commune => $composableBuilder(
      column: $table.commune, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsLat => $composableBuilder(
      column: $table.gpsLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsLng => $composableBuilder(
      column: $table.gpsLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get gpsAccuracy => $composableBuilder(
      column: $table.gpsAccuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zone => $composableBuilder(
      column: $table.zone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get housingType => $composableBuilder(
      column: $table.housingType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numberOfRooms => $composableBuilder(
      column: $table.numberOfRooms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get waterSource => $composableBuilder(
      column: $table.waterSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sanitationType => $composableBuilder(
      column: $table.sanitationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasElectricity => $composableBuilder(
      column: $table.hasElectricity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdHeadName => $composableBuilder(
      column: $table.householdHeadName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get neighborhood => $composableBuilder(
      column: $table.neighborhood,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commune => $composableBuilder(
      column: $table.commune, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsLat => $composableBuilder(
      column: $table.gpsLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsLng => $composableBuilder(
      column: $table.gpsLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get gpsAccuracy => $composableBuilder(
      column: $table.gpsAccuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zone => $composableBuilder(
      column: $table.zone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get housingType => $composableBuilder(
      column: $table.housingType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numberOfRooms => $composableBuilder(
      column: $table.numberOfRooms,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get waterSource => $composableBuilder(
      column: $table.waterSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sanitationType => $composableBuilder(
      column: $table.sanitationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasElectricity => $composableBuilder(
      column: $table.hasElectricity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdHeadName => $composableBuilder(
      column: $table.householdHeadName, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get neighborhood => $composableBuilder(
      column: $table.neighborhood, builder: (column) => column);

  GeneratedColumn<String> get commune =>
      $composableBuilder(column: $table.commune, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get gpsLat =>
      $composableBuilder(column: $table.gpsLat, builder: (column) => column);

  GeneratedColumn<double> get gpsLng =>
      $composableBuilder(column: $table.gpsLng, builder: (column) => column);

  GeneratedColumn<double> get gpsAccuracy => $composableBuilder(
      column: $table.gpsAccuracy, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get housingType => $composableBuilder(
      column: $table.housingType, builder: (column) => column);

  GeneratedColumn<int> get numberOfRooms => $composableBuilder(
      column: $table.numberOfRooms, builder: (column) => column);

  GeneratedColumn<String> get waterSource => $composableBuilder(
      column: $table.waterSource, builder: (column) => column);

  GeneratedColumn<String> get sanitationType => $composableBuilder(
      column: $table.sanitationType, builder: (column) => column);

  GeneratedColumn<bool> get hasElectricity => $composableBuilder(
      column: $table.hasElectricity, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
      column: $table.memberCount, builder: (column) => column);

  GeneratedColumn<String> get agentId =>
      $composableBuilder(column: $table.agentId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$HouseholdsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, BaseReferences<_$AppDatabase, $HouseholdsTable, Household>),
    Household,
    PrefetchHooks Function()> {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdHeadName = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String?> neighborhood = const Value.absent(),
            Value<String?> commune = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double?> gpsLat = const Value.absent(),
            Value<double?> gpsLng = const Value.absent(),
            Value<double?> gpsAccuracy = const Value.absent(),
            Value<String> zone = const Value.absent(),
            Value<String?> housingType = const Value.absent(),
            Value<int?> numberOfRooms = const Value.absent(),
            Value<String?> waterSource = const Value.absent(),
            Value<String?> sanitationType = const Value.absent(),
            Value<bool> hasElectricity = const Value.absent(),
            Value<int> memberCount = const Value.absent(),
            Value<String> agentId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion(
            id: id,
            householdHeadName: householdHeadName,
            address: address,
            neighborhood: neighborhood,
            commune: commune,
            phone: phone,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            gpsAccuracy: gpsAccuracy,
            zone: zone,
            housingType: housingType,
            numberOfRooms: numberOfRooms,
            waterSource: waterSource,
            sanitationType: sanitationType,
            hasElectricity: hasElectricity,
            memberCount: memberCount,
            agentId: agentId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdHeadName,
            required String address,
            Value<String?> neighborhood = const Value.absent(),
            Value<String?> commune = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<double?> gpsLat = const Value.absent(),
            Value<double?> gpsLng = const Value.absent(),
            Value<double?> gpsAccuracy = const Value.absent(),
            required String zone,
            Value<String?> housingType = const Value.absent(),
            Value<int?> numberOfRooms = const Value.absent(),
            Value<String?> waterSource = const Value.absent(),
            Value<String?> sanitationType = const Value.absent(),
            Value<bool> hasElectricity = const Value.absent(),
            Value<int> memberCount = const Value.absent(),
            required String agentId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion.insert(
            id: id,
            householdHeadName: householdHeadName,
            address: address,
            neighborhood: neighborhood,
            commune: commune,
            phone: phone,
            gpsLat: gpsLat,
            gpsLng: gpsLng,
            gpsAccuracy: gpsAccuracy,
            zone: zone,
            housingType: housingType,
            numberOfRooms: numberOfRooms,
            waterSource: waterSource,
            sanitationType: sanitationType,
            hasElectricity: hasElectricity,
            memberCount: memberCount,
            agentId: agentId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, BaseReferences<_$AppDatabase, $HouseholdsTable, Household>),
    Household,
    PrefetchHooks Function()>;
typedef $$HouseholdMembersTableCreateCompanionBuilder
    = HouseholdMembersCompanion Function({
  required String id,
  required String householdId,
  required String fullName,
  required DateTime dateOfBirth,
  required String gender,
  required String relationshipToHead,
  Value<String?> educationLevel,
  Value<String?> occupation,
  Value<bool> hasHealthInsurance,
  Value<String?> insuranceProvider,
  Value<String?> chronicConditions,
  Value<String?> patientId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$HouseholdMembersTableUpdateCompanionBuilder
    = HouseholdMembersCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> fullName,
  Value<DateTime> dateOfBirth,
  Value<String> gender,
  Value<String> relationshipToHead,
  Value<String?> educationLevel,
  Value<String?> occupation,
  Value<bool> hasHealthInsurance,
  Value<String?> insuranceProvider,
  Value<String?> chronicConditions,
  Value<String?> patientId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$HouseholdMembersTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationshipToHead => $composableBuilder(
      column: $table.relationshipToHead,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get educationLevel => $composableBuilder(
      column: $table.educationLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get occupation => $composableBuilder(
      column: $table.occupation, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasHealthInsurance => $composableBuilder(
      column: $table.hasHealthInsurance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get insuranceProvider => $composableBuilder(
      column: $table.insuranceProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$HouseholdMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationshipToHead => $composableBuilder(
      column: $table.relationshipToHead,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get educationLevel => $composableBuilder(
      column: $table.educationLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get occupation => $composableBuilder(
      column: $table.occupation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasHealthInsurance => $composableBuilder(
      column: $table.hasHealthInsurance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get insuranceProvider => $composableBuilder(
      column: $table.insuranceProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get householdId => $composableBuilder(
      column: $table.householdId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get relationshipToHead => $composableBuilder(
      column: $table.relationshipToHead, builder: (column) => column);

  GeneratedColumn<String> get educationLevel => $composableBuilder(
      column: $table.educationLevel, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(
      column: $table.occupation, builder: (column) => column);

  GeneratedColumn<bool> get hasHealthInsurance => $composableBuilder(
      column: $table.hasHealthInsurance, builder: (column) => column);

  GeneratedColumn<String> get insuranceProvider => $composableBuilder(
      column: $table.insuranceProvider, builder: (column) => column);

  GeneratedColumn<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$HouseholdMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdMembersTable,
    HouseholdMember,
    $$HouseholdMembersTableFilterComposer,
    $$HouseholdMembersTableOrderingComposer,
    $$HouseholdMembersTableAnnotationComposer,
    $$HouseholdMembersTableCreateCompanionBuilder,
    $$HouseholdMembersTableUpdateCompanionBuilder,
    (
      HouseholdMember,
      BaseReferences<_$AppDatabase, $HouseholdMembersTable, HouseholdMember>
    ),
    HouseholdMember,
    PrefetchHooks Function()> {
  $$HouseholdMembersTableTableManager(
      _$AppDatabase db, $HouseholdMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<DateTime> dateOfBirth = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<String> relationshipToHead = const Value.absent(),
            Value<String?> educationLevel = const Value.absent(),
            Value<String?> occupation = const Value.absent(),
            Value<bool> hasHealthInsurance = const Value.absent(),
            Value<String?> insuranceProvider = const Value.absent(),
            Value<String?> chronicConditions = const Value.absent(),
            Value<String?> patientId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdMembersCompanion(
            id: id,
            householdId: householdId,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            relationshipToHead: relationshipToHead,
            educationLevel: educationLevel,
            occupation: occupation,
            hasHealthInsurance: hasHealthInsurance,
            insuranceProvider: insuranceProvider,
            chronicConditions: chronicConditions,
            patientId: patientId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String fullName,
            required DateTime dateOfBirth,
            required String gender,
            required String relationshipToHead,
            Value<String?> educationLevel = const Value.absent(),
            Value<String?> occupation = const Value.absent(),
            Value<bool> hasHealthInsurance = const Value.absent(),
            Value<String?> insuranceProvider = const Value.absent(),
            Value<String?> chronicConditions = const Value.absent(),
            Value<String?> patientId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdMembersCompanion.insert(
            id: id,
            householdId: householdId,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            relationshipToHead: relationshipToHead,
            educationLevel: educationLevel,
            occupation: occupation,
            hasHealthInsurance: hasHealthInsurance,
            insuranceProvider: insuranceProvider,
            chronicConditions: chronicConditions,
            patientId: patientId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HouseholdMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdMembersTable,
    HouseholdMember,
    $$HouseholdMembersTableFilterComposer,
    $$HouseholdMembersTableOrderingComposer,
    $$HouseholdMembersTableAnnotationComposer,
    $$HouseholdMembersTableCreateCompanionBuilder,
    $$HouseholdMembersTableUpdateCompanionBuilder,
    (
      HouseholdMember,
      BaseReferences<_$AppDatabase, $HouseholdMembersTable, HouseholdMember>
    ),
    HouseholdMember,
    PrefetchHooks Function()>;
typedef $$ConsultationsTableCreateCompanionBuilder = ConsultationsCompanion
    Function({
  required String id,
  required String patientId,
  required String agentId,
  required DateTime date,
  required String chiefComplaint,
  required String symptoms,
  Value<String?> diagnosis,
  Value<String?> treatment,
  Value<String?> vitalSigns,
  Value<String?> photos,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$ConsultationsTableUpdateCompanionBuilder = ConsultationsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> agentId,
  Value<DateTime> date,
  Value<String> chiefComplaint,
  Value<String> symptoms,
  Value<String?> diagnosis,
  Value<String?> treatment,
  Value<String?> vitalSigns,
  Value<String?> photos,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$ConsultationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsultationsTable> {
  $$ConsultationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chiefComplaint => $composableBuilder(
      column: $table.chiefComplaint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagnosis => $composableBuilder(
      column: $table.diagnosis, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get treatment => $composableBuilder(
      column: $table.treatment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vitalSigns => $composableBuilder(
      column: $table.vitalSigns, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photos => $composableBuilder(
      column: $table.photos, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$ConsultationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsultationsTable> {
  $$ConsultationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chiefComplaint => $composableBuilder(
      column: $table.chiefComplaint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagnosis => $composableBuilder(
      column: $table.diagnosis, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get treatment => $composableBuilder(
      column: $table.treatment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vitalSigns => $composableBuilder(
      column: $table.vitalSigns, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photos => $composableBuilder(
      column: $table.photos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$ConsultationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsultationsTable> {
  $$ConsultationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get agentId =>
      $composableBuilder(column: $table.agentId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get chiefComplaint => $composableBuilder(
      column: $table.chiefComplaint, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get diagnosis =>
      $composableBuilder(column: $table.diagnosis, builder: (column) => column);

  GeneratedColumn<String> get treatment =>
      $composableBuilder(column: $table.treatment, builder: (column) => column);

  GeneratedColumn<String> get vitalSigns => $composableBuilder(
      column: $table.vitalSigns, builder: (column) => column);

  GeneratedColumn<String> get photos =>
      $composableBuilder(column: $table.photos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$ConsultationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConsultationsTable,
    Consultation,
    $$ConsultationsTableFilterComposer,
    $$ConsultationsTableOrderingComposer,
    $$ConsultationsTableAnnotationComposer,
    $$ConsultationsTableCreateCompanionBuilder,
    $$ConsultationsTableUpdateCompanionBuilder,
    (
      Consultation,
      BaseReferences<_$AppDatabase, $ConsultationsTable, Consultation>
    ),
    Consultation,
    PrefetchHooks Function()> {
  $$ConsultationsTableTableManager(_$AppDatabase db, $ConsultationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsultationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsultationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsultationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> agentId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> chiefComplaint = const Value.absent(),
            Value<String> symptoms = const Value.absent(),
            Value<String?> diagnosis = const Value.absent(),
            Value<String?> treatment = const Value.absent(),
            Value<String?> vitalSigns = const Value.absent(),
            Value<String?> photos = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConsultationsCompanion(
            id: id,
            patientId: patientId,
            agentId: agentId,
            date: date,
            chiefComplaint: chiefComplaint,
            symptoms: symptoms,
            diagnosis: diagnosis,
            treatment: treatment,
            vitalSigns: vitalSigns,
            photos: photos,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String agentId,
            required DateTime date,
            required String chiefComplaint,
            required String symptoms,
            Value<String?> diagnosis = const Value.absent(),
            Value<String?> treatment = const Value.absent(),
            Value<String?> vitalSigns = const Value.absent(),
            Value<String?> photos = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConsultationsCompanion.insert(
            id: id,
            patientId: patientId,
            agentId: agentId,
            date: date,
            chiefComplaint: chiefComplaint,
            symptoms: symptoms,
            diagnosis: diagnosis,
            treatment: treatment,
            vitalSigns: vitalSigns,
            photos: photos,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConsultationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConsultationsTable,
    Consultation,
    $$ConsultationsTableFilterComposer,
    $$ConsultationsTableOrderingComposer,
    $$ConsultationsTableAnnotationComposer,
    $$ConsultationsTableCreateCompanionBuilder,
    $$ConsultationsTableUpdateCompanionBuilder,
    (
      Consultation,
      BaseReferences<_$AppDatabase, $ConsultationsTable, Consultation>
    ),
    Consultation,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String operation,
  required String entityType,
  required String entityId,
  required String payload,
  required DateTime createdAt,
  Value<int> retryCount,
  Value<String> status,
  Value<String?> errorMessage,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> operation,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String> status,
  Value<String?> errorMessage,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            operation: operation,
            entityType: entityType,
            entityId: entityId,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            status: status,
            errorMessage: errorMessage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String operation,
            required String entityType,
            required String entityId,
            required String payload,
            required DateTime createdAt,
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            operation: operation,
            entityType: entityType,
            entityId: entityId,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            status: status,
            errorMessage: errorMessage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$CaseReportsTableCreateCompanionBuilder = CaseReportsCompanion
    Function({
  required String id,
  required String agentId,
  Value<String?> patientId,
  required String symptoms,
  required String urgency,
  Value<String> channel,
  Value<String> status,
  Value<String?> doctorId,
  Value<String?> response,
  Value<bool> referral,
  Value<String?> imageUrl,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> zone,
  Value<DateTime?> resolvedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$CaseReportsTableUpdateCompanionBuilder = CaseReportsCompanion
    Function({
  Value<String> id,
  Value<String> agentId,
  Value<String?> patientId,
  Value<String> symptoms,
  Value<String> urgency,
  Value<String> channel,
  Value<String> status,
  Value<String?> doctorId,
  Value<String?> response,
  Value<bool> referral,
  Value<String?> imageUrl,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> zone,
  Value<DateTime?> resolvedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$CaseReportsTableFilterComposer
    extends Composer<_$AppDatabase, $CaseReportsTable> {
  $$CaseReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get urgency => $composableBuilder(
      column: $table.urgency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get doctorId => $composableBuilder(
      column: $table.doctorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get response => $composableBuilder(
      column: $table.response, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get referral => $composableBuilder(
      column: $table.referral, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zone => $composableBuilder(
      column: $table.zone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$CaseReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $CaseReportsTable> {
  $$CaseReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symptoms => $composableBuilder(
      column: $table.symptoms, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urgency => $composableBuilder(
      column: $table.urgency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get channel => $composableBuilder(
      column: $table.channel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get doctorId => $composableBuilder(
      column: $table.doctorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get response => $composableBuilder(
      column: $table.response, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get referral => $composableBuilder(
      column: $table.referral, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zone => $composableBuilder(
      column: $table.zone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$CaseReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaseReportsTable> {
  $$CaseReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get agentId =>
      $composableBuilder(column: $table.agentId, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get urgency =>
      $composableBuilder(column: $table.urgency, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get doctorId =>
      $composableBuilder(column: $table.doctorId, builder: (column) => column);

  GeneratedColumn<String> get response =>
      $composableBuilder(column: $table.response, builder: (column) => column);

  GeneratedColumn<bool> get referral =>
      $composableBuilder(column: $table.referral, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
      column: $table.resolvedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$CaseReportsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CaseReportsTable,
    CaseReport,
    $$CaseReportsTableFilterComposer,
    $$CaseReportsTableOrderingComposer,
    $$CaseReportsTableAnnotationComposer,
    $$CaseReportsTableCreateCompanionBuilder,
    $$CaseReportsTableUpdateCompanionBuilder,
    (CaseReport, BaseReferences<_$AppDatabase, $CaseReportsTable, CaseReport>),
    CaseReport,
    PrefetchHooks Function()> {
  $$CaseReportsTableTableManager(_$AppDatabase db, $CaseReportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaseReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaseReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaseReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> agentId = const Value.absent(),
            Value<String?> patientId = const Value.absent(),
            Value<String> symptoms = const Value.absent(),
            Value<String> urgency = const Value.absent(),
            Value<String> channel = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> doctorId = const Value.absent(),
            Value<String?> response = const Value.absent(),
            Value<bool> referral = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> zone = const Value.absent(),
            Value<DateTime?> resolvedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CaseReportsCompanion(
            id: id,
            agentId: agentId,
            patientId: patientId,
            symptoms: symptoms,
            urgency: urgency,
            channel: channel,
            status: status,
            doctorId: doctorId,
            response: response,
            referral: referral,
            imageUrl: imageUrl,
            latitude: latitude,
            longitude: longitude,
            zone: zone,
            resolvedAt: resolvedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String agentId,
            Value<String?> patientId = const Value.absent(),
            required String symptoms,
            required String urgency,
            Value<String> channel = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> doctorId = const Value.absent(),
            Value<String?> response = const Value.absent(),
            Value<bool> referral = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> zone = const Value.absent(),
            Value<DateTime?> resolvedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CaseReportsCompanion.insert(
            id: id,
            agentId: agentId,
            patientId: patientId,
            symptoms: symptoms,
            urgency: urgency,
            channel: channel,
            status: status,
            doctorId: doctorId,
            response: response,
            referral: referral,
            imageUrl: imageUrl,
            latitude: latitude,
            longitude: longitude,
            zone: zone,
            resolvedAt: resolvedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CaseReportsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CaseReportsTable,
    CaseReport,
    $$CaseReportsTableFilterComposer,
    $$CaseReportsTableOrderingComposer,
    $$CaseReportsTableAnnotationComposer,
    $$CaseReportsTableCreateCompanionBuilder,
    $$CaseReportsTableUpdateCompanionBuilder,
    (CaseReport, BaseReferences<_$AppDatabase, $CaseReportsTable, CaseReport>),
    CaseReport,
    PrefetchHooks Function()>;
typedef $$MedicalProtocolsTableCreateCompanionBuilder
    = MedicalProtocolsCompanion Function({
  required String id,
  required String name,
  Value<String?> nameKr,
  required String keywords,
  required String steps,
  required String urgencyLevel,
  Value<String?> category,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MedicalProtocolsTableUpdateCompanionBuilder
    = MedicalProtocolsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> nameKr,
  Value<String> keywords,
  Value<String> steps,
  Value<String> urgencyLevel,
  Value<String?> category,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MedicalProtocolsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalProtocolsTable> {
  $$MedicalProtocolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKr => $composableBuilder(
      column: $table.nameKr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get urgencyLevel => $composableBuilder(
      column: $table.urgencyLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MedicalProtocolsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalProtocolsTable> {
  $$MedicalProtocolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKr => $composableBuilder(
      column: $table.nameKr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get urgencyLevel => $composableBuilder(
      column: $table.urgencyLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicalProtocolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalProtocolsTable> {
  $$MedicalProtocolsTableAnnotationComposer({
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

  GeneratedColumn<String> get nameKr =>
      $composableBuilder(column: $table.nameKr, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get urgencyLevel => $composableBuilder(
      column: $table.urgencyLevel, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicalProtocolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicalProtocolsTable,
    MedicalProtocol,
    $$MedicalProtocolsTableFilterComposer,
    $$MedicalProtocolsTableOrderingComposer,
    $$MedicalProtocolsTableAnnotationComposer,
    $$MedicalProtocolsTableCreateCompanionBuilder,
    $$MedicalProtocolsTableUpdateCompanionBuilder,
    (
      MedicalProtocol,
      BaseReferences<_$AppDatabase, $MedicalProtocolsTable, MedicalProtocol>
    ),
    MedicalProtocol,
    PrefetchHooks Function()> {
  $$MedicalProtocolsTableTableManager(
      _$AppDatabase db, $MedicalProtocolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalProtocolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalProtocolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalProtocolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameKr = const Value.absent(),
            Value<String> keywords = const Value.absent(),
            Value<String> steps = const Value.absent(),
            Value<String> urgencyLevel = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicalProtocolsCompanion(
            id: id,
            name: name,
            nameKr: nameKr,
            keywords: keywords,
            steps: steps,
            urgencyLevel: urgencyLevel,
            category: category,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> nameKr = const Value.absent(),
            required String keywords,
            required String steps,
            required String urgencyLevel,
            Value<String?> category = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicalProtocolsCompanion.insert(
            id: id,
            name: name,
            nameKr: nameKr,
            keywords: keywords,
            steps: steps,
            urgencyLevel: urgencyLevel,
            category: category,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicalProtocolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicalProtocolsTable,
    MedicalProtocol,
    $$MedicalProtocolsTableFilterComposer,
    $$MedicalProtocolsTableOrderingComposer,
    $$MedicalProtocolsTableAnnotationComposer,
    $$MedicalProtocolsTableCreateCompanionBuilder,
    $$MedicalProtocolsTableUpdateCompanionBuilder,
    (
      MedicalProtocol,
      BaseReferences<_$AppDatabase, $MedicalProtocolsTable, MedicalProtocol>
    ),
    MedicalProtocol,
    PrefetchHooks Function()>;
typedef $$VaccinationsTableCreateCompanionBuilder = VaccinationsCompanion
    Function({
  required String id,
  required String patientId,
  required String vaccine,
  required int doseNumber,
  required DateTime dateGiven,
  Value<DateTime?> nextDueDate,
  Value<String?> batchNumber,
  required String agentId,
  Value<String?> notes,
  required DateTime createdAt,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$VaccinationsTableUpdateCompanionBuilder = VaccinationsCompanion
    Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> vaccine,
  Value<int> doseNumber,
  Value<DateTime> dateGiven,
  Value<DateTime?> nextDueDate,
  Value<String?> batchNumber,
  Value<String> agentId,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$VaccinationsTableFilterComposer
    extends Composer<_$AppDatabase, $VaccinationsTable> {
  $$VaccinationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vaccine => $composableBuilder(
      column: $table.vaccine, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateGiven => $composableBuilder(
      column: $table.dateGiven, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));
}

class $$VaccinationsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccinationsTable> {
  $$VaccinationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vaccine => $composableBuilder(
      column: $table.vaccine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateGiven => $composableBuilder(
      column: $table.dateGiven, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get agentId => $composableBuilder(
      column: $table.agentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));
}

class $$VaccinationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccinationsTable> {
  $$VaccinationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get vaccine =>
      $composableBuilder(column: $table.vaccine, builder: (column) => column);

  GeneratedColumn<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get dateGiven =>
      $composableBuilder(column: $table.dateGiven, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => column);

  GeneratedColumn<String> get agentId =>
      $composableBuilder(column: $table.agentId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$VaccinationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VaccinationsTable,
    Vaccination,
    $$VaccinationsTableFilterComposer,
    $$VaccinationsTableOrderingComposer,
    $$VaccinationsTableAnnotationComposer,
    $$VaccinationsTableCreateCompanionBuilder,
    $$VaccinationsTableUpdateCompanionBuilder,
    (
      Vaccination,
      BaseReferences<_$AppDatabase, $VaccinationsTable, Vaccination>
    ),
    Vaccination,
    PrefetchHooks Function()> {
  $$VaccinationsTableTableManager(_$AppDatabase db, $VaccinationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccinationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccinationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccinationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> vaccine = const Value.absent(),
            Value<int> doseNumber = const Value.absent(),
            Value<DateTime> dateGiven = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<String> agentId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinationsCompanion(
            id: id,
            patientId: patientId,
            vaccine: vaccine,
            doseNumber: doseNumber,
            dateGiven: dateGiven,
            nextDueDate: nextDueDate,
            batchNumber: batchNumber,
            agentId: agentId,
            notes: notes,
            createdAt: createdAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String vaccine,
            required int doseNumber,
            required DateTime dateGiven,
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            required String agentId,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinationsCompanion.insert(
            id: id,
            patientId: patientId,
            vaccine: vaccine,
            doseNumber: doseNumber,
            dateGiven: dateGiven,
            nextDueDate: nextDueDate,
            batchNumber: batchNumber,
            agentId: agentId,
            notes: notes,
            createdAt: createdAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaccinationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VaccinationsTable,
    Vaccination,
    $$VaccinationsTableFilterComposer,
    $$VaccinationsTableOrderingComposer,
    $$VaccinationsTableAnnotationComposer,
    $$VaccinationsTableCreateCompanionBuilder,
    $$VaccinationsTableUpdateCompanionBuilder,
    (
      Vaccination,
      BaseReferences<_$AppDatabase, $VaccinationsTable, Vaccination>
    ),
    Vaccination,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$HouseholdMembersTableTableManager get householdMembers =>
      $$HouseholdMembersTableTableManager(_db, _db.householdMembers);
  $$ConsultationsTableTableManager get consultations =>
      $$ConsultationsTableTableManager(_db, _db.consultations);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$CaseReportsTableTableManager get caseReports =>
      $$CaseReportsTableTableManager(_db, _db.caseReports);
  $$MedicalProtocolsTableTableManager get medicalProtocols =>
      $$MedicalProtocolsTableTableManager(_db, _db.medicalProtocols);
  $$VaccinationsTableTableManager get vaccinations =>
      $$VaccinationsTableTableManager(_db, _db.vaccinations);
}
