import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/repositories/offline_nutrition_repository.dart';
import '../../data/models/nutrition_record_model.dart';

final nutritionRepositoryProvider = Provider<OfflineNutritionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineNutritionRepository(db);
});

final patientNutritionProvider = FutureProvider.family<List<NutritionRecordModel>, String>((ref, patientId) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (await connectivity.checkConnectivity()) {
    try {
      final response = await apiClient.dio.get('/nutrition/patient/$patientId');
      final data = response.data['data']['nutritionRecords'] as List;
      final apiRecords = data.map((json) => NutritionRecordModel.fromJson(json)).toList();
      await repository.syncNutritionRecords(apiRecords);
    } catch (e) {
      // ignore, fallback to local database
    }
  }

  return repository.getNutritionRecordsByPatient(patientId);
});
