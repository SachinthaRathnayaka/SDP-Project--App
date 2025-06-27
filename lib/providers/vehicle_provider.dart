import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';
import '../models/api_response.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();
  
  List<Vehicle> _vehicles = [];
  Vehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Vehicle> get vehicles => _vehicles;
  Vehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load user vehicles
  Future<void> loadUserVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _vehicleService.getUserVehicles();
      
      if (response.success) {
        _vehicles = _vehicleService.parseVehicles(response);
        if (_vehicles.isNotEmpty && _selectedVehicle == null) {
          _selectedVehicle = _vehicles.first;
        }
      } else {
        _errorMessage = response.message ?? 'Failed to load vehicles';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _vehicleService.getVehicleById(id);
      
      if (response.success && response.data != null) {
        return Vehicle.fromJson(response.data);
      } else {
        _errorMessage = response.message ?? 'Vehicle not found';
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new vehicle
  Future<bool> addVehicle(Map<String, dynamic> vehicleData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _vehicleService.createVehicle(vehicleData);
      
      if (response.success) {
        await loadUserVehicles(); // Refresh the list
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to add vehicle';
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

  // Update vehicle
  Future<bool> updateVehicle(String id, Map<String, dynamic> vehicleData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _vehicleService.updateVehicle(id, vehicleData);
      
      if (response.success) {
        await loadUserVehicles(); // Refresh the list
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to update vehicle';
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

  // Delete vehicle
  Future<bool> deleteVehicle(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _vehicleService.deleteVehicle(id);
      
      if (response.success) {
        // Remove from local list and reset selected vehicle if needed
        _vehicles.removeWhere((vehicle) => vehicle.id == id);
        if (_selectedVehicle?.id == id) {
          _selectedVehicle = _vehicles.isNotEmpty ? _vehicles.first : null;
        }
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to delete vehicle';
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

  // Select vehicle
  void selectVehicle(String id) {
    _selectedVehicle = _vehicles.firstWhere(
      (vehicle) => vehicle.id == id,
      orElse: () => _selectedVehicle!,
    );
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
