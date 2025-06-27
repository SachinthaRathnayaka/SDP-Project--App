import 'package:flutter/foundation.dart';
import '../models/workshop_service.dart';
import '../services/service_service.dart';
import '../models/api_response.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceService _serviceService = ServiceService();
  
  List<WorkshopService> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<WorkshopService> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load available services
  Future<void> loadAvailableServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _serviceService.getAvailableServices();
      
      if (response.success) {
        _services = _serviceService.parseServices(response);
      } else {
        _errorMessage = response.message ?? 'Failed to load services';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get service by ID
  WorkshopService? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter services by category
  List<WorkshopService> getServicesByCategory(String category) {
    return _services.where((service) => 
      service.name.toLowerCase().contains(category.toLowerCase()) || 
      service.description.toLowerCase().contains(category.toLowerCase())
    ).toList();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
