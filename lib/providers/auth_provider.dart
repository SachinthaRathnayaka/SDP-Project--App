import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../models/api_response.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoggedIn = false;
  bool _isLoading = false;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  // Constructor - Check if user is already logged in
  AuthProvider() {
    _checkLoginStatus();
  }

  // Check if user is logged in
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _authService.login(email, password);
      
      _isLoggedIn = response.success;
      
      if (response.success) {
        _currentUser = await _authService.getCurrentUser();
      } else {
        _errorMessage = response.message ?? 'Login failed. Please try again.';
      }
      
      return response.success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoggedIn = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register user
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _authService.register(userData);
      
      if (response.success) {
        // Login after successful registration
        return await login(userData['email'], userData['password']);
      } else {
        _errorMessage = response.message ?? 'Registration failed. Please try again.';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _isLoggedIn = false;
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _authService.updateProfile(userData);
      
      if (response.success) {
        await _checkLoginStatus(); // Refresh user data
        return true;
      } else {
        _errorMessage = response.message ?? 'Profile update failed. Please try again.';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _authService.changePassword(
        currentPassword, 
        newPassword
      );
      
      if (!response.success) {
        _errorMessage = response.message ?? 'Password change failed. Please try again.';
      }
      
      return response.success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Request password reset
  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _authService.requestPasswordReset(email);
      
      if (!response.success) {
        _errorMessage = response.message ?? 'Password reset request failed. Please try again.';
      }
      
      return response.success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
