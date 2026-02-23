// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maternal_care_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaternalCareModel _$MaternalCareModelFromJson(Map<String, dynamic> json) =>
    MaternalCareModel(
      id: json['id'] as String?,
      patientId: json['patientId'] as String,
      pregnancyStart: json['pregnancyStart'] == null
          ? null
          : DateTime.parse(json['pregnancyStart'] as String),
      expectedDelivery: json['expectedDelivery'] == null
          ? null
          : DateTime.parse(json['expectedDelivery'] as String),
      prenatalVisits: (json['prenatalVisits'] as num?)?.toInt() ?? 0,
      riskLevel: json['riskLevel'] as String? ?? 'NORMAL',
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      deliveryType: json['deliveryType'] as String?,
      outcome: json['outcome'] as String?,
      newbornWeight: (json['newbornWeight'] as num?)?.toDouble(),
      agentId: json['agentId'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      agentMap: json['agentMap'],
    );

Map<String, dynamic> _$MaternalCareModelToJson(MaternalCareModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'pregnancyStart': instance.pregnancyStart?.toIso8601String(),
      'expectedDelivery': instance.expectedDelivery?.toIso8601String(),
      'prenatalVisits': instance.prenatalVisits,
      'riskLevel': instance.riskLevel,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'deliveryType': instance.deliveryType,
      'outcome': instance.outcome,
      'newbornWeight': instance.newbornWeight,
      'agentId': instance.agentId,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'agentMap': instance.agentMap,
    };
