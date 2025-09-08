class AppConstants {
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  static const String apiVersion = 'v1';

  // Authentication
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';

  // Storage Keys
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Firebase Configuration
  static const String fcmTokenKey = 'fcm_token';

  // Group Settings
  static const int maxGroupMembers = 50;
  static const int maxGroupNameLength = 100;
  static const int maxTurnHistoryDays = 30;

  // Turn Algorithms
  static const String defaultTurnAlgorithm = 'round_robin';
  static const List<String> availableAlgorithms = [
    'round_robin',
    'random',
    'weighted',
    'manual',
  ];

  // UI Configuration
  static const int pageSize = 20;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
}
