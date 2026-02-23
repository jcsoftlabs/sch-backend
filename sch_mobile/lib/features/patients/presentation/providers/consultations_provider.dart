import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/consultations_repository.dart';
import '../../data/models/consultation_model.dart';

final consultationsRepositoryProvider = Provider<ConsultationsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ConsultationsRepository(apiClient);
});

final patientConsultationsProvider = FutureProvider.family<List<ConsultationModel>, String>((ref, patientId) async {
  final repository = ref.watch(consultationsRepositoryProvider);
  return repository.getConsultationsByPatient(patientId);
});
