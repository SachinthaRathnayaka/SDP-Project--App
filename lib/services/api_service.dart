import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/api_response.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> headers;

  ApiService({
    required this.baseUrl,
    this.headers = const {
      'Content-Type': 'application/json',
      'X-Mobile-Api-Key': 'sachir_mobile_app_secret_key',
    },
  });

  Future<ApiResponse> get(String endpoint, {Map<String, String>? additionalHeaders}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...headers, ...?additionalHeaders},
      ).timeout(Duration(milliseconds: AppConfig.connectionTimeout));
      
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> post(String endpoint, dynamic data, {Map<String, String>? additionalHeaders}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...headers, ...?additionalHeaders},
        body: jsonEncode(data),
      ).timeout(Duration(milliseconds: AppConfig.connectionTimeout));
      
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> put(String endpoint, dynamic data, {Map<String, String>? additionalHeaders}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...headers, ...?additionalHeaders},
        body: jsonEncode(data),
      ).timeout(Duration(milliseconds: AppConfig.connectionTimeout));
      
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse> delete(String endpoint, {Map<String, String>? additionalHeaders}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {...headers, ...?additionalHeaders},
      ).timeout(Duration(milliseconds: AppConfig.connectionTimeout));
      
      return _processResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  ApiResponse _processResponse(http.Response response) {
    try {
      final responseData = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: responseData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseData?['message'] ?? 'An error occurred',
          statusCode: response.statusCode,
          data: responseData,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to process response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }
}
