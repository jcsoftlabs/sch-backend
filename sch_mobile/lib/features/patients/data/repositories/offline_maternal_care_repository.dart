import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../models/maternal_care_model.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class OfflineMaternalCareRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineMaternalCareRepository(this._db);

  Future<List<MaternalCareModel>> getMaternalCaresByPatient(String patientId) async {
    final query = _db.select(_db.maternalCares)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    
    final results = await query.get();
    
    return results.map((row) => MaternalCareModel(
      id: row.id,
      patientId: row.patientId,
      pregnancyStart: row.pregnancyStart,
      expectedDelivery: row.expectedDelivery,
      prenatalVisits: row.prenatalVisits,
      riskLevel: row.riskLevel,
      deliveryDate: row.deliveryDate,
      deliveryType: row.deliveryType,
      outcome: row.outcome,
      newbornWeight: row.newbornWeight,
      agentId: row.agentId,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    )).toList();
  }

  Future<void> createMaternalCare(MaternalCareModel maternalCare) async {
    final localId = maternalCare.id ?? _uuid.v4();
    
    // Auto-calculate expected delivery date if not provided (40 weeks / 280 days)
    DateTime? dpa = maternalCare.expectedDelivery;
    if (dpa == null && maternalCare.pregnancyStart != null) {
      dpa = maternalCare.pregnancyStart!.add(const Duration(days: 280));
    }

    final modelWithId = MaternalCareModel(
      id: localId,
      patientId: maternalCare.patientId,
      pregnancyStart: maternalCare.pregnancyStart,
      expectedDelivery: dpa,
      prenatalVisits: maternalCare.prenatalVisits,
      riskLevel: maternalCare.riskLevel,
      deliveryDate: maternalCare.deliveryDate,
      deliveryType: maternalCare.deliveryType,
      outcome: maternalCare.outcome,
      newbornWeight: maternalCare.newbornWeight,
      agentId: maternalCare.agentId,
      notes: maternalCare.notes,
      createdAt: maternalCare.createdAt ?? DateTime.now(),
      updatedAt: maternalCare.updatedAt,
    );

    await _db.transaction(() async {
      await _db.into(_db.maternalCares).insert(
        MaternalCaresCompanion.insert(
          id: localId,
          patientId: modelWithId.patientId,
          pregnancyStart: Value(modelWithId.pregnancyStart),
          expectedDelivery: Value(modelWithId.expectedDelivery),
          prenatalVisits: Value(modelWithId.prenatalVisits),
          riskLevel: Value(modelWithId.riskLevel),
          deliveryDate: Value(modelWithId.deliveryDate),
          deliveryType: Value(modelWithId.deliveryType),
          outcome: Value(modelWithId.outcome),
          newbornWeight: Value(modelWithId.newbornWeight),
          agentId: modelWithId.agentId,
          notes: Value(modelWithId.notes),
          createdAt: modelWithId.createdAt ?? DateTime.now(),
          updatedAt: Value(modelWithId.updatedAt),
          syncStatus: const Value('pending'),
        ),
        mode: InsertMode.replace,
      );

      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          operation: 'CREATE',
          entityType: 'MATERNAL_CARE',
          entityId: localId,
          payload: jsonEncode(modelWithId.toJson()),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        )
      );
    });
  }

  Future<void> updateMaternalCare(String id, MaternalCareModel maternalCare) async {
    await _db.transaction(() async {
      await _db.update(_db.maternalCares).replace(
        MaternalCaresCompanion(
          id: Value(id),
          patientId: Value(maternalCare.patientId),
          pregnancyStart: Value(maternalCare.pregnancyStart),
          expectedDelivery: Value(maternalCare.expectedDelivery),
          prenatalVisits: Value(maternalCare.prenatalVisits),
          riskLevel: Value(maternalCare.riskLevel),
          deliveryDate: Value(maternalCare.deliveryDate),
          deliveryType: Value(maternalCare.deliveryType),
          outcome: Value(maternalCare.outcome),
          newbornWeight: Value(maternalCare.newbornWeight),
          agentId: Value(maternalCare.agentId),
          notes: Value(maternalCare.notes),
          createdAt: Value(maternalCare.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value('pending'),
        )
      );

      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          operation: 'UPDATE',
          entityType: 'MATERNAL_CARE',
          entityId: id,
          payload: jsonEncode(maternalCare.toJson()),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        )
      );
    });
  }

  Future<void> syncMaternalCares(List<MaternalCareModel> apiRecords) async {
    await _db.transaction(() async {
      for (var record in apiRecords) {
        await _db.into(_db.maternalCares).insert(
          MaternalCaresCompanion.insert(
            id: record.id ?? _uuid.v4(),
            patientId: record.patientId,
            pregnancyStart: Value(record.pregnancyStart),
            expectedDelivery: Value(record.expectedDelivery),
            prenatalVisits: Value(record.prenatalVisits),
            riskLevel: Value(record.riskLevel),
            deliveryDate: Value(record.deliveryDate),
            deliveryType: Value(record.deliveryType),
            outcome: Value(record.outcome),
            newbornWeight: Value(record.newbornWeight),
            agentId: record.agentId,
            notes: Value(record.notes),
            createdAt: record.createdAt ?? DateTime.now(),
            updatedAt: Value(record.updatedAt),
            syncStatus: const Value('synced'),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }
}
