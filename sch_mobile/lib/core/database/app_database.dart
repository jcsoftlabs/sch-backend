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
  TextColumn get doctorId => text().nullable()();
  TextColumn get healthCenterId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get doctorName => text().nullable()(); // Cached reference
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class VitalSigns extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get medicalRecordId => text().nullable()();
  RealColumn get temperature => real().nullable()();
  IntColumn get bloodPressureSys => integer().nullable()();
  IntColumn get bloodPressureDia => integer().nullable()();
  IntColumn get heartRate => integer().nullable()();
  IntColumn get respiratoryRate => integer().nullable()();
  RealColumn get oxygenSaturation => real().nullable()();
  TextColumn get agentId => text()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

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

class MaternalCares extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  DateTimeColumn get pregnancyStart => dateTime().nullable()();
  DateTimeColumn get expectedDelivery => dateTime().nullable()();
  IntColumn get prenatalVisits => integer().withDefault(const Constant(0))();
  TextColumn get riskLevel => text().withDefault(const Constant('NORMAL'))();
  DateTimeColumn get deliveryDate => dateTime().nullable()();
  TextColumn get deliveryType => text().nullable()();
  TextColumn get outcome => text().nullable()();
  RealColumn get newbornWeight => real().nullable()();
  TextColumn get agentId => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

class NutritionRecords extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  RealColumn get weight => real()();
  RealColumn get height => real()();
  RealColumn get muac => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('NORMAL'))();
  TextColumn get agentId => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Patients,
  Households,
  HouseholdMembers,
  Consultations,
  SyncQueue,
  CaseReports,
  MedicalProtocols,
  Vaccinations,
  VitalSigns,
  MaternalCares,
  NutritionRecords
])
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
