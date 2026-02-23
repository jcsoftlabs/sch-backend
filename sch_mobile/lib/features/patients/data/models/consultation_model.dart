import 'package:json_annotation/json_annotation.dart';

part 'consultation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConsultationModel {
  final String? id;
  final String patientId;
  final String? doctorId;
  final String? healthCenterId;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(name: 'doctor')
  final dynamic doctorMap; // Can map to User model if needed, dynamic for quick extraction

  ConsultationModel({
    this.id,
    required this.patientId,
    this.doctorId,
    this.healthCenterId,
    required this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.doctorMap,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);

  String get doctorName {
    if (doctorMap != null && doctorMap is Map && doctorMap['firstName'] != null) {
      return 'Dr. ${doctorMap['firstName']} ${doctorMap['lastName']}';
    }
    return 'Non assigné';
  }
}
