import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../models/vital_sign_model.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class OfflineVitalSignsRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineVitalSignsRepository(this._db);

  Future<List<VitalSignModel>> getVitalSignsByPatient(String patientId) async {
    final query = _db.select(_db.vitalSigns)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc)]);
    
    final results = await query.get();
    
    return results.map((row) => VitalSignModel(
      id: row.id,
      patientId: row.patientId,
      medicalRecordId: row.medicalRecordId,
      temperature: row.temperature,
      bloodPressureSys: row.bloodPressureSys,
      bloodPressureDia: row.bloodPressureDia,
      heartRate: row.heartRate,
      respiratoryRate: row.respiratoryRate,
      oxygenSaturation: row.oxygenSaturation,
      agentId: row.agentId,
      createdAt: row.recordedAt,
    )).toList();
  }

  Future<void> createVitalSign(VitalSignModel vitalSign) async {
    final localId = vitalSign.id ?? _uuid.v4();
    final modelWithId = VitalSignModel(
      id: localId,
      patientId: vitalSign.patientId,
      medicalRecordId: vitalSign.medicalRecordId,
      temperature: vitalSign.temperature,
      bloodPressureSys: vitalSign.bloodPressureSys,
      bloodPressureDia: vitalSign.bloodPressureDia,
      heartRate: vitalSign.heartRate,
      respiratoryRate: vitalSign.respiratoryRate,
      oxygenSaturation: vitalSign.oxygenSaturation,
      agentId: vitalSign.agentId,
      createdAt: vitalSign.createdAt ?? DateTime.now(),
    );

    await _db.transaction(() async {
      await _db.into(_db.vitalSigns).insert(
        VitalSignsCompanion.insert(
          id: localId,
          patientId: modelWithId.patientId,
          medicalRecordId: Value(modelWithId.medicalRecordId),
          temperature: Value(modelWithId.temperature),
          bloodPressureSys: Value(modelWithId.bloodPressureSys),
          bloodPressureDia: Value(modelWithId.bloodPressureDia),
          heartRate: Value(modelWithId.heartRate),
          respiratoryRate: Value(modelWithId.respiratoryRate),
          oxygenSaturation: Value(modelWithId.oxygenSaturation),
          agentId: modelWithId.agentId ?? 'UNKNOWN', 
          recordedAt: modelWithId.createdAt ?? DateTime.now(),
          syncStatus: const Value('pending'),
          isSynced: const Value(false),
        ),
        mode: InsertMode.replace,
      );

      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          operation: 'CREATE',
          entityType: 'VITAL_SIGN',
          entityId: localId,
          payload: jsonEncode(modelWithId.toJson()),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        )
      );
    });
  }

  Future<void> syncVitalSigns(List<VitalSignModel> apiVitals) async {
    await _db.transaction(() async {
      for (var vital in apiVitals) {
        await _db.into(_db.vitalSigns).insert(
          VitalSignsCompanion.insert(
            id: vital.id ?? _uuid.v4(),
            patientId: vital.patientId,
            medicalRecordId: Value(vital.medicalRecordId),
            temperature: Value(vital.temperature),
            bloodPressureSys: Value(vital.bloodPressureSys),
            bloodPressureDia: Value(vital.bloodPressureDia),
            heartRate: Value(vital.heartRate),
            respiratoryRate: Value(vital.respiratoryRate),
            oxygenSaturation: Value(vital.oxygenSaturation),
            agentId: vital.agentId ?? 'UNKNOWN',
            recordedAt: vital.createdAt ?? DateTime.now(),
            syncStatus: const Value('synced'),
            isSynced: const Value(true),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }
}
