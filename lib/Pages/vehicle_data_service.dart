import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Model classes - renamed with prefix to avoid conflicts
class VehicleData {
  final String id;
  final String brand;
  final String model;
  final String year;
  final String registrationNumber;
  List<ServiceRecordData> serviceHistory;

  VehicleData({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.serviceHistory,
  });

  // Convert VehicleData to a Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'registrationNumber': registrationNumber,
      'serviceHistory': serviceHistory.map((record) => record.toJson()).toList(),
    };
  }

  // Create a VehicleData from a Map
  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      registrationNumber: json['registrationNumber'],
      serviceHistory: (json['serviceHistory'] as List)
          .map((recordJson) => ServiceRecordData.fromJson(recordJson))
          .toList(),
    );
  }
}

class ServiceRecordData {
  final DateTime date;
  final String type;
  final String description;
  final double cost;

  ServiceRecordData({
    required this.date,
    required this.type,
    required this.description,
    required this.cost,
  });

  // Convert ServiceRecordData to a Map for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'type': type,
      'description': description,
      'cost': cost,
    };
  }

  // Create a ServiceRecordData from a Map
  factory ServiceRecordData.fromJson(Map<String, dynamic> json) {
    return ServiceRecordData(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      type: json['type'],
      description: json['description'],
      cost: json['cost'],
    );
  }
}

// Storage service for vehicle data
class VehicleDataService {
  static const _storageKey = 'vehicle_data';

  // Save all vehicles to persistent storage
  Future<void> saveVehicles(List<VehicleData> vehicles) async {
    final prefs = await SharedPreferences.getInstance();
    final vehicleJsonList = vehicles.map((vehicle) => jsonEncode(vehicle.toJson())).toList();
    await prefs.setStringList(_storageKey, vehicleJsonList);
  }

  // Load all vehicles from persistent storage
  Future<List<VehicleData>> loadVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vehicleJsonList = prefs.getStringList(_storageKey) ?? [];

      return vehicleJsonList
          .map((vehicleJson) => VehicleData.fromJson(jsonDecode(vehicleJson)))
          .toList();
    } catch (e) {
      // Handle errors (e.g., corrupt data)
      print('Error loading vehicles: $e');
      return [];
    }
  }

  // Add a new vehicle and save
  Future<void> addVehicle(VehicleData vehicle, List<VehicleData> currentVehicles) async {
    final updatedVehicles = List<VehicleData>.from(currentVehicles)..add(vehicle);
    await saveVehicles(updatedVehicles);
  }

  // Delete a vehicle and save
  Future<void> deleteVehicle(String vehicleId, List<VehicleData> currentVehicles) async {
    final updatedVehicles = currentVehicles.where((v) => v.id != vehicleId).toList();
    await saveVehicles(updatedVehicles);
  }

  // Add a service record to a vehicle
  Future<void> addServiceRecord(
      String vehicleId,
      ServiceRecordData record,
      List<VehicleData> currentVehicles
      ) async {
    final updatedVehicles = List<VehicleData>.from(currentVehicles);
    final vehicleIndex = updatedVehicles.indexWhere((v) => v.id == vehicleId);

    if (vehicleIndex != -1) {
      updatedVehicles[vehicleIndex].serviceHistory.add(record);
      await saveVehicles(updatedVehicles);
    }
  }
}