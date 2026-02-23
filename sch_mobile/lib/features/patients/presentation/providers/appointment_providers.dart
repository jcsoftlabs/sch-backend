import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/offline_appointment_repository.dart';
import '../../data/models/appointment_model.dart';

final appointmentRepositoryProvider = Provider<OfflineAppointmentRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineAppointmentRepository(db);
});

final upcomingAppointmentsProvider = FutureProvider.autoDispose<List<AppointmentModel>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final authState = ref.watch(authProvider);
  
  if (authState.user == null) return [];

  final agentId = authState.user!.id;

  if (await connectivity.checkConnectivity()) {
    try {
      final response = await apiClient.dio.get('/appointments/agent/$agentId/upcoming');
      final data = response.data['data']['appointments'] as List;
      final apiRecords = data.map((json) => AppointmentModel.fromJson(json)).toList();
      await repository.syncAppointments(apiRecords);
    } catch (e) {
      // ignore, fallback to local database
    }
  }

  return repository.getUpcomingAppointmentsByAgent(agentId);
});

final patientAppointmentsProvider = FutureProvider.family<List<AppointmentModel>, String>((ref, patientId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  
  if (await connectivity.checkConnectivity()) {
    try {
      final response = await apiClient.dio.get('/appointments/patient/$patientId');
      final data = response.data['data']['appointments'] as List;
      final apiRecords = data.map((json) => AppointmentModel.fromJson(json)).toList();
      await repository.syncAppointments(apiRecords);
    } catch (e) {
      // ignore, fallback to local database
    }
  }

  return repository.getAppointmentsByPatient(patientId);
});
