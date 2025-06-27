class Vehicle {
  final String id;
  final String userId;
  final String vehicleNumber;
  final String make;
  final String model;
  final int year;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.vehicleNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      userId: json['user_id'],
      vehicleNumber: json['vehicle_number'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_number': vehicleNumber,
      'make': make,
      'model': model,
      'year': year,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
