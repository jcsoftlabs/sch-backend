import '../../../../core/network/api_client.dart';
import '../models/consultation_model.dart';
import 'package:dio/dio.dart';

class ConsultationsRepository {
  final ApiClient _apiClient;

  ConsultationsRepository(this._apiClient);

  Future<List<ConsultationModel>> getConsultationsByPatient(String patientId) async {
    try {
      final response = await _apiClient.dio.get('/consultations/patient/$patientId');
      final data = response.data['data']['consultations'] as List;
      return data.map((json) => ConsultationModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Erreur lors du chargement de l\'historique des consultations');
    }
  }
}
