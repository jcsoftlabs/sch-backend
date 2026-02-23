import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/repositories/offline_maternal_care_repository.dart';
import '../../data/models/maternal_care_model.dart';

final maternalCareRepositoryProvider = Provider<OfflineMaternalCareRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineMaternalCareRepository(db);
});

final patientMaternalCareProvider = FutureProvider.family<List<MaternalCareModel>, String>((ref, patientId) async {
  final repository = ref.watch(maternalCareRepositoryProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (await connectivity.checkConnectivity()) {
    try {
      final response = await apiClient.dio.get('/maternal-care/patient/$patientId');
      final data = response.data['data']['maternalCares'] as List;
      final apiRecords = data.map((json) => MaternalCareModel.fromJson(json)).toList();
      await repository.syncMaternalCares(apiRecords);
    } catch (e) {
      // ignore, load locally directly
    }
  }

  return repository.getMaternalCaresByPatient(patientId);
});
