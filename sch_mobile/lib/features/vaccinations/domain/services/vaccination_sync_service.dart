import 'package:logger/logger.dart';
import '../../data/repositories/offline_vaccination_repository.dart';
import '../../data/repositories/vaccination_repository.dart';

/// Background service responsible for synchronizing pending offline vaccinations
/// with the central backend server when connectivity is restored.
class VaccinationSyncService {
  final VaccinationRepository _onlineRepo;
  final OfflineVaccinationRepository _offlineRepo;
  final Logger _logger = Logger();

  VaccinationSyncService(this._onlineRepo, this._offlineRepo);

  /// Find all locally saved vaccinations that haven't been synced
  /// and push them to the backend server
  Future<int> syncPendingVaccinations() async {
    _logger.i('Starting vaccination sync...');
    int syncedCount = 0;

    try {
      final pendingVaccinations = await _offlineRepo.getPendingVaccinations();
      
      if (pendingVaccinations.isEmpty) {
        _logger.i('No pending vaccinations to sync.');
        return 0;
      }

      _logger.i('Found ${pendingVaccinations.length} pending vaccinations to sync.');

      for (final vaccination in pendingVaccinations) {
        try {
          // Push to backend
          await _onlineRepo.createVaccination(vaccination);
          
          // Mark as synced locally
          await _offlineRepo.markAsSynced(vaccination.id!);
          syncedCount++;
          
          _logger.d('Successfully synced vaccination ${vaccination.id}');
        } catch (e) {
          _logger.e('Failed to sync vaccination ${vaccination.id}: $e');
          // Continue with the next one even if this one fails
        }
      }

      _logger.i('Vaccination sync completed. Successfully synced: $syncedCount');
      return syncedCount;
    } catch (e) {
      _logger.e('Error during overall vaccination sync process: $e');
      return syncedCount;
    }
  }
}
