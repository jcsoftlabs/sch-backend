// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationModel _$ConsultationModelFromJson(Map<String, dynamic> json) =>
    ConsultationModel(
      id: json['id'] as String?,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String?,
      healthCenterId: json['healthCenterId'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      doctorMap: json['doctor'],
    );

Map<String, dynamic> _$ConsultationModelToJson(ConsultationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
      'healthCenterId': instance.healthCenterId,
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'doctor': instance.doctorMap,
    };
