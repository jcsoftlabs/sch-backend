import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/medical_protocol_model.dart';

class MedicalProtocolRepository {
  final ApiClient _apiClient;

  MedicalProtocolRepository(this._apiClient);

  /// Get all active medical protocols from backend
  Future<List<MedicalProtocolModel>> getActiveProtocols() async {
    try {
      final response = await _apiClient.dio.get('/medical-protocols');

      print('🔍 PROTOCOLS RAW RESPONSE: ${response.data}');
      print('🔍 PROTOCOLS RESPONSE TYPE: ${response.data.runtimeType}');

      // Handle different response structures
      dynamic rawData = response.data;

      // If response is wrapped in {status, data}, extract data
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        print('🔍 PROTOCOLS: Extracting data from Map');
        rawData = rawData['data'];
        print('🔍 PROTOCOLS DATA TYPE: ${rawData.runtimeType}');
      }

      // Backend might return {protocols: [...]} instead of [...]
      if (rawData is Map<String, dynamic> && rawData.containsKey('protocols')) {
        print('🔍 PROTOCOLS: Extracting protocols array from nested Map');
        rawData = rawData['protocols'];
      }

      // Ensure we have a List
      if (rawData is! List) {
        print('❌ PROTOCOLS ERROR: Expected List but got ${rawData.runtimeType}');
        throw Exception('Expected List but got ${rawData.runtimeType}');
      }

      print('✅ PROTOCOLS: Successfully got List with ${(rawData as List).length} items');
      
      return (rawData as List)
          .map((json) => MedicalProtocolModel.fromJson(json))
          .where((protocol) => protocol.isActive)
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Sync protocols from backend to local database
  /// This should be called periodically to keep local protocols up-to-date
  Future<void> syncProtocols() async {
    // TODO: Implement sync logic with Drift database
    // 1. Fetch protocols from backend
    // 2. Store in local MedicalProtocols table
    // 3. Update existing protocols
    // 4. Mark inactive protocols
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data['message'] ?? 'Une erreur est survenue';
      
      switch (statusCode) {
        case 401:
          return Exception('Non autorisé. Veuillez vous reconnecter.');
        case 403:
          return Exception('Accès refusé.');
        case 404:
          return Exception('Protocoles non trouvés.');
        case 500:
          return Exception('Erreur serveur. Veuillez réessayer.');
        default:
          return Exception(message);
      }
    }
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai d\'attente dépassé. Vérifiez votre connexion.');
    }
    
    if (e.type == DioExceptionType.unknown) {
      return Exception('Pas de connexion internet. Mode offline activé.');
    }
    
    return Exception('Erreur: ${e.message}');
  }
}
