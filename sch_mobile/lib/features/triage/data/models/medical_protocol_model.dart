import 'package:json_annotation/json_annotation.dart';
import '../../triage.dart';
import 'dart:convert';

part 'medical_protocol_model.g.dart';

@JsonSerializable()
class MedicalProtocolModel {
  final String id;
  final String name;
  final String? nameKr; // Créole haïtien
  final List<String> keywords;
  final String steps; // JSON string
  final UrgencyLevel urgencyLevel;
  final String? category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalProtocolModel({
    required this.id,
    required this.name,
    this.nameKr,
    required this.keywords,
    required this.steps,
    required this.urgencyLevel,
    this.category,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicalProtocolModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalProtocolModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalProtocolModelToJson(this);

  // Helper to get display name (prefer Créole if available)
  String get displayName => nameKr ?? name;

  // Helper to parse steps JSON
  Map<String, dynamic>? get parsedSteps {
    try {
      return Map<String, dynamic>.from(
        jsonDecode(steps) as Map,
      );
    } catch (e) {
      return null;
    }
  }
}
