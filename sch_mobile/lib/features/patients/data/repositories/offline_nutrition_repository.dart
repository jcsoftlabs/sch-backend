import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../models/nutrition_record_model.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class OfflineNutritionRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineNutritionRepository(this._db);

  Future<List<NutritionRecordModel>> getNutritionRecordsByPatient(String patientId) async {
    final query = _db.select(_db.nutritionRecords)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]);
    
    final results = await query.get();
    
    return results.map((row) => NutritionRecordModel(
      id: row.id,
      patientId: row.patientId,
      weight: row.weight,
      height: row.height,
      muac: row.muac,
      status: row.status,
      agentId: row.agentId,
      notes: row.notes,
      date: row.date,
    )).toList();
  }

  Future<void> createNutritionRecord(NutritionRecordModel record) async {
    final localId = record.id ?? _uuid.v4();
    final modelWithId = NutritionRecordModel(
      id: localId,
      patientId: record.patientId,
      weight: record.weight,
      height: record.height,
      muac: record.muac,
      status: record.status, // We rely on the local model temporarily until API echoes back the real calculation
      agentId: record.agentId,
      notes: record.notes,
      date: record.date ?? DateTime.now(),
    );

    await _db.transaction(() async {
      await _db.into(_db.nutritionRecords).insert(
        NutritionRecordsCompanion.insert(
          id: localId,
          patientId: modelWithId.patientId,
          weight: modelWithId.weight,
          height: modelWithId.height,
          muac: Value(modelWithId.muac),
          status: Value(modelWithId.status),
          agentId: modelWithId.agentId,
          notes: Value(modelWithId.notes),
          date: modelWithId.date ?? DateTime.now(),
          syncStatus: const Value('pending'),
        ),
        mode: InsertMode.replace,
      );

      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          operation: 'CREATE',
          entityType: 'NUTRITION',
          entityId: localId,
          payload: jsonEncode(modelWithId.toJson()),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        )
      );
    });
  }

  Future<void> syncNutritionRecords(List<NutritionRecordModel> apiRecords) async {
    await _db.transaction(() async {
      for (var record in apiRecords) {
        await _db.into(_db.nutritionRecords).insert(
          NutritionRecordsCompanion.insert(
            id: record.id ?? _uuid.v4(),
            patientId: record.patientId,
            weight: record.weight,
            height: record.height,
            muac: Value(record.muac),
            status: Value(record.status),
            agentId: record.agentId,
            notes: Value(record.notes),
            date: record.date ?? DateTime.now(),
            syncStatus: const Value('synced'),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }
}
