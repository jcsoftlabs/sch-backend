// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseholdMemberModel _$HouseholdMemberModelFromJson(
        Map<String, dynamic> json) =>
    HouseholdMemberModel(
      id: json['id'] as String?,
      householdId: json['householdId'] as String?,
      fullName: json['fullName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      relationshipToHead: json['relationshipToHead'] as String,
      educationLevel: json['educationLevel'] as String?,
      occupation: json['occupation'] as String?,
      hasHealthInsurance: json['hasHealthInsurance'] as bool? ?? false,
      insuranceProvider: json['insuranceProvider'] as String?,
      chronicConditions: (json['chronicConditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      patientId: json['patientId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$HouseholdMemberModelToJson(
        HouseholdMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'householdId': instance.householdId,
      'fullName': instance.fullName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'relationshipToHead': instance.relationshipToHead,
      'educationLevel': instance.educationLevel,
      'occupation': instance.occupation,
      'hasHealthInsurance': instance.hasHealthInsurance,
      'insuranceProvider': instance.insuranceProvider,
      'chronicConditions': instance.chronicConditions,
      'patientId': instance.patientId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
    };
