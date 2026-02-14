import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final ApiClient _apiClient;

  PatientRepository(this._apiClient);

  Future<List<PatientModel>> getPatients({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _apiClient.dio.get(
        '/patients',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => PatientModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PatientModel> getPatientById(String id) async {
    try {
      final response = await _apiClient.dio.get('/patients/$id');
      return PatientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PatientModel> createPatient(CreatePatientRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/patients',
        data: request.toJson(),
      );
      return PatientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PatientModel> updatePatient(
    String id,
    CreatePatientRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        '/patients/$id',
        data: request.toJson(),
      );
      return PatientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      await _apiClient.dio.delete('/patients/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data['message'] ?? 'Une erreur est survenue';

      switch (statusCode) {
        case 400:
          return 'Données invalides';
        case 404:
          return 'Patient non trouvé';
        case 409:
          return 'Ce patient existe déjà';
        case 500:
          return 'Erreur serveur. Veuillez réessayer.';
        default:
          return message;
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Délai de connexion dépassé';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Pas de connexion internet. Les données seront synchronisées plus tard.';
    } else {
      return 'Une erreur est survenue';
    }
  }
}
