import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../models/appointment_model.dart';

class OfflineAppointmentRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineAppointmentRepository(this._db);

  Future<List<AppointmentModel>> getAppointmentsByPatient(String patientId) async {
    final query = _db.select(_db.appointments)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm(expression: t.scheduledAt, mode: OrderingMode.asc)]);
    
    final results = await query.get();
    
    return results.map((row) => AppointmentModel(
      id: row.id,
      patientId: row.patientId,
      doctorId: row.doctorId,
      healthCenterId: row.healthCenterId,
      scheduledAt: row.scheduledAt,
      duration: row.duration,
      reason: row.reason,
      status: row.status,
      agentId: row.agentId,
      notes: row.notes,
      reminderSent: row.reminderSent,
      createdAt: row.createdAt,
    )).toList();
  }

  Future<List<AppointmentModel>> getUpcomingAppointmentsByAgent(String agentId) async {
    final now = DateTime.now();
    final query = _db.select(_db.appointments)
      ..where((t) => t.agentId.equals(agentId) & t.scheduledAt.isBiggerOrEqualValue(now))
      ..orderBy([(t) => OrderingTerm(expression: t.scheduledAt, mode: OrderingMode.asc)]);
      
    final results = await query.get();
    
    return results.map((row) => AppointmentModel(
      id: row.id,
      patientId: row.patientId,
      doctorId: row.doctorId,
      healthCenterId: row.healthCenterId,
      scheduledAt: row.scheduledAt,
      duration: row.duration,
      reason: row.reason,
      status: row.status,
      agentId: row.agentId,
      notes: row.notes,
      reminderSent: row.reminderSent,
      createdAt: row.createdAt,
    )).toList();
  }

  Future<void> createAppointment(AppointmentModel record) async {
    final localId = record.id ?? _uuid.v4();
    final modelWithId = AppointmentModel(
      id: localId,
      patientId: record.patientId,
      doctorId: record.doctorId,
      healthCenterId: record.healthCenterId,
      scheduledAt: record.scheduledAt,
      duration: record.duration,
      reason: record.reason,
      status: record.status,
      agentId: record.agentId,
      notes: record.notes,
      reminderSent: record.reminderSent,
      createdAt: record.createdAt ?? DateTime.now(),
    );

    await _db.transaction(() async {
      await _db.into(_db.appointments).insert(
        AppointmentsCompanion.insert(
          id: localId,
          patientId: modelWithId.patientId,
          doctorId: Value(modelWithId.doctorId),
          healthCenterId: Value(modelWithId.healthCenterId),
          scheduledAt: modelWithId.scheduledAt,
          duration: Value(modelWithId.duration),
          reason: Value(modelWithId.reason),
          status: Value(modelWithId.status),
          agentId: modelWithId.agentId,
          notes: Value(modelWithId.notes),
          reminderSent: Value(modelWithId.reminderSent),
          createdAt: modelWithId.createdAt ?? DateTime.now(),
          syncStatus: const Value('pending'),
        ),
        mode: InsertMode.replace,
      );

      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          operation: 'CREATE',
          entityType: 'APPOINTMENT',
          entityId: localId,
          payload: jsonEncode(modelWithId.toJson()),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        )
      );
    });
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    await _db.transaction(() async {
      await (_db.update(_db.appointments)..where((t) => t.id.equals(id))).write(
        AppointmentsCompanion(
          status: Value(status),
          syncStatus: const Value('pending')
        ),
      );

      // We need the full record for the API, so we fetch it
      final record = await (_db.select(_db.appointments)..where((t) => t.id.equals(id))).getSingle();

      await _db.into(_db.syncQueue).insert(
        SyncQueueCompanion.insert(
          operation: 'UPDATE',
          entityType: 'APPOINTMENT',
          entityId: id,
          payload: jsonEncode({'status': status}),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        )
      );
    });
  }

  Future<void> syncAppointments(List<AppointmentModel> apiRecords) async {
    await _db.transaction(() async {
      for (var record in apiRecords) {
        await _db.into(_db.appointments).insert(
          AppointmentsCompanion.insert(
            id: record.id ?? _uuid.v4(),
            patientId: record.patientId,
            doctorId: Value(record.doctorId),
            healthCenterId: Value(record.healthCenterId),
            scheduledAt: record.scheduledAt,
            duration: Value(record.duration),
            reason: Value(record.reason),
            status: Value(record.status),
            agentId: record.agentId,
            notes: Value(record.notes),
            reminderSent: Value(record.reminderSent),
            createdAt: record.createdAt ?? DateTime.now(),
            syncStatus: const Value('synced'),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }
}
