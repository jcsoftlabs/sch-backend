import 'package:json_annotation/json_annotation.dart';

part 'maternal_care_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MaternalCareModel {
  final String? id;
  final String patientId;
  final DateTime? pregnancyStart;
  final DateTime? expectedDelivery;
  final int prenatalVisits;
  final String riskLevel; // 'NORMAL', 'HIGH', 'CRITICAL'
  final DateTime? deliveryDate;
  final String? deliveryType;
  final String? outcome;
  final double? newbornWeight;
  final String agentId;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic agentMap; 

  MaternalCareModel({
    this.id,
    required this.patientId,
    this.pregnancyStart,
    this.expectedDelivery,
    this.prenatalVisits = 0,
    this.riskLevel = 'NORMAL',
    this.deliveryDate,
    this.deliveryType,
    this.outcome,
    this.newbornWeight,
    required this.agentId,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.agentMap,
  });

  factory MaternalCareModel.fromJson(Map<String, dynamic> json) =>
      _$MaternalCareModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaternalCareModelToJson(this);
}
