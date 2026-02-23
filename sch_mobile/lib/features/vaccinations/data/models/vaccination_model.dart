import 'package:json_annotation/json_annotation.dart';

part 'vaccination_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VaccinationModel {
  final String? id;
  @JsonKey(name: 'patientId')
  final String patientId;
  final String vaccine; // e.g., BCG, Penta, Polio
  @JsonKey(name: 'doseNumber')
  final int doseNumber;
  @JsonKey(name: 'dateGiven')
  final DateTime dateGiven;
  @JsonKey(name: 'nextDueDate')
  final DateTime? nextDueDate;
  @JsonKey(name: 'batchNumber')
  final String? batchNumber;
  @JsonKey(name: 'agentId')
  final String agentId;
  final String? notes;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  
  // For offline sync
  @JsonKey(ignore: true)
  final bool isSynced;

  VaccinationModel({
    this.id,
    required this.patientId,
    required this.vaccine,
    required this.doseNumber,
    required this.dateGiven,
    this.nextDueDate,
    this.batchNumber,
    required this.agentId,
    this.notes,
    this.createdAt,
    this.isSynced = true,
  });

  factory VaccinationModel.fromJson(Map<String, dynamic> json) =>
      _$VaccinationModelFromJson(json);

  Map<String, dynamic> toJson() => _$VaccinationModelToJson(this);

  /// Convert to SQLite map
  Map<String, dynamic> toSqlMap() {
    return {
      'id': id,
      'patientId': patientId,
      'vaccine': vaccine,
      'doseNumber': doseNumber,
      'dateGiven': dateGiven.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'agentId': agentId,
      'notes': notes,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  /// Create from SQLite map
  factory VaccinationModel.fromSqlMap(Map<String, dynamic> map) {
    return VaccinationModel(
      id: map['id'] as String?,
      patientId: map['patientId'] as String,
      vaccine: map['vaccine'] as String,
      doseNumber: map['doseNumber'] as int,
      dateGiven: DateTime.parse(map['dateGiven'] as String),
      nextDueDate: map['nextDueDate'] != null 
          ? DateTime.parse(map['nextDueDate'] as String) 
          : null,
      batchNumber: map['batchNumber'] as String?,
      agentId: map['agentId'] as String,
      notes: map['notes'] as String?,
      isSynced: (map['isSynced'] as int) == 1,
    );
  }

  VaccinationModel copyWith({
    String? id,
    String? patientId,
    String? vaccine,
    int? doseNumber,
    DateTime? dateGiven,
    DateTime? nextDueDate,
    String? batchNumber,
    String? agentId,
    String? notes,
    DateTime? createdAt,
    bool? isSynced,
  }) {
    return VaccinationModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      vaccine: vaccine ?? this.vaccine,
      doseNumber: doseNumber ?? this.doseNumber,
      dateGiven: dateGiven ?? this.dateGiven,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      batchNumber: batchNumber ?? this.batchNumber,
      agentId: agentId ?? this.agentId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
