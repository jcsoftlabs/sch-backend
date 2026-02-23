import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/vital_signs_repository.dart';
import '../../data/models/vital_sign_model.dart';

final vitalSignsRepositoryProvider = Provider<VitalSignsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VitalSignsRepository(apiClient);
});

final patientVitalSignsProvider = FutureProvider.family<List<VitalSignModel>, String>((ref, patientId) async {
  final repository = ref.watch(vitalSignsRepositoryProvider);
  return repository.getVitalSignsByPatient(patientId);
});
