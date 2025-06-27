import 'package:flutter/foundation.dart';

class AppConfig {
  // Backend API URLs - Point to your web backend
  static const String devApiUrl = 'http://10.0.2.2:5000/api'; // For Android emulator
  static const String prodApiUrl = 'https://api.sachir-vehicle-care.com/api';
  
  // Set to devApiUrl for development, change to prodApiUrl for production
  static const String apiUrl = kDebugMode ? devApiUrl : prodApiUrl;
  
  // API endpoint prefix for mobile routes
  static const String mobileApiPrefix = '/mobile';
  
  // Web API endpoints - standard endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/auth/me';
  
  // Mobile-specific API endpoints
  static const String userDashboardEndpoint = '/mobile/user-dashboard';
  static const String vehiclesEndpoint = '/mobile/vehicles';
  static const String bookingsEndpoint = '/mobile/bookings';
  static const String servicesEndpoint = '/mobile/services';
  
  // App settings
  static const String appName = 'SachiR Vehicle Care';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  
  // Local storage keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
}
