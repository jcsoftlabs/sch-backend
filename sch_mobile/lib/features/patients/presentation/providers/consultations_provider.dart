import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/offline_consultations_repository.dart';
import '../../data/models/consultation_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/services/connectivity_service.dart';

final consultationsRepositoryProvider = Provider<OfflineConsultationsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineConsultationsRepository(db);
});

final patientConsultationsProvider = FutureProvider.family<List<ConsultationModel>, String>((ref, patientId) async {
  final repository = ref.watch(consultationsRepositoryProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (await connectivity.checkConnectivity()) {
    try {
      final response = await apiClient.dio.get('/consultations/patient/$patientId');
      final data = response.data['data']['consultations'] as List;
      final apiConsultations = data.map((json) => ConsultationModel.fromJson(json)).toList();
      await repository.syncConsultations(apiConsultations);
    } catch (e) {
      // ignore, fetch from local cache
    }
  }

  return repository.getConsultationsByPatient(patientId);
});
