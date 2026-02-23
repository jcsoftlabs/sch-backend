import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/case_report_model.dart';
import '../models/triage_result_model.dart';

class CreateCaseReportDto {
  final String agentId;
  final String? patientId;
  final String symptoms;
  final UrgencyLevel urgency;
  final CaseChannel channel;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? zone;

  CreateCaseReportDto({
    required this.agentId,
    this.patientId,
    required this.symptoms,
    required this.urgency,
    this.channel = CaseChannel.app,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.zone,
  });

  Map<String, dynamic> toJson() => {
        'agentId': agentId,
        if (patientId != null) 'patientId': patientId,
        'symptoms': symptoms,
        'urgency': urgency.name.toUpperCase(),
        'channel': channel.name.toUpperCase(),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (zone != null) 'zone': zone,
      };
}

class UpdateCaseReportDto {
  final String? response;
  final CaseReportStatus? status;
  final bool? referral;

  UpdateCaseReportDto({
    this.response,
    this.status,
    this.referral,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (response != null) map['response'] = response;
    if (status != null) map['status'] = status!.name.toUpperCase();
    if (referral != null) map['referral'] = referral;
    return map;
  }
}

class CaseReportRepository {
  final ApiClient _apiClient;

  CaseReportRepository(this._apiClient);

  /// Get all case reports for a specific agent
  Future<List<CaseReportModel>> getCaseReports(String agentId) async {
    try {
      final response = await _apiClient.dio.get('/case-reports/agent/$agentId');

      print('🔍 CASE REPORTS RAW RESPONSE: ${response.data}');
      print('🔍 CASE REPORTS RESPONSE TYPE: ${response.data.runtimeType}');

      // Handle different response structures
      dynamic rawData = response.data;

      // If response is wrapped in {status, data}, extract data
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        print('🔍 CASE REPORTS: Extracting data from Map');
        rawData = rawData['data'];
        print('🔍 CASE REPORTS DATA TYPE: ${rawData.runtimeType}');
      }

      // Backend might return {caseReports: [...]} instead of [...]
      if (rawData is Map<String, dynamic> && rawData.containsKey('caseReports')) {
        print('🔍 CASE REPORTS: Extracting caseReports array from nested Map');
        rawData = rawData['caseReports'];
      }

      // Ensure we have a List
      if (rawData is! List) {
        print('❌ CASE REPORTS ERROR: Expected List but got ${rawData.runtimeType}');
        throw Exception('Expected List but got ${rawData.runtimeType}');
      }

      print('✅ CASE REPORTS: Successfully got List with ${(rawData as List).length} items');
      
      return (rawData as List)
          .map((json) => CaseReportModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new case report
  Future<CaseReportModel> createCaseReport(CreateCaseReportDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/case-reports',
        data: dto.toJson(),
      );

      print('🔍 CREATE CASE REPORT RESPONSE: ${response.data}');

      // Handle response structure
      dynamic rawData = response.data;
      
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        rawData = rawData['data'];
      }

      return CaseReportModel.fromJson(rawData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing case report
  Future<CaseReportModel> updateCaseReport(
    String id,
    UpdateCaseReportDto dto,
  ) async {
    try {
      final response = await _apiClient.dio.patch(
        '/case-reports/$id',
        data: dto.toJson(),
      );

      // Handle response structure
      dynamic rawData = response.data;
      
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        rawData = rawData['data'];
      }

      return CaseReportModel.fromJson(rawData as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Analyze symptoms and create case report in one call
  /// This endpoint should trigger triage on the backend
  Future<Map<String, dynamic>> analyzeSymptomsAndCreate(
    CreateCaseReportDto dto,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/case-reports/triage',
        data: dto.toJson(),
      );

      print('🔍 TRIAGE RESPONSE: ${response.data}');

      // Expected response: { caseReport: {...}, triageResult: {...} }
      dynamic rawData = response.data;
      
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        rawData = rawData['data'];
      }

      return rawData as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data is Map
          ? (e.response!.data['message'] ?? 'Une erreur est survenue')
          : 'Une erreur est survenue';
      
      switch (statusCode) {
        case 400:
          return Exception('Données invalides: $message');
        case 401:
          return Exception('Non autorisé. Veuillez vous reconnecter.');
        case 403:
          return Exception('Accès refusé.');
        case 404:
          return Exception('Cas non trouvé.');
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
