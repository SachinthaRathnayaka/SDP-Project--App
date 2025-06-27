import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/workshop_service.dart';
import 'api_service.dart';
import 'auth_service.dart';

class ServiceService {
  final ApiService _apiService = ApiService(baseUrl: AppConfig.apiUrl);
  final AuthService _authService = AuthService();
  
  // Get all available services - using mobile endpoint from web backend
  Future<ApiResponse> getAvailableServices() async {
    // This endpoint is public, so we don't need auth headers
    return await _apiService.get('mobile/services');
  }
  
  // Get service by ID - using mobile endpoint from web backend
  Future<ApiResponse> getServiceById(String id) async {
    return await _apiService.get('mobile/services/$id');
  }
  
  // Get service categories - using mobile endpoint from web backend
  Future<ApiResponse> getServiceCategories() async {
    return await _apiService.get('mobile/services/categories');
  }
    // Parse services from API response
  List<WorkshopService> parseServices(ApiResponse response) {
    if (!response.success || response.data == null) {
      return [];
    }
    
    List<WorkshopService> services = [];
    for (var item in response.data['data']) {
      services.add(WorkshopService.fromJson(item));
    }
    
    return services;
  }
}
