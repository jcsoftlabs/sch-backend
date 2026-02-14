import 'package:json_annotation/json_annotation.dart';

part 'household_member_model.g.dart';

@JsonSerializable()
class HouseholdMemberModel {
  final String? id;
  final String? householdId;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender; // 'M', 'F', 'Other'
  final String relationshipToHead; // 'Chef', 'Conjoint', 'Enfant', etc.
  final String? educationLevel;
  final String? occupation;
  final bool hasHealthInsurance;
  final String? insuranceProvider;
  final List<String>? chronicConditions;
  final String? patientId; // Link to patient if exists
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;

  const HouseholdMemberModel({
    this.id,
    this.householdId,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.relationshipToHead,
    this.educationLevel,
    this.occupation,
    this.hasHealthInsurance = false,
    this.insuranceProvider,
    this.chronicConditions,
    this.patientId,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  factory HouseholdMemberModel.fromJson(Map<String, dynamic> json) =>
      _$HouseholdMemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$HouseholdMemberModelToJson(this);

  // Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  HouseholdMemberModel copyWith({
    String? id,
    String? householdId,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? relationshipToHead,
    String? educationLevel,
    String? occupation,
    bool? hasHealthInsurance,
    String? insuranceProvider,
    List<String>? chronicConditions,
    String? patientId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return HouseholdMemberModel(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      relationshipToHead: relationshipToHead ?? this.relationshipToHead,
      educationLevel: educationLevel ?? this.educationLevel,
      occupation: occupation ?? this.occupation,
      hasHealthInsurance: hasHealthInsurance ?? this.hasHealthInsurance,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
