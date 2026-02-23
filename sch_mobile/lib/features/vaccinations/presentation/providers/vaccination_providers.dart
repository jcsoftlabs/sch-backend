import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/models/vaccination_model.dart';
import '../../data/repositories/offline_vaccination_repository.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../domain/services/vaccination_sync_service.dart';

// ============================================================================
// Repository & Service Providers
// ============================================================================

final vaccinationRepositoryProvider = Provider<VaccinationRepository>((ref) {
  return VaccinationRepository(ApiClient());
});

final offlineVaccinationRepositoryProvider =
    Provider<OfflineVaccinationRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineVaccinationRepository(db);
});

final vaccinationSyncServiceProvider = Provider<VaccinationSyncService>((ref) {
  return VaccinationSyncService(
    ref.read(vaccinationRepositoryProvider),
    ref.read(offlineVaccinationRepositoryProvider),
  );
});

// ============================================================================
// State Providers
// ============================================================================

/// Provider for vaccinations of a specific patient
final patientVaccinationsProvider = StateNotifierProvider.family<
    PatientVaccinationsNotifier,
    AsyncValue<List<VaccinationModel>>,
    String>((ref, patientId) {
  return PatientVaccinationsNotifier(
    ref.read(vaccinationRepositoryProvider),
    ref.read(offlineVaccinationRepositoryProvider),
    patientId,
  );
});

class PatientVaccinationsNotifier
    extends StateNotifier<AsyncValue<List<VaccinationModel>>> {
  final VaccinationRepository _onlineRepo;
  final OfflineVaccinationRepository _offlineRepo;
  final String patientId;

  PatientVaccinationsNotifier(
      this._onlineRepo, this._offlineRepo, this.patientId)
      : super(const AsyncValue.loading()) {
    loadVaccinations();
  }

  Future<void> loadVaccinations() async {
    state = const AsyncValue.loading();

    try {
      // 1. Fetch from backend
      final onlineVaccinations =
          await _onlineRepo.getVaccinationsByPatient(patientId);

      // 2. Save/Update locally
      for (final vac in onlineVaccinations) {
        await _offlineRepo.saveVaccination(vac);
      }
    } catch (e) {
      // Non-blocking: If network fails, we just rely on the local DB
    }

    // 3. Always serve from local DB as source of truth
    try {
      final localVaccinations =
          await _offlineRepo.getVaccinationsByPatient(patientId);
      state = AsyncValue.data(localVaccinations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addVaccination(VaccinationModel vaccination) async {
    try {
      // Save locally first for immediate UI response
      await _offlineRepo.saveVaccination(vaccination);
      
      // Reload state
      final currentVaccinations =
          await _offlineRepo.getVaccinationsByPatient(patientId);
      state = AsyncValue.data(currentVaccinations);

      // Try syncing immediately
      try {
        await _onlineRepo.createVaccination(vaccination);
        await _offlineRepo.markAsSynced(vaccination.id!);
      } catch (e) {
        // Leave it as unsynced, the background job will handle it later
      }
    } catch (e, st) {
      state = AsyncValue.error('Échec de l\'enregistrement: $e', st);
    }
  }
}

/// Provider for due vaccinations across the agent's patients
final dueVaccinationsProvider = StateNotifierProvider<DueVaccinationsNotifier,
    AsyncValue<List<VaccinationModel>>>((ref) {
  return DueVaccinationsNotifier(
    ref.read(vaccinationRepositoryProvider),
    ref.read(offlineVaccinationRepositoryProvider),
  );
});

class DueVaccinationsNotifier
    extends StateNotifier<AsyncValue<List<VaccinationModel>>> {
  final VaccinationRepository _onlineRepo;
  final OfflineVaccinationRepository _offlineRepo;

  DueVaccinationsNotifier(this._onlineRepo, this._offlineRepo)
      : super(const AsyncValue.loading()) {
    loadDueVaccinations();
  }

  Future<void> loadDueVaccinations() async {
    state = const AsyncValue.loading();

    try {
      // For immediate offline availability, load from local DB first
      final localDue = await _offlineRepo.getDueVaccinations();
      if (localDue.isNotEmpty) {
         state = AsyncValue.data(localDue);
      }

      // Sync with server if possible
      try {
        final onlineDue = await _onlineRepo.getDueVaccinations();
        // Here we could implement more complex sync, but for alerts finding them locally
        // is usually more accurate for the current active agent.
        // We'll trust the local DB primarily for the agent's patients.
        if (onlineDue.isNotEmpty && localDue.isEmpty) {
          state = AsyncValue.data(onlineDue);
        }
      } catch (_) {}
      
      if (localDue.isEmpty) {
         state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
