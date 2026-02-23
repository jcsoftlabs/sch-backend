// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital_sign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalSignModel _$VitalSignModelFromJson(Map<String, dynamic> json) =>
    VitalSignModel(
      id: json['id'] as String?,
      medicalRecordId: json['medicalRecordId'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      bloodPressureSys: (json['bloodPressureSys'] as num?)?.toInt(),
      bloodPressureDia: (json['bloodPressureDia'] as num?)?.toInt(),
      heartRate: (json['heartRate'] as num?)?.toInt(),
      respiratoryRate: (json['respiratoryRate'] as num?)?.toInt(),
      oxygenSaturation: (json['oxygenSaturation'] as num?)?.toDouble(),
      agentId: json['agentId'] as String,
      recordedAt: json['recordedAt'] == null
          ? null
          : DateTime.parse(json['recordedAt'] as String),
    );

Map<String, dynamic> _$VitalSignModelToJson(VitalSignModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicalRecordId': instance.medicalRecordId,
      'temperature': instance.temperature,
      'bloodPressureSys': instance.bloodPressureSys,
      'bloodPressureDia': instance.bloodPressureDia,
      'heartRate': instance.heartRate,
      'respiratoryRate': instance.respiratoryRate,
      'oxygenSaturation': instance.oxygenSaturation,
      'agentId': instance.agentId,
      'recordedAt': instance.recordedAt?.toIso8601String(),
    };
