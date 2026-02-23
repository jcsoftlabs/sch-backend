// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaccinationModel _$VaccinationModelFromJson(Map<String, dynamic> json) =>
    VaccinationModel(
      id: json['id'] as String?,
      patientId: json['patientId'] as String,
      vaccine: json['vaccine'] as String,
      doseNumber: (json['doseNumber'] as num).toInt(),
      dateGiven: DateTime.parse(json['dateGiven'] as String),
      nextDueDate: json['nextDueDate'] == null
          ? null
          : DateTime.parse(json['nextDueDate'] as String),
      batchNumber: json['batchNumber'] as String?,
      agentId: json['agentId'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VaccinationModelToJson(VaccinationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'vaccine': instance.vaccine,
      'doseNumber': instance.doseNumber,
      'dateGiven': instance.dateGiven.toIso8601String(),
      'nextDueDate': instance.nextDueDate?.toIso8601String(),
      'batchNumber': instance.batchNumber,
      'agentId': instance.agentId,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
