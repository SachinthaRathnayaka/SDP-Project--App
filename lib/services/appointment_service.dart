import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/service_appointment.dart';
import 'api_service.dart';
import 'auth_service.dart';

class AppointmentService {
  final ApiService _apiService = ApiService(baseUrl: AppConfig.apiUrl);
  final AuthService _authService = AuthService();
    // Get all user appointments - using mobile endpoint from web backend
  Future<ApiResponse> getUserAppointments() async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.get('mobile/bookings', additionalHeaders: headers);
  }
  
  // Get appointment by ID - using mobile endpoint from web backend
  Future<ApiResponse> getAppointmentById(String id) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.get('mobile/bookings/$id', additionalHeaders: headers);
  }
  
  // Create new appointment - using mobile endpoint from web backend
  Future<ApiResponse> createAppointment(Map<String, dynamic> appointmentData) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.post('mobile/bookings', appointmentData, additionalHeaders: headers);
  }
    // Update existing appointment - using mobile endpoint from web backend
  Future<ApiResponse> updateAppointment(String id, Map<String, dynamic> appointmentData) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.put('mobile/bookings/$id', appointmentData, additionalHeaders: headers);
  }
  
  // Cancel appointment - using mobile endpoint from web backend
  Future<ApiResponse> cancelAppointment(String id, {String? reason}) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.put('mobile/bookings/$id/cancel', {'reason': reason}, additionalHeaders: headers);
  }
  
  // Get available appointment slots - using mobile endpoint from web backend
  Future<ApiResponse> getAvailableSlots(String date, String serviceType) async {
    final headers = await _authService.getAuthHeaders();
    return await _apiService.get('mobile/bookings/available-slots?date=$date&service_type=$serviceType', additionalHeaders: headers);
  }
  
  // Parse appointments from API response
  List<ServiceAppointment> parseAppointments(ApiResponse response) {
    if (!response.success || response.data == null) {
      return [];
    }
    
    List<ServiceAppointment> appointments = [];
    for (var item in response.data['data']) {
      appointments.add(ServiceAppointment.fromJson(item));
    }
    
    return appointments;
  }
}
