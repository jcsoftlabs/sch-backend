import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/vaccination_model.dart';
import 'package:uuid/uuid.dart';

class OfflineVaccinationRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineVaccinationRepository(this._db);

  /// Get all vaccinations for a specific patient
  Future<List<VaccinationModel>> getVaccinationsByPatient(String patientId) async {
    final query = _db.select(_db.vaccinations)
      ..where((tbl) => tbl.patientId.equals(patientId))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.dateGiven, mode: OrderingMode.desc)]);

    final results = await query.get();

    return results.map((row) => VaccinationModel(
      id: row.id,
      patientId: row.patientId,
      vaccine: row.vaccine,
      doseNumber: row.doseNumber,
      dateGiven: row.dateGiven,
      nextDueDate: row.nextDueDate,
      batchNumber: row.batchNumber,
      agentId: row.agentId,
      notes: row.notes,
      createdAt: row.createdAt,
      isSynced: row.isSynced,
    )).toList();
  }

  /// Check if a child has missed a deadline for a critical vaccine
  Future<List<VaccinationModel>> getDueVaccinations() async {
    final now = DateTime.now();
    // Start of today and end of today
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final query = _db.select(_db.vaccinations)
      ..where((tbl) => tbl.nextDueDate.isNotNull())
      // Get vaccines due today or overdue
      ..where((tbl) => tbl.nextDueDate.isSmallerOrEqualValue(todayEnd))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.nextDueDate, mode: OrderingMode.asc)]);

    final results = await query.get();

    return results.map((row) => VaccinationModel(
      id: row.id,
      patientId: row.patientId,
      vaccine: row.vaccine,
      doseNumber: row.doseNumber,
      dateGiven: row.dateGiven,
      nextDueDate: row.nextDueDate,
      batchNumber: row.batchNumber,
      agentId: row.agentId,
      notes: row.notes,
      createdAt: row.createdAt,
      isSynced: row.isSynced,
    )).toList();
  }

  /// Save a new vaccination locally
  Future<String> saveVaccination(VaccinationModel vaccination) async {
    final id = vaccination.id ?? _uuid.v4();
    final now = DateTime.now();

    await _db.into(_db.vaccinations).insert(
      VaccinationsCompanion.insert(
        id: id,
        patientId: vaccination.patientId,
        vaccine: vaccination.vaccine,
        doseNumber: vaccination.doseNumber,
        dateGiven: vaccination.dateGiven,
        nextDueDate: Value(vaccination.nextDueDate),
        batchNumber: Value(vaccination.batchNumber),
        agentId: vaccination.agentId,
        notes: Value(vaccination.notes),
        createdAt: vaccination.createdAt ?? now,
        isSynced: const Value(false), // Needs sync
      ),
      mode: InsertMode.replace,
    );

    return id;
  }

  /// Get pending unsynced vaccinations
  Future<List<VaccinationModel>> getPendingVaccinations() async {
    final query = _db.select(_db.vaccinations)
      ..where((tbl) => tbl.isSynced.equals(false));

    final results = await query.get();

    return results.map((row) => VaccinationModel(
      id: row.id,
      patientId: row.patientId,
      vaccine: row.vaccine,
      doseNumber: row.doseNumber,
      dateGiven: row.dateGiven,
      nextDueDate: row.nextDueDate,
      batchNumber: row.batchNumber,
      agentId: row.agentId,
      notes: row.notes,
      createdAt: row.createdAt,
      isSynced: row.isSynced,
    )).toList();
  }

  /// Mark a vaccination as successfully synced
  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.vaccinations)..where((tbl) => tbl.id.equals(id))).write(
      const VaccinationsCompanion(
        isSynced: Value(true),
      ),
    );
  }
}
