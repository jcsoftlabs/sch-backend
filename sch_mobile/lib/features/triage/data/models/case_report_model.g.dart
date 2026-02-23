// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CaseReportModel _$CaseReportModelFromJson(Map<String, dynamic> json) =>
    CaseReportModel(
      id: json['id'] as String,
      agentId: json['agentId'] as String,
      patientId: json['patientId'] as String?,
      symptoms: json['symptoms'] as String,
      urgency: $enumDecode(_$UrgencyLevelEnumMap, json['urgency']),
      channel: $enumDecodeNullable(_$CaseChannelEnumMap, json['channel']) ??
          CaseChannel.app,
      status: $enumDecodeNullable(_$CaseReportStatusEnumMap, json['status']) ??
          CaseReportStatus.pending,
      doctorId: json['doctorId'] as String?,
      response: json['response'] as String?,
      referral: json['referral'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      zone: json['zone'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CaseReportModelToJson(CaseReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agentId': instance.agentId,
      'patientId': instance.patientId,
      'symptoms': instance.symptoms,
      'urgency': _$UrgencyLevelEnumMap[instance.urgency]!,
      'channel': _$CaseChannelEnumMap[instance.channel]!,
      'status': _$CaseReportStatusEnumMap[instance.status]!,
      'doctorId': instance.doctorId,
      'response': instance.response,
      'referral': instance.referral,
      'imageUrl': instance.imageUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'zone': instance.zone,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$UrgencyLevelEnumMap = {
  UrgencyLevel.normal: 'NORMAL',
  UrgencyLevel.urgent: 'URGENT',
  UrgencyLevel.critical: 'CRITICAL',
};

const _$CaseChannelEnumMap = {
  CaseChannel.app: 'APP',
  CaseChannel.sms: 'SMS',
  CaseChannel.whatsapp: 'WHATSAPP',
};

const _$CaseReportStatusEnumMap = {
  CaseReportStatus.pending: 'PENDING',
  CaseReportStatus.assigned: 'ASSIGNED',
  CaseReportStatus.resolved: 'RESOLVED',
};
