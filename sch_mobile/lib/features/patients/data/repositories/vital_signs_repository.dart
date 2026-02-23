import '../../../../core/network/api_client.dart';
import '../models/vital_sign_model.dart';
import 'package:dio/dio.dart';

class VitalSignsRepository {
  final ApiClient _apiClient;

  VitalSignsRepository(this._apiClient);

  Future<List<VitalSignModel>> getVitalSignsByPatient(String patientId) async {
    try {
      final response = await _apiClient.dio.get('/vital-signs/patient/$patientId');
      final data = response.data['data']['vitalSigns'] as List;
      return data.map((json) => VitalSignModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erreur lors du chargement des constantes vitales');
    }
  }

  Future<VitalSignModel> createVitalSign(String patientId, VitalSignModel model) async {
    try {
      final response = await _apiClient.dio.post(
        '/vital-signs/patient/$patientId',
        data: model.toJson(),
      );
      return VitalSignModel.fromJson(response.data['data']['vitalSign']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erreur lors de l\'ajout des constantes vitales');
    }
  }
}
