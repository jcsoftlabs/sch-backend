import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../models/case_report_model.dart';
import 'dart:convert';

/// Repository for offline case report operations using Drift
class OfflineCaseReportRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineCaseReportRepository(this._db);

  /// Save a case report locally
  Future<void> saveCaseReportLocally(CaseReportModel caseReport) async {
    await _db.into(_db.caseReports).insert(
      CaseReportsCompanion.insert(
        id: caseReport.id,
        agentId: caseReport.agentId,
        patientId: Value(caseReport.patientId),
        symptoms: caseReport.symptoms,
        urgency: caseReport.urgency.name.toUpperCase(),
        channel: Value(caseReport.channel.name.toUpperCase()),
        status: Value(caseReport.status.name.toUpperCase()),
        doctorId: Value(caseReport.doctorId),
        response: Value(caseReport.response),
        referral: Value(caseReport.referral),
        imageUrl: Value(caseReport.imageUrl),
        latitude: Value(caseReport.latitude),
        longitude: Value(caseReport.longitude),
        zone: Value(caseReport.zone),
        resolvedAt: Value(caseReport.resolvedAt),
        createdAt: caseReport.createdAt,
        updatedAt: caseReport.updatedAt,
        syncStatus: const Value('pending'),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get all case reports for an agent from local database
  Future<List<CaseReportModel>> getLocalCaseReports(String agentId) async {
    final query = _db.select(_db.caseReports)
      ..where((tbl) => tbl.agentId.equals(agentId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
      ]);

    final results = await query.get();
    return results.map(_mapToCaseReportModel).toList();
  }

  /// Get all pending sync case reports
  Future<List<CaseReportModel>> getPendingSyncCaseReports() async {
    final query = _db.select(_db.caseReports)
      ..where((tbl) => tbl.syncStatus.equals('pending'))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
      ]);

    final results = await query.get();
    return results.map(_mapToCaseReportModel).toList();
  }

  /// Mark a case report as synced
  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.caseReports)..where((tbl) => tbl.id.equals(id)))
        .write(const CaseReportsCompanion(syncStatus: Value('synced')));
  }

  /// Update a case report locally
  Future<void> updateCaseReportLocally(CaseReportModel caseReport) async {
    await (_db.update(_db.caseReports)..where((tbl) => tbl.id.equals(caseReport.id)))
        .write(
      CaseReportsCompanion(
        symptoms: Value(caseReport.symptoms),
        urgency: Value(caseReport.urgency.name.toUpperCase()),
        status: Value(caseReport.status.name.toUpperCase()),
        doctorId: Value(caseReport.doctorId),
        response: Value(caseReport.response),
        referral: Value(caseReport.referral),
        imageUrl: Value(caseReport.imageUrl),
        latitude: Value(caseReport.latitude),
        longitude: Value(caseReport.longitude),
        zone: Value(caseReport.zone),
        resolvedAt: Value(caseReport.resolvedAt),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  /// Delete a case report locally
  Future<void> deleteCaseReportLocally(String id) async {
    await (_db.delete(_db.caseReports)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Get a single case report by ID
  Future<CaseReportModel?> getCaseReportById(String id) async {
    final query = _db.select(_db.caseReports)
      ..where((tbl) => tbl.id.equals(id));

    final result = await query.getSingleOrNull();
    return result != null ? _mapToCaseReportModel(result) : null;
  }

  /// Create a new case report locally (generates UUID)
  Future<CaseReportModel> createCaseReportLocally({
    required String agentId,
    String? patientId,
    required String symptoms,
    required UrgencyLevel urgency,
    CaseChannel channel = CaseChannel.app,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? zone,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final caseReport = CaseReportModel(
      id: id,
      agentId: agentId,
      patientId: patientId,
      symptoms: symptoms,
      urgency: urgency,
      channel: channel,
      status: CaseReportStatus.pending,
      referral: false,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      zone: zone,
      createdAt: now,
      updatedAt: now,
    );

    await saveCaseReportLocally(caseReport);
    return caseReport;
  }

  /// Map Drift CaseReport to CaseReportModel
  CaseReportModel _mapToCaseReportModel(CaseReport driftCase) {
    return CaseReportModel(
      id: driftCase.id,
      agentId: driftCase.agentId,
      patientId: driftCase.patientId,
      symptoms: driftCase.symptoms,
      urgency: _parseUrgencyLevel(driftCase.urgency),
      channel: _parseCaseChannel(driftCase.channel),
      status: _parseCaseReportStatus(driftCase.status),
      doctorId: driftCase.doctorId,
      response: driftCase.response,
      referral: driftCase.referral,
      imageUrl: driftCase.imageUrl,
      latitude: driftCase.latitude,
      longitude: driftCase.longitude,
      zone: driftCase.zone,
      resolvedAt: driftCase.resolvedAt,
      createdAt: driftCase.createdAt,
      updatedAt: driftCase.updatedAt,
    );
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

  CaseChannel _parseCaseChannel(String value) {
    switch (value.toUpperCase()) {
      case 'SMS':
        return CaseChannel.sms;
      case 'WHATSAPP':
        return CaseChannel.whatsapp;
      default:
        return CaseChannel.app;
    }
  }

  CaseReportStatus _parseCaseReportStatus(String value) {
    switch (value.toUpperCase()) {
      case 'ASSIGNED':
        return CaseReportStatus.assigned;
      case 'RESOLVED':
        return CaseReportStatus.resolved;
      default:
        return CaseReportStatus.pending;
    }
  }
}
