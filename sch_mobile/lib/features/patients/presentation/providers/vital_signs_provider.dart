import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/offline_vital_signs_repository.dart';
import '../../data/models/vital_sign_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/services/connectivity_service.dart';

final vitalSignsRepositoryProvider = Provider<OfflineVitalSignsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineVitalSignsRepository(db);
});

final patientVitalSignsProvider = FutureProvider.family<List<VitalSignModel>, String>((ref, patientId) async {
  final repository = ref.watch(vitalSignsRepositoryProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (await connectivity.checkConnectivity()) {
    try {
      final response = await apiClient.dio.get('/vital-signs/patient/$patientId');
      final data = response.data['data']['vitalSigns'] as List;
      final apiVitals = data.map((json) => VitalSignModel.fromJson(json)).toList();
      await repository.syncVitalSigns(apiVitals);
    } catch (e) {
      // ignore, load locally instead
    }
  }

  return repository.getVitalSignsByPatient(patientId);
});
