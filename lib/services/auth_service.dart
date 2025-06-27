import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService(baseUrl: AppConfig.apiUrl);
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
  
  // Get token from storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Get current user from storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  
  // Get auth headers for API requests
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token != null) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
  }
    // Login user
  Future<ApiResponse> login(String email, String password) async {
    final response = await _apiService.post('auth/login', {
      'email': email,
      'password': password,
    });
    
    if (response.success && response.data != null) {
      final prefs = await SharedPreferences.getInstance();
      // Use token format from web backend
      await prefs.setString('auth_token', response.data['token']);
      
      // Fetch user profile after login
      final userProfileResponse = await _apiService.get(
        'auth/me',
        additionalHeaders: {'Authorization': 'Bearer ${response.data['token']}'}
      );
      
      if (userProfileResponse.success && userProfileResponse.data != null) {
        await prefs.setString('user_data', jsonEncode(userProfileResponse.data));
      }
    }
    
    return response;
  }
  
  // Register user
  Future<ApiResponse> register(Map<String, dynamic> userData) async {
    return await _apiService.post('auth/register', userData);
  }
  
  // Logout user
  Future<void> logout() async {
    try {
      final headers = await getAuthHeaders();
      await _apiService.post('auth/logout', {}, additionalHeaders: headers);
    } catch (e) {
      // Ignore errors during logout
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    }
  }

  // Update profile
  Future<ApiResponse> updateProfile(Map<String, dynamic> userData) async {
    final headers = await getAuthHeaders();
    return await _apiService.put('auth/profile', userData, additionalHeaders: headers);
  }

  // Change password
  Future<ApiResponse> changePassword(String currentPassword, String newPassword) async {
    final headers = await getAuthHeaders();
    return await _apiService.post('auth/change-password', {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPassword,
    }, additionalHeaders: headers);
  }

  // Request password reset
  Future<ApiResponse> requestPasswordReset(String email) async {
    return await _apiService.post('auth/forgot-password', {
      'email': email,
    });
  }

  // Reset password with token
  Future<ApiResponse> resetPassword(String token, String email, String password) async {
    return await _apiService.post('auth/reset-password', {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
  }
}
