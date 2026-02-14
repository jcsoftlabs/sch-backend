import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientModel {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String? phone;
  final String? nationalId;
  final String? householdId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.phone,
    this.nationalId,
    this.householdId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get genderLabel {
    switch (gender.toLowerCase()) {
      case 'm':
      case 'male':
      case 'masculin':
        return 'Masculin';
      case 'f':
      case 'female':
      case 'feminin':
        return 'Féminin';
      default:
        return gender;
    }
  }
}

@JsonSerializable()
class CreatePatientRequest {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String? phone;
  final String? nationalId;
  final String? householdId;

  CreatePatientRequest({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.phone,
    this.nationalId,
    this.householdId,
  });

  Map<String, dynamic> toJson() => _$CreatePatientRequestToJson(this);
}
