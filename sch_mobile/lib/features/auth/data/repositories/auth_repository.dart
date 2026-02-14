import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );

      print('🔍 Login response data: ${response.data}');
      print('🔍 Response type: ${response.data.runtimeType}');
      
      // Backend returns: {status: "success", data: {user, accessToken, refreshToken}}
      // We need to extract the data object and map accessToken -> token
      final data = response.data['data'] as Map<String, dynamic>;
      final loginData = {
        'token': data['accessToken'],
        'refreshToken': data['refreshToken'],
        'user': data['user'],
      };
      
      return LoginResponse.fromJson(loginData);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      // Log error but don't throw - allow local logout
      print('Logout API error: ${e.message}');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      return UserModel.fromJson(response.data);
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
        case 401:
          return 'Email ou mot de passe incorrect';
        case 403:
          return 'Accès refusé';
        case 404:
          return 'Service non disponible';
        case 500:
          return 'Erreur serveur. Veuillez réessayer.';
        default:
          return message;
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Délai de connexion dépassé';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Pas de connexion internet. Mode offline activé.';
    } else {
      return 'Une erreur est survenue';
    }
  }
}
