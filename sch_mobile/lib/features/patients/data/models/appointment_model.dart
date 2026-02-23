import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentModel {
  final String? id;
  final String patientId;
  final String? doctorId;
  final String? healthCenterId;
  final DateTime scheduledAt;
  final int duration;
  final String? reason;
  final String status; // 'SCHEDULED', 'CONFIRMED', 'COMPLETED', 'CANCELLED'
  final String agentId;
  final String? notes;
  final bool reminderSent;
  final DateTime? createdAt;

  AppointmentModel({
    this.id,
    required this.patientId,
    this.doctorId,
    this.healthCenterId,
    required this.scheduledAt,
    this.duration = 30,
    this.reason,
    this.status = 'SCHEDULED',
    required this.agentId,
    this.notes,
    this.reminderSent = false,
    this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
