import 'package:json_annotation/json_annotation.dart';

part 'vital_sign_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VitalSignModel {
  final String? id;
  final String? medicalRecordId;
  final double? temperature;
  final int? bloodPressureSys;
  final int? bloodPressureDia;
  final int? heartRate;
  final int? respiratoryRate;
  final double? oxygenSaturation;
  final String agentId;
  final DateTime? recordedAt;

  VitalSignModel({
    this.id,
    this.medicalRecordId,
    this.temperature,
    this.bloodPressureSys,
    this.bloodPressureDia,
    this.heartRate,
    this.respiratoryRate,
    this.oxygenSaturation,
    required this.agentId,
    this.recordedAt,
  });

  factory VitalSignModel.fromJson(Map<String, dynamic> json) =>
      _$VitalSignModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignModelToJson(this);
}
