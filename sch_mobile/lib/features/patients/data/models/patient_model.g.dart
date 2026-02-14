// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) => PatientModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      nationalId: json['nationalId'] as String?,
      householdId: json['householdId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'phone': instance.phone,
      'nationalId': instance.nationalId,
      'householdId': instance.householdId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

CreatePatientRequest _$CreatePatientRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePatientRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      nationalId: json['nationalId'] as String?,
      householdId: json['householdId'] as String?,
    );

Map<String, dynamic> _$CreatePatientRequestToJson(
        CreatePatientRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'phone': instance.phone,
      'nationalId': instance.nationalId,
      'householdId': instance.householdId,
    };
