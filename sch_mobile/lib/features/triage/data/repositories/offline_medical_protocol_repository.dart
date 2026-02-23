import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/medical_protocol_model.dart';
import '../models/case_report_model.dart'; // For UrgencyLevel
import 'dart:convert';

/// Repository for offline medical protocol operations using Drift
class OfflineMedicalProtocolRepository {
  final AppDatabase _db;

  OfflineMedicalProtocolRepository(this._db);

  /// Save medical protocols locally (bulk insert)
  Future<void> saveProtocolsLocally(
    List<MedicalProtocolModel> protocols,
  ) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.medicalProtocols,
        protocols.map((protocol) => MedicalProtocolsCompanion.insert(
              id: protocol.id,
              name: protocol.name,
              nameKr: Value(protocol.nameKr),
              keywords: jsonEncode(protocol.keywords),
              steps: protocol.steps,
              urgencyLevel: protocol.urgencyLevel.name.toUpperCase(),
              category: Value(protocol.category),
              isActive: Value(protocol.isActive),
              createdAt: protocol.createdAt,
              updatedAt: protocol.updatedAt,
            )),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Get all active protocols from local database
  Future<List<MedicalProtocolModel>> getLocalActiveProtocols() async {
    final query = _db.select(_db.medicalProtocols)
      ..where((tbl) => tbl.isActive.equals(true))
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
      ]);

    final results = await query.get();
    return results.map(_mapToMedicalProtocolModel).toList();
  }

  /// Get all protocols (active and inactive)
  Future<List<MedicalProtocolModel>> getAllLocalProtocols() async {
    final query = _db.select(_db.medicalProtocols)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
      ]);

    final results = await query.get();
    return results.map(_mapToMedicalProtocolModel).toList();
  }

  /// Get protocol by ID
  Future<MedicalProtocolModel?> getProtocolById(String id) async {
    final query = _db.select(_db.medicalProtocols)
      ..where((tbl) => tbl.id.equals(id));

    final result = await query.getSingleOrNull();
    return result != null ? _mapToMedicalProtocolModel(result) : null;
  }

  /// Clear all protocols (useful before full sync)
  Future<void> clearAllProtocols() async {
    await _db.delete(_db.medicalProtocols).go();
  }

  /// Get protocols by category
  Future<List<MedicalProtocolModel>> getProtocolsByCategory(
      String category) async {
    final results = await (_db.select(_db.medicalProtocols)
          ..where((tbl) => tbl.category.equals(category) & tbl.isActive.equals(true))
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)
          ]))
        .get();
    return results.map(_mapToMedicalProtocolModel).toList();
  }

  /// Get count of active protocols
  Future<int> getActiveProtocolCount() async {
    final query = _db.selectOnly(_db.medicalProtocols)
      ..addColumns([_db.medicalProtocols.id.count()])
      ..where(_db.medicalProtocols.isActive.equals(true));

    final result = await query.getSingle();
    return result.read(_db.medicalProtocols.id.count()) ?? 0;
  }

  /// Map Drift MedicalProtocol to MedicalProtocolModel
  MedicalProtocolModel _mapToMedicalProtocolModel(MedicalProtocol driftProtocol) {
    return MedicalProtocolModel(
      id: driftProtocol.id,
      name: driftProtocol.name,
      nameKr: driftProtocol.nameKr,
      keywords: _parseKeywords(driftProtocol.keywords),
      steps: driftProtocol.steps,
      urgencyLevel: _parseUrgencyLevel(driftProtocol.urgencyLevel),
      category: driftProtocol.category,
      isActive: driftProtocol.isActive,
      createdAt: driftProtocol.createdAt,
      updatedAt: driftProtocol.updatedAt,
    );
  }

  List<String> _parseKeywords(String jsonKeywords) {
    try {
      final decoded = jsonDecode(jsonKeywords);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  UrgencyLevel _parseUrgencyLevel(String value) {
    switch (value.toUpperCase()) {
      case 'CRITICAL':
        return UrgencyLevel.critical;
      case 'URGENT':
        return UrgencyLevel.urgent;
      default:
        return UrgencyLevel.normal;
    }
  }
}
