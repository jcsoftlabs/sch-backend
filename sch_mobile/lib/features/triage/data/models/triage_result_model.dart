import 'case_report_model.dart';
import 'medical_protocol_model.dart';

/// Result of triage analysis
class TriageResultModel {
  final UrgencyLevel urgencyLevel;
  final MedicalProtocolModel? matchedProtocol;
  final List<String> keywords;
  final String? recommendation;

  TriageResultModel({
    required this.urgencyLevel,
    this.matchedProtocol,
    required this.keywords,
    this.recommendation,
  });

  // Helper to check if a protocol was matched
  bool get hasProtocol => matchedProtocol != null;

  // Helper to get urgency icon
  String get urgencyIcon {
    switch (urgencyLevel) {
      case UrgencyLevel.critical:
        return '🚨';
      case UrgencyLevel.urgent:
        return '⚠️';
      case UrgencyLevel.normal:
        return '✅';
    }
  }

  // Helper to get urgency label
  String get urgencyLabel {
    switch (urgencyLevel) {
      case UrgencyLevel.critical:
        return 'CRITIQUE';
      case UrgencyLevel.urgent:
        return 'URGENT';
      case UrgencyLevel.normal:
        return 'NORMAL';
    }
  }
}
