import '../../../../core/database/app_database.dart';
import '../models/consultation_model.dart';
import 'package:drift/drift.dart';

class OfflineConsultationsRepository {
  final AppDatabase _db;

  OfflineConsultationsRepository(this._db);

  Future<List<ConsultationModel>> getConsultationsByPatient(String patientId) async {
    final query = _db.select(_db.consultations)
      ..where((t) => t.patientId.equals(patientId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    
    final results = await query.get();
    
    return results.map((row) => ConsultationModel(
      id: row.id,
      patientId: row.patientId,
      doctorId: row.doctorId,
      healthCenterId: row.healthCenterId,
      status: row.status,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      doctorMap: row.doctorName != null ? {'firstName': row.doctorName, 'lastName': ''} : null,
    )).toList();
  }

  Future<void> syncConsultations(List<ConsultationModel> apiConsultations) async {
    await _db.transaction(() async {
      for (var consultation in apiConsultations) {
        String? doctorName;
        if (consultation.doctorMap != null && consultation.doctorMap is Map) {
          final firstName = consultation.doctorMap['firstName'] ?? '';
          final lastName = consultation.doctorMap['lastName'] ?? '';
          doctorName = '$firstName $lastName'.trim();
        }

        await _db.into(_db.consultations).insert(
          ConsultationsCompanion.insert(
            id: consultation.id ?? '',
            patientId: consultation.patientId,
            doctorId: Value(consultation.doctorId),
            healthCenterId: Value(consultation.healthCenterId),
            status: Value(consultation.status),
            notes: Value(consultation.notes),
            createdAt: consultation.createdAt ?? DateTime.now(),
            updatedAt: Value(consultation.updatedAt),
            doctorName: Value(doctorName),
            syncStatus: const Value('synced'),
          ),
          mode: InsertMode.replace,
        );
      }
    });
  }
}
