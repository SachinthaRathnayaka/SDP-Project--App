import 'auth_service.dart';
import 'vehicle_service.dart';
import 'appointment_service.dart';
import 'connectivity_service.dart';
import 'service_service.dart';

class ServiceFactory {
  // Singleton pattern
  static final ServiceFactory _instance = ServiceFactory._internal();
  
  factory ServiceFactory() => _instance;
  
  ServiceFactory._internal();
    // Services
  final AuthService authService = AuthService();
  final VehicleService vehicleService = VehicleService();
  final AppointmentService appointmentService = AppointmentService();
  final ServiceService serviceService = ServiceService();
  final ConnectivityService connectivityService = ConnectivityService();
  
  void dispose() {
    connectivityService.dispose();
  }
}
