// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionRecordModel _$NutritionRecordModelFromJson(
        Map<String, dynamic> json) =>
    NutritionRecordModel(
      id: json['id'] as String?,
      patientId: json['patientId'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      muac: (json['muac'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'NORMAL',
      agentId: json['agentId'] as String,
      notes: json['notes'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$NutritionRecordModelToJson(
        NutritionRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'weight': instance.weight,
      'height': instance.height,
      'muac': instance.muac,
      'status': instance.status,
      'agentId': instance.agentId,
      'notes': instance.notes,
      'date': instance.date?.toIso8601String(),
    };
