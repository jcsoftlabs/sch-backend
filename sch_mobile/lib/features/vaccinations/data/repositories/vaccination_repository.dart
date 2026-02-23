import '../../../../core/network/api_client.dart';
import '../models/vaccination_model.dart';
import 'package:dio/dio.dart';

class VaccinationRepository {
  final ApiClient _apiClient;

  VaccinationRepository(this._apiClient);

  /// Fetch vaccinations for a specific patient
  Future<List<VaccinationModel>> getVaccinationsByPatient(String patientId) async {
    try {
      final response = await _apiClient.dio.get('/vaccinations/patient/$patientId');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data']['vaccinations'];
        return data.map((json) => VaccinationModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw _handleError(e);
    }
  }

  /// Create a new vaccination record
  Future<VaccinationModel> createVaccination(VaccinationModel vaccination) async {
    try {
      // Don't send the sync status or internal ID to the backend if it's a local UUID
      final payload = vaccination.toJson();
      payload.remove('isSynced');
      // If the ID is a local UUID, the DB should generate one or process it
      
      final response = await _apiClient.dio.post(
        '/vaccinations',
        data: payload,
      );

      if (response.statusCode == 201 && response.data['status'] == 'success') {
        return VaccinationModel.fromJson(response.data['data']['vaccination']);
      }
      throw Exception('Failed to create vaccination');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get vaccinations that are due
  Future<List<VaccinationModel>> getDueVaccinations() async {
     try {
      final response = await _apiClient.dio.get('/vaccinations/due');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data']['vaccinations'];
        return data.map((json) => VaccinationModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return Exception(data['message']);
      }
      return Exception('Server error: ${e.response?.statusCode}');
    }
    return Exception('Network error: Please check your connection');
  }
}
