import 'package:json_annotation/json_annotation.dart';

part 'nutrition_record_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NutritionRecordModel {
  final String? id;
  final String patientId;
  final double weight;
  final double height;
  final double? muac;
  final String status; // 'NORMAL', 'MAM', 'MAS'
  final String agentId;
  final String? notes;
  final DateTime? date;

  NutritionRecordModel({
    this.id,
    required this.patientId,
    required this.weight,
    required this.height,
    this.muac,
    this.status = 'NORMAL',
    required this.agentId,
    this.notes,
    this.date,
  });

  factory NutritionRecordModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionRecordModelToJson(this);
}
