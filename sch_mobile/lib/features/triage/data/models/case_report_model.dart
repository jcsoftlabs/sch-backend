import 'package:json_annotation/json_annotation.dart';

part 'case_report_model.g.dart';

enum UrgencyLevel {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('URGENT')
  urgent,
  @JsonValue('CRITICAL')
  critical,
}

enum CaseChannel {
  @JsonValue('APP')
  app,
  @JsonValue('SMS')
  sms,
  @JsonValue('WHATSAPP')
  whatsapp,
}

enum CaseReportStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('ASSIGNED')
  assigned,
  @JsonValue('RESOLVED')
  resolved,
}

@JsonSerializable()
class CaseReportModel {
  final String id;
  final String agentId;
  final String? patientId;
  final String symptoms;
  final UrgencyLevel urgency;
  final CaseChannel channel;
  final CaseReportStatus status;
  final String? doctorId;
  final String? response;
  final bool referral;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? zone;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  CaseReportModel({
    required this.id,
    required this.agentId,
    this.patientId,
    required this.symptoms,
    required this.urgency,
    this.channel = CaseChannel.app,
    this.status = CaseReportStatus.pending,
    this.doctorId,
    this.response,
    this.referral = false,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.zone,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CaseReportModel.fromJson(Map<String, dynamic> json) =>
      _$CaseReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$CaseReportModelToJson(this);

  // Helper to get urgency color
  String get urgencyColor {
    switch (urgency) {
      case UrgencyLevel.critical:
        return '#EF4444'; // red
      case UrgencyLevel.urgent:
        return '#F59E0B'; // orange
      case UrgencyLevel.normal:
        return '#10B981'; // green
    }
  }

  // Helper to get urgency label
  String get urgencyLabel {
    switch (urgency) {
      case UrgencyLevel.critical:
        return 'CRITIQUE';
      case UrgencyLevel.urgent:
        return 'URGENT';
      case UrgencyLevel.normal:
        return 'NORMAL';
    }
  }

  // Helper to get status label
  String get statusLabel {
    switch (status) {
      case CaseReportStatus.pending:
        return 'En attente';
      case CaseReportStatus.assigned:
        return 'Assigné';
      case CaseReportStatus.resolved:
        return 'Résolu';
    }
  }
}
