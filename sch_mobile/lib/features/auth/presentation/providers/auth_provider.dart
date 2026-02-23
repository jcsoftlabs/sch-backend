import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Providers
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// Auth State
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (token != null) {
      try {
        // Try to get fresh user data from server
        final user = await _repository.getCurrentUser();
        
        // Cache user data for offline use
        await _cacheUserData(user);
        
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
        );
      } catch (e) {
        // If online check fails, try to use cached user data for offline mode
        final cachedUser = await _getCachedUserData();
        
        if (cachedUser != null) {
          // Allow offline access with cached data
          print('📴 Mode offline: Utilisation des données en cache');
          state = state.copyWith(
            user: cachedUser,
            isAuthenticated: true,
          );
        } else {
          // No cached data and can't reach server - logout
          print('❌ Pas de données en cache et pas de connexion');
          await _storage.deleteAll();
          state = state.copyWith(isAuthenticated: false);
        }
      }
    }
  }

  /// Cache user data for offline use
  Future<void> _cacheUserData(UserModel user) async {
    await _storage.write(key: 'cached_user_id', value: user.id);
    await _storage.write(key: 'cached_user_email', value: user.email);
    await _storage.write(key: 'cached_user_name', value: user.name);
    await _storage.write(key: 'cached_user_role', value: user.role);
  }

  /// Get cached user data for offline mode
  Future<UserModel?> _getCachedUserData() async {
    final id = await _storage.read(key: 'cached_user_id');
    final email = await _storage.read(key: 'cached_user_email');
    final name = await _storage.read(key: 'cached_user_name');
    final role = await _storage.read(key: 'cached_user_role');

    if (id != null && email != null && name != null && role != null) {
      return UserModel(
        id: id,
        email: email,
        name: name,
        role: role,
      );
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.login(email, password);

      // Store tokens
      await _storage.write(
        key: AppConstants.keyAuthToken,
        value: response.token,
      );
      if (response.refreshToken != null) {
        await _storage.write(
          key: AppConstants.keyRefreshToken,
          value: response.refreshToken,
        );
      }

      // Store user info (legacy keys)
      await _storage.write(
        key: AppConstants.keyUserId,
        value: response.user.id,
      );
      await _storage.write(
        key: AppConstants.keyUserRole,
        value: response.user.role,
      );

      // Cache user data for offline access
      await _cacheUserData(response.user);

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.logout();
    } catch (e) {
      // Continue with local logout even if API fails
      print('Logout error: $e');
    }

    // Clear all local storage including cached user data
    await _storage.deleteAll();

    state = AuthState(isAuthenticated: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
