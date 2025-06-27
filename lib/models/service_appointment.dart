class ServiceAppointment {
  final String id;
  final String userId;
  final String vehicleId;
  final String serviceType;
  final DateTime appointmentDate;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceAppointment({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.serviceType,
    required this.appointmentDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceAppointment.fromJson(Map<String, dynamic> json) {
    return ServiceAppointment(
      id: json['id'],
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      serviceType: json['service_type'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      status: json['status'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'service_type': serviceType,
      'appointment_date': appointmentDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
