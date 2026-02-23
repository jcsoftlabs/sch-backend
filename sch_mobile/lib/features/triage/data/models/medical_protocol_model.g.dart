// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_protocol_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalProtocolModel _$MedicalProtocolModelFromJson(
        Map<String, dynamic> json) =>
    MedicalProtocolModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameKr: json['nameKr'] as String?,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      steps: json['steps'] as String,
      urgencyLevel: $enumDecode(_$UrgencyLevelEnumMap, json['urgencyLevel']),
      category: json['category'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MedicalProtocolModelToJson(
        MedicalProtocolModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameKr': instance.nameKr,
      'keywords': instance.keywords,
      'steps': instance.steps,
      'urgencyLevel': _$UrgencyLevelEnumMap[instance.urgencyLevel]!,
      'category': instance.category,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$UrgencyLevelEnumMap = {
  UrgencyLevel.normal: 'NORMAL',
  UrgencyLevel.urgent: 'URGENT',
  UrgencyLevel.critical: 'CRITICAL',
};
