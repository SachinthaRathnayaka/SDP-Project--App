import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/vehicle.dart';
import 'api_service.dart';
import 'auth_service.dart';

class VehicleService {
  final ApiService _apiService = ApiService(baseUrl: AppConfig.apiUrl);
  final AuthService _authService = AuthService();
    // Get all user vehicles - using mobile endpoint from web backend
  Future<ApiResponse> getUserVehicles() async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.get('mobile/vehicles', additionalHeaders: headers);
  }
  
  // Get vehicle by ID - using mobile endpoint from web backend
  Future<ApiResponse> getVehicleById(String id) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.get('mobile/vehicles/$id', additionalHeaders: headers);
  }
  
  // Create new vehicle - using mobile endpoint from web backend
  Future<ApiResponse> createVehicle(Map<String, dynamic> vehicleData) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.post('mobile/vehicles', vehicleData, additionalHeaders: headers);
  }
    // Update existing vehicle - using mobile endpoint from web backend
  Future<ApiResponse> updateVehicle(String id, Map<String, dynamic> vehicleData) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.put('mobile/vehicles/$id', vehicleData, additionalHeaders: headers);
  }
  
  // Delete vehicle - using mobile endpoint from web backend
  Future<ApiResponse> deleteVehicle(String id) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.delete('mobile/vehicles/$id', additionalHeaders: headers);
  }
  // Get vehicle service history - using mobile endpoint from web backend
  Future<ApiResponse> getVehicleServiceHistory(String id) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.get('mobile/vehicles/$id/service-history', additionalHeaders: headers);
  }
  
  // Parse vehicles from API response
  List<Vehicle> parseVehicles(ApiResponse response) {
    if (!response.success || response.data == null) {
      return [];
    }
    
    List<Vehicle> vehicles = [];
    for (var item in response.data['data']) {
      vehicles.add(Vehicle.fromJson(item));
    }
    
    return vehicles;
  }
}
