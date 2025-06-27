import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        data.headers['Authorization'] = 'Bearer $token';
      }
      
      data.headers['Content-Type'] = 'application/json';
      data.headers['Accept'] = 'application/json';
    } catch (e) {
      print('Auth Interceptor Error: $e');
    }
    
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class NetworkService {
  static final client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: Duration(milliseconds: AppConfig.connectionTimeout),
  );
  
  static Future<http.Response> get(String url) async {
    try {
      return await client.get(Uri.parse(url));
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the requested resource");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<http.Response> post(String url, dynamic body) async {
    try {
      return await client.post(Uri.parse(url), body: body);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the requested resource");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<http.Response> put(String url, dynamic body) async {
    try {
      return await client.put(Uri.parse(url), body: body);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the requested resource");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  static Future<http.Response> delete(String url) async {
    try {
      return await client.delete(Uri.parse(url));
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the requested resource");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
