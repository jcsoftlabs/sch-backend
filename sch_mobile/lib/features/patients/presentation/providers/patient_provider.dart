import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository.dart';

// Repository Provider
final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PatientRepository(apiClient);
});

// Patients List Provider
final patientsProvider = FutureProvider.family<List<PatientModel>, String?>(
  (ref, search) async {
    final repository = ref.watch(patientRepositoryProvider);
    return repository.getPatients(search: search);
  },
);

// Single Patient Provider
final patientProvider = FutureProvider.family<PatientModel, String>(
  (ref, id) async {
    final repository = ref.watch(patientRepositoryProvider);
    return repository.getPatientById(id);
  },
);

// Patient Form State
class PatientFormState {
  final bool isLoading;
  final String? error;
  final PatientModel? savedPatient;

  PatientFormState({
    this.isLoading = false,
    this.error,
    this.savedPatient,
  });

  PatientFormState copyWith({
    bool? isLoading,
    String? error,
    PatientModel? savedPatient,
  }) {
    return PatientFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedPatient: savedPatient ?? this.savedPatient,
    );
  }
}

// Patient Form Notifier
class PatientFormNotifier extends StateNotifier<PatientFormState> {
  final PatientRepository _repository;

  PatientFormNotifier(this._repository) : super(PatientFormState());

  Future<bool> createPatient(CreatePatientRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final patient = await _repository.createPatient(request);
      state = state.copyWith(
        isLoading: false,
        savedPatient: patient,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updatePatient(String id, CreatePatientRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final patient = await _repository.updatePatient(id, request);
      state = state.copyWith(
        isLoading: false,
        savedPatient: patient,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = PatientFormState();
  }
}

// Patient Form Provider
final patientFormProvider =
    StateNotifierProvider<PatientFormNotifier, PatientFormState>((ref) {
  final repository = ref.watch(patientRepositoryProvider);
  return PatientFormNotifier(repository);
});
