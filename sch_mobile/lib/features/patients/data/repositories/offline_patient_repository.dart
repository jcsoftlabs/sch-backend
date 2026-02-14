import 'package:drift/drift.dart';
import 'package:sch_mobile/core/database/app_database.dart';
import 'package:sch_mobile/core/network/api_client.dart';
import 'package:sch_mobile/core/services/connectivity_service.dart';
import 'package:sch_mobile/core/services/sync_queue_service.dart';
import '../models/patient_model.dart';

class OfflinePatientRepository {
  final AppDatabase _db;
  final ApiClient _apiClient;
  final ConnectivityService _connectivity;
  final SyncQueueService _queueService;

  OfflinePatientRepository(
    this._db,
    this._apiClient,
    this._connectivity,
    this._queueService,
  );

  // Get patients (local-first)
  Future<List<PatientModel>> getPatients({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    // Try to get from local database first
    final query = _db.select(_db.patients);
    
    if (search != null && search.isNotEmpty) {
      query.where((tbl) =>
          tbl.firstName.contains(search) | tbl.lastName.contains(search));
    }

    final localPatients = await query.get();

    // Convert to PatientModel
    final patients = localPatients.map((p) => PatientModel(
          id: p.id,
          firstName: p.firstName,
          lastName: p.lastName,
          dateOfBirth: p.dateOfBirth,
          gender: p.gender,
          address: p.address,
          phone: p.phone,
          nationalId: p.nationalId,
          householdId: p.householdId,
          createdAt: p.createdAt,
          updatedAt: p.updatedAt,
        )).toList();

    // If online, sync in background
    final isOnline = await _connectivity.checkConnectivity();
    if (isOnline) {
      _syncPatientsInBackground();
    }

    return patients;
  }

  // Create patient (offline-first)
  Future<PatientModel> createPatient(CreatePatientRequest request) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    // Save to local database
    await _db.into(_db.patients).insert(
      PatientsCompanion.insert(
        id: id,
        firstName: request.firstName,
        lastName: request.lastName,
        dateOfBirth: request.dateOfBirth,
        gender: request.gender,
        address: request.address,
        phone: Value(request.phone),
        nationalId: Value(request.nationalId),
        householdId: Value(request.householdId),
        createdAt: now,
        updatedAt: now,
        syncStatus: const Value('pending'),
      ),
    );

    // Add to sync queue
    await _queueService.addToQueue(
      operation: 'CREATE',
      entityType: 'Patient',
      entityId: id,
      payload: request.toJson(),
    );

    // If online, try to sync immediately
    final isOnline = await _connectivity.checkConnectivity();
    if (isOnline) {
      try {
        final response = await _apiClient.dio.post(
          '/patients',
          data: request.toJson(),
        );
        
        // Update local with server ID
        final serverPatient = PatientModel.fromJson(response.data);
        await _updateLocalPatient(id, serverPatient);
        
        return serverPatient;
      } catch (e) {
        // Failed to sync, will retry later
        print('Failed to sync patient creation: $e');
      }
    }

    // Return local patient
    return PatientModel(
      id: id,
      firstName: request.firstName,
      lastName: request.lastName,
      dateOfBirth: request.dateOfBirth,
      gender: request.gender,
      address: request.address,
      phone: request.phone,
      nationalId: request.nationalId,
      householdId: request.householdId,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Update local patient with server data
  Future<void> _updateLocalPatient(String localId, PatientModel serverPatient) async {
    await (_db.update(_db.patients)..where((tbl) => tbl.id.equals(localId)))
        .write(PatientsCompanion(
      id: Value(serverPatient.id),
      syncStatus: const Value('synced'),
    ));
  }

  // Sync patients in background
  Future<void> _syncPatientsInBackground() async {
    try {
      final response = await _apiClient.dio.get('/patients');
      final List<dynamic> data = response.data['data'] ?? response.data;

      for (final json in data) {
        final patient = PatientModel.fromJson(json);
        await _db.into(_db.patients).insertOnConflictUpdate(
          PatientsCompanion.insert(
            id: patient.id,
            firstName: patient.firstName,
            lastName: patient.lastName,
            dateOfBirth: patient.dateOfBirth,
            gender: patient.gender,
            address: patient.address,
            phone: Value(patient.phone),
            nationalId: Value(patient.nationalId),
            householdId: Value(patient.householdId),
            createdAt: patient.createdAt,
            updatedAt: patient.updatedAt,
            syncStatus: const Value('synced'),
          ),
        );
      }
    } catch (e) {
      print('Background sync failed: $e');
    }
  }
}
