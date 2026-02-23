import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../constants/app_constants.dart';

part 'app_database.g.dart';

// Tables
class Patients extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get gender => text()();
  TextColumn get address => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get nationalId => text().nullable()();
  TextColumn get householdId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Households extends Table {
  TextColumn get id => text()();
  TextColumn get householdHeadName => text()();
  TextColumn get address => text()();
  TextColumn get neighborhood => text().nullable()();
  TextColumn get commune => text().nullable()();
  TextColumn get phone => text().nullable()();
  RealColumn get gpsLat => real().nullable()();
  RealColumn get gpsLng => real().nullable()();
  RealColumn get gpsAccuracy => real().nullable()();
  TextColumn get zone => text()();
  TextColumn get housingType => text().nullable()();
  IntColumn get numberOfRooms => integer().nullable()();
  TextColumn get waterSource => text().nullable()();
  TextColumn get sanitationType => text().nullable()();
  BoolColumn get hasElectricity => boolean().withDefault(const Constant(false))();
  IntColumn get memberCount => integer().withDefault(const Constant(0))();
  TextColumn get agentId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class HouseholdMembers extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text()();
  TextColumn get fullName => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get gender => text()();
  TextColumn get relationshipToHead => text()();
  TextColumn get educationLevel => text().nullable()();
  TextColumn get occupation => text().nullable()();
  BoolColumn get hasHealthInsurance => boolean().withDefault(const Constant(false))();
  TextColumn get insuranceProvider => text().nullable()();
  TextColumn get chronicConditions => text().nullable()(); // JSON array
  TextColumn get patientId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Consultations extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get agentId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get chiefComplaint => text()();
  TextColumn get symptoms => text()(); // JSON array
  TextColumn get diagnosis => text().nullable()();
  TextColumn get treatment => text().nullable()();
  TextColumn get vitalSigns => text().nullable()(); // JSON object
  TextColumn get photos => text().nullable()(); // JSON array of paths
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operation => text()(); // CREATE, UPDATE, DELETE
  TextColumn get entityType => text()(); // Patient, Household, Consultation, CaseReport
  TextColumn get entityId => text()();
  TextColumn get payload => text()(); // JSON
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get errorMessage => text().nullable()();
}

class CaseReports extends Table {
  TextColumn get id => text()();
  TextColumn get agentId => text()();
  TextColumn get patientId => text().nullable()();
  TextColumn get symptoms => text()();
  TextColumn get urgency => text()(); // NORMAL, URGENT, CRITICAL
  TextColumn get channel => text().withDefault(const Constant('APP'))();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  TextColumn get doctorId => text().nullable()();
  TextColumn get response => text().nullable()();
  BoolColumn get referral => boolean().withDefault(const Constant(false))();
  TextColumn get imageUrl => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get zone => text().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class MedicalProtocols extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameKr => text().nullable()(); // Créole
  TextColumn get keywords => text()(); // JSON array
  TextColumn get steps => text()(); // JSON object
  TextColumn get urgencyLevel => text()();
  TextColumn get category => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Vaccinations extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get vaccine => text()();
  IntColumn get doseNumber => integer()();
  DateTimeColumn get dateGiven => dateTime()();
  DateTimeColumn get nextDueDate => dateTime().nullable()();
  TextColumn get batchNumber => text().nullable()();
  TextColumn get agentId => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Patients, Households, HouseholdMembers, Consultations, SyncQueue, CaseReports, MedicalProtocols, Vaccinations])

class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle migrations here
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}
