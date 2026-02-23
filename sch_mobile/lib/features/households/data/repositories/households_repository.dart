import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/household_model.dart';
import '../models/household_member_model.dart';

class HouseholdsRepository {
  final ApiClient _apiClient;

  HouseholdsRepository(this._apiClient);

  // ========== Households ==========

  /// Get all households for the current agent
  Future<List<HouseholdModel>> getHouseholds() async {
    try {
      final response = await _apiClient.dio.get('/households');
      
      // DEBUG: Print raw response
      print('🔍 HOUSEHOLDS RAW RESPONSE: ${response.data}');
      print('🔍 HOUSEHOLDS RESPONSE TYPE: ${response.data.runtimeType}');
      
      // Handle different response structures
      dynamic rawData = response.data;
      
      // If response is wrapped in {status, data}, extract data
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        print('🔍 HOUSEHOLDS: Extracting data from Map');
        rawData = rawData['data'];
        print('🔍 HOUSEHOLDS DATA TYPE: ${rawData.runtimeType}');
        print('🔍 HOUSEHOLDS DATA: $rawData');
      }
      
      // Backend returns {households: [...]} instead of [...]
      // Extract the households array
      if (rawData is Map<String, dynamic> && rawData.containsKey('households')) {
        print('🔍 HOUSEHOLDS: Extracting households array from nested Map');
        rawData = rawData['households'];
        print('🔍 HOUSEHOLDS ARRAY: ${(rawData as List).length} items');
      }
      
      // Ensure we have a List
      if (rawData is! List) {
        print('❌ HOUSEHOLDS ERROR: Expected List but got ${rawData.runtimeType}');
        print('❌ HOUSEHOLDS DATA CONTENT: $rawData');
        throw Exception('Expected List but got ${rawData.runtimeType}');
      }
      
      print('✅ HOUSEHOLDS: Successfully got List with ${(rawData as List).length} items');
      return (rawData as List).map((json) => HouseholdModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single household by ID
  Future<HouseholdModel> getHousehold(String id) async {
    try {
      final response = await _apiClient.dio.get('/households/$id');
      final data = response.data['data'] ?? response.data;
      return HouseholdModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new household
  Future<HouseholdModel> createHousehold(HouseholdModel household) async {
    try {
      final response = await _apiClient.dio.post(
        '/households',
        data: household.toJson(),
      );
      final data = response.data['data'] ?? response.data;
      return HouseholdModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing household
  Future<HouseholdModel> updateHousehold(
      String id, HouseholdModel household) async {
    try {
      final response = await _apiClient.dio.put(
        '/households/$id',
        data: household.toJson(),
      );
      final data = response.data['data'] ?? response.data;
      return HouseholdModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a household
  Future<void> deleteHousehold(String id) async {
    try {
      await _apiClient.dio.delete('/households/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== Household Members ==========

  /// Get all members of a household
  Future<List<HouseholdMemberModel>> getHouseholdMembers(
      String householdId) async {
    try {
      final response =
          await _apiClient.dio.get('/households/$householdId/members');
      
      // Handle different response structures
      dynamic rawData = response.data;
      
      // If response is wrapped in {status, data}, extract data
      if (rawData is Map<String, dynamic> && rawData.containsKey('data')) {
        rawData = rawData['data'];
      }
      
      // Backend might return {members: [...]} instead of [...]
      if (rawData is Map<String, dynamic> && rawData.containsKey('members')) {
        rawData = rawData['members'];
      }
      
      // Ensure we have a List
      if (rawData is! List) {
        throw Exception('Expected List but got ${rawData.runtimeType}');
      }
      
      return (rawData as List).map((json) => HouseholdMemberModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Add a member to a household
  Future<HouseholdMemberModel> addHouseholdMember(
    String householdId,
    HouseholdMemberModel member,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/households/$householdId/members',
        data: member.toJson(),
      );
      final data = response.data['data'] ?? response.data;
      return HouseholdMemberModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update a household member
  Future<HouseholdMemberModel> updateHouseholdMember(
    String householdId,
    String memberId,
    HouseholdMemberModel member,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        '/households/$householdId/members/$memberId',
        data: member.toJson(),
      );
      final data = response.data['data'] ?? response.data;
      return HouseholdMemberModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a household member
  Future<void> deleteHouseholdMember(String householdId, String memberId) async {
    try {
      await _apiClient.dio.delete('/households/$householdId/members/$memberId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ========== Error Handling ==========

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final message = error.response?.data['message'] ?? 'Une erreur est survenue';
      return Exception(message);
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Délai d\'attente dépassé. Vérifiez votre connexion.');
    } else if (error.type == DioExceptionType.connectionError) {
      return Exception('Erreur de connexion. Vérifiez votre connexion internet.');
    } else {
      return Exception('Une erreur inattendue est survenue');
    }
  }
}
