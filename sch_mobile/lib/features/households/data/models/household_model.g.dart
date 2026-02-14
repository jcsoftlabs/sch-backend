// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseholdModel _$HouseholdModelFromJson(Map<String, dynamic> json) =>
    HouseholdModel(
      id: json['id'] as String?,
      agentId: json['agentId'] as String?,
      householdHeadName: json['householdHeadName'] as String,
      address: json['address'] as String,
      neighborhood: json['neighborhood'] as String?,
      commune: json['commune'] as String?,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      gpsAccuracy: (json['gpsAccuracy'] as num?)?.toDouble(),
      housingType: json['housingType'] as String?,
      numberOfRooms: (json['numberOfRooms'] as num?)?.toInt(),
      waterSource: json['waterSource'] as String?,
      sanitationType: json['sanitationType'] as String?,
      hasElectricity: json['hasElectricity'] as bool? ?? false,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$HouseholdModelToJson(HouseholdModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agentId': instance.agentId,
      'householdHeadName': instance.householdHeadName,
      'address': instance.address,
      'neighborhood': instance.neighborhood,
      'commune': instance.commune,
      'phone': instance.phone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'gpsAccuracy': instance.gpsAccuracy,
      'housingType': instance.housingType,
      'numberOfRooms': instance.numberOfRooms,
      'waterSource': instance.waterSource,
      'sanitationType': instance.sanitationType,
      'hasElectricity': instance.hasElectricity,
      'memberCount': instance.memberCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
    };
