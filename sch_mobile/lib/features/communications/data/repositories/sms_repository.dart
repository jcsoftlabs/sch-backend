import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/sms_request_model.dart';

class SmsRepository {
  final ApiClient _apiClient;

  SmsRepository(this._apiClient);

  Future<void> sendSms(SmsRequestModel request) async {
    try {
      await _apiClient.dio.post(
        '/sms/send',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data['message'] ?? 'Erreur lors de l\'envoi du SMS';

      switch (statusCode) {
        case 400:
          return 'Numéro de téléphone invalide';
        case 403:
          return 'Non autorisé à envoyer des SMS';
        case 500:
          return 'Erreur du serveur SMS (Vonage). Veuillez réessayer plus tard.';
        default:
          return message;
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Délai d\'attente dépassé';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Pas de connexion Internet. Impossible d\'utiliser le serveur.';
    } else {
      return 'Une erreur réseau est survenue';
    }
  }
}
