import 'package:flutter/foundation.dart';
import '../models/service_appointment.dart';
import '../services/appointment_service.dart';
import '../models/api_response.dart';

class AppointmentProvider with ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  
  List<ServiceAppointment> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ServiceAppointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load user appointments
  Future<void> loadUserAppointments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _appointmentService.getUserAppointments();
      
      if (response.success) {
        _appointments = _appointmentService.parseAppointments(response);
      } else {
        _errorMessage = response.message ?? 'Failed to load appointments';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get appointment by ID
  Future<ServiceAppointment?> getAppointmentById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _appointmentService.getAppointmentById(id);
      
      if (response.success && response.data != null) {
        return ServiceAppointment.fromJson(response.data);
      } else {
        _errorMessage = response.message ?? 'Appointment not found';
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

  // Create appointment
  Future<bool> createAppointment(Map<String, dynamic> appointmentData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _appointmentService.createAppointment(appointmentData);
      
      if (response.success) {
        await loadUserAppointments(); // Refresh the list
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to create appointment';
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

  // Update appointment
  Future<bool> updateAppointment(String id, Map<String, dynamic> appointmentData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _appointmentService.updateAppointment(id, appointmentData);
      
      if (response.success) {
        await loadUserAppointments(); // Refresh the list
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to update appointment';
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

  // Cancel appointment
  Future<bool> cancelAppointment(String id, {String? reason}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _appointmentService.cancelAppointment(id, reason: reason);
      
      if (response.success) {
        await loadUserAppointments(); // Refresh the list
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to cancel appointment';
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

  // Get available appointment slots
  Future<List<String>> getAvailableSlots(String date, String serviceType) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await _appointmentService.getAvailableSlots(date, serviceType);
      
      if (response.success && response.data != null) {
        final List<dynamic> slots = response.data['slots'];
        final List<String> availableSlots = slots.map((slot) => slot.toString()).toList();
        return availableSlots;
      } else {
        _errorMessage = response.message ?? 'Failed to load available slots';
        return [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get upcoming appointments
  List<ServiceAppointment> getUpcomingAppointments() {
    final now = DateTime.now();
    return _appointments
        .where((appointment) => 
            appointment.appointmentDate.isAfter(now) && 
            appointment.status != 'cancelled')
        .toList();
  }

  // Get past appointments
  List<ServiceAppointment> getPastAppointments() {
    final now = DateTime.now();
    return _appointments
        .where((appointment) => 
            appointment.appointmentDate.isBefore(now) || 
            appointment.status == 'completed' || 
            appointment.status == 'cancelled')
        .toList();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
