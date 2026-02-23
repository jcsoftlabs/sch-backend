import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import 'connectivity_service.dart';
import 'sync_queue_service.dart';

enum SyncStatus {
  idle,
  syncing,
  success,
  error,
}

class SyncService {
  final AppDatabase _db;
  final ApiClient _apiClient;
  final ConnectivityService _connectivity;
  final SyncQueueService _queueService;
  final Logger _logger = Logger();

  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  DateTime? _lastSyncTime;
  Timer? _autoSyncTimer;

  SyncService(
    this._db,
    this._apiClient,
    this._connectivity,
    this._queueService,
  );

  SyncStatus get status => _status;
  String? get lastError => _lastError;
  DateTime? get lastSyncTime => _lastSyncTime;

  // Start auto-sync timer
  void startAutoSync({Duration interval = const Duration(minutes: 15)}) {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(interval, (_) async {
      final isOnline = await _connectivity.checkConnectivity();
      if (isOnline) {
        await syncAll();
      }
    });
  }

  // Stop auto-sync timer
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
  }

  // Sync all pending operations
  Future<void> syncAll() async {
    if (_status == SyncStatus.syncing) {
      _logger.i('Sync already in progress');
      return;
    }

    final isOnline = await _connectivity.checkConnectivity();
    if (!isOnline) {
      _logger.w('No internet connection, skipping sync');
      return;
    }

    _status = SyncStatus.syncing;
    _lastError = null;

    try {
      // Get pending operations
      final pendingOps = await _queueService.getPendingOperations();
      _logger.i('Syncing ${pendingOps.length} pending operations');

      for (final op in pendingOps) {
        try {
          await _syncOperation(op);
          await _queueService.markAsCompleted(op.id);
        } catch (e) {
          _logger.e('Failed to sync operation ${op.id}: $e');
          await _queueService.markAsFailed(op.id, e.toString());
        }
      }

      // Pull latest data from server
      await _pullFromServer();

      _status = SyncStatus.success;
      _lastSyncTime = DateTime.now();
      _logger.i('Sync completed successfully');
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      _logger.e('Sync failed: $e');
    }
  }

  // Sync individual operation
  Future<void> _syncOperation(SyncQueueData op) async {
    final payload = jsonDecode(op.payload);

    switch (op.entityType) {
      case 'Patient':
        await _syncPatient(op.operation, op.entityId, payload);
        break;
      case 'Household':
        await _syncHousehold(op.operation, op.entityId, payload);
        break;
      case 'Consultation':
        await _syncConsultation(op.operation, op.entityId, payload);
        break;
      case 'CaseReport':
        await _syncCaseReport(op.operation, op.entityId, payload);
        break;
      case 'VITAL_SIGN':
        await _syncVitalSign(op.operation, op.entityId, payload);
        break;
      case 'MATERNAL_CARE':
        await _syncMaternalCare(op.operation, op.entityId, payload);
        break;
      default:
        throw Exception('Unknown entity type: ${op.entityType}');
    }
  }

  // Sync patient operations
  Future<void> _syncPatient(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    switch (operation) {
      case 'CREATE':
        await _apiClient.dio.post('/patients', data: payload);
        break;
      case 'UPDATE':
        await _apiClient.dio.put('/patients/$entityId', data: payload);
        break;
      case 'DELETE':
        await _apiClient.dio.delete('/patients/$entityId');
        break;
    }
  }

  // Sync household operations
  Future<void> _syncHousehold(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    switch (operation) {
      case 'CREATE':
        await _apiClient.dio.post('/households', data: payload);
        break;
      case 'UPDATE':
        await _apiClient.dio.put('/households/$entityId', data: payload);
        break;
      case 'DELETE':
        await _apiClient.dio.delete('/households/$entityId');
        break;
    }
  }

  // Sync consultation operations
  Future<void> _syncConsultation(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    switch (operation) {
      case 'CREATE':
        await _apiClient.dio.post('/consultations', data: payload);
        break;
      case 'UPDATE':
        await _apiClient.dio.put('/consultations/$entityId', data: payload);
        break;
      case 'DELETE':
        await _apiClient.dio.delete('/consultations/$entityId');
        break;
    }
  }

  // Sync case report operations
  Future<void> _syncCaseReport(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    switch (operation) {
      case 'CREATE':
        await _apiClient.dio.post('/case-reports', data: payload);
        break;
      case 'UPDATE':
        await _apiClient.dio.put('/case-reports/$entityId', data: payload);
        break;
      case 'DELETE':
        await _apiClient.dio.delete('/case-reports/$entityId');
        break;
    }
  }

  // Sync vital sign operations
  Future<void> _syncVitalSign(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    switch (operation) {
      case 'CREATE':
        final patientId = payload['patientId'];
        await _apiClient.dio.post('/vital-signs/patient/$patientId', data: payload);
        break;
    }
  }

  // Sync maternal care operations
  Future<void> _syncMaternalCare(
    String operation,
    String entityId,
    Map<String, dynamic> payload,
  ) async {
    switch (operation) {
      case 'CREATE':
        await _apiClient.dio.post('/maternal-care', data: payload);
        break;
      case 'UPDATE':
        await _apiClient.dio.put('/maternal-care/$entityId', data: payload);
        break;
      case 'DELETE':
        await _apiClient.dio.delete('/maternal-care/$entityId');
        break;
    }
  }

  // Pull latest data from server
  Future<void> _pullFromServer() async {
    // Pull patients
    final patientsResponse = await _apiClient.dio.get('/patients');
    final patients = (patientsResponse.data['data'] ?? patientsResponse.data) as List;
    
    for (final patientJson in patients) {
      await _db.into(_db.patients).insertOnConflictUpdate(
        PatientsCompanion.insert(
          id: patientJson['id'],
          firstName: patientJson['firstName'],
          lastName: patientJson['lastName'],
          dateOfBirth: DateTime.parse(patientJson['dateOfBirth']),
          gender: patientJson['gender'],
          address: patientJson['address'],
          phone: Value(patientJson['phone']),
          nationalId: Value(patientJson['nationalId']),
          householdId: Value(patientJson['householdId']),
          createdAt: DateTime.parse(patientJson['createdAt']),
          updatedAt: DateTime.parse(patientJson['updatedAt']),
          syncStatus: const Value('synced'),
        ),
      );
    }

    _logger.i('Pulled ${patients.length} patients from server');
  }

  // Retry failed operations
  Future<void> retryFailed() async {
    await _queueService.retryFailed();
    await syncAll();
  }

  // Clear completed operations
  Future<void> clearCompleted() async {
    await _queueService.clearCompleted();
  }

  void dispose() {
    stopAutoSync();
  }
}
