class AppConstants {
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://sch-backend-production.up.railway.app',
  );
  
  static const String apiVersion = '/api';
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyLastSyncTime = 'last_sync_time';
  
  // Sync Configuration
  static const Duration syncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Database
  static const String databaseName = 'sch_mobile.db';
  static const int databaseVersion = 2;
  
  // Validation
  static const String haitianPhoneRegex = r'^\+?509[0-9]{8}$';
  static const int minPasswordLength = 8;
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableOfflineMode = true;
  static const bool enablePhotoCapture = true;
}
