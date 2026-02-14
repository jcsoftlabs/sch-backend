import 'package:json_annotation/json_annotation.dart';

part 'household_model.g.dart';

@JsonSerializable()
class HouseholdModel {
  final String? id;
  final String? agentId;
  final String householdHeadName;
  final String address;
  final String? neighborhood;
  final String? commune;
  final String? phone;
  final double latitude;
  final double longitude;
  final double? gpsAccuracy;
  final String? housingType;
  final int? numberOfRooms;
  final String? waterSource;
  final String? sanitationType;
  final bool hasElectricity;
  final int memberCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;

  const HouseholdModel({
    this.id,
    this.agentId,
    required this.householdHeadName,
    required this.address,
    this.neighborhood,
    this.commune,
    this.phone,
    required this.latitude,
    required this.longitude,
    this.gpsAccuracy,
    this.housingType,
    this.numberOfRooms,
    this.waterSource,
    this.sanitationType,
    this.hasElectricity = false,
    this.memberCount = 0,
    this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  factory HouseholdModel.fromJson(Map<String, dynamic> json) =>
      _$HouseholdModelFromJson(json);

  Map<String, dynamic> toJson() => _$HouseholdModelToJson(this);

  HouseholdModel copyWith({
    String? id,
    String? agentId,
    String? householdHeadName,
    String? address,
    String? neighborhood,
    String? commune,
    String? phone,
    double? latitude,
    double? longitude,
    double? gpsAccuracy,
    String? housingType,
    int? numberOfRooms,
    String? waterSource,
    String? sanitationType,
    bool? hasElectricity,
    int? memberCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return HouseholdModel(
      id: id ?? this.id,
      agentId: agentId ?? this.agentId,
      householdHeadName: householdHeadName ?? this.householdHeadName,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      commune: commune ?? this.commune,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gpsAccuracy: gpsAccuracy ?? this.gpsAccuracy,
      housingType: housingType ?? this.housingType,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      waterSource: waterSource ?? this.waterSource,
      sanitationType: sanitationType ?? this.sanitationType,
      hasElectricity: hasElectricity ?? this.hasElectricity,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
