import 'package:dio/dio.dart';
import '../../data/models/case_report_model.dart';
import '../../data/models/medical_protocol_model.dart';
import '../../data/models/triage_result_model.dart';
import '../../data/repositories/medical_protocol_repository.dart';

/// Service for analyzing symptoms and determining urgency level
class TriageService {
  final MedicalProtocolRepository _protocolRepo;
  final Dio _dio;

  TriageService(this._protocolRepo, this._dio);

  /// Analyze symptoms text and determine urgency level
  /// 
  /// This method:
  /// 1. Normalizes the input text
  /// 2. Retrieves active medical protocols
  /// 3. Finds the best matching protocol based on keywords
  /// 4. Determines urgency level
  /// 5. Generates recommendations
  Future<TriageResultModel> analyzeSymptoms(String symptoms) async {
    // 1. Normalize text
    final normalized = symptoms.toLowerCase().trim();
    if (normalized.isEmpty) {
      return TriageResultModel(
        urgencyLevel: UrgencyLevel.normal,
        keywords: [],
        recommendation: 'Veuillez décrire les symptômes',
      );
    }

    final words = normalized.split(RegExp(r'\s+'));

    // 2. Get active protocols
    final protocols = await _protocolRepo.getActiveProtocols();

    // 3. Find best match
    MedicalProtocolModel? bestMatch;
    int maxMatches = 0;
    List<String> matchedKeywords = [];

    for (final protocol in protocols) {
      int matches = 0;
      List<String> protocolKeywords = [];

      for (final keyword in protocol.keywords) {
        final keywordLower = keyword.toLowerCase();
        if (normalized.contains(keywordLower)) {
          matches++;
          protocolKeywords.add(keyword);
        }
      }

      if (matches > maxMatches) {
        maxMatches = matches;
        bestMatch = protocol;
        matchedKeywords = protocolKeywords;
      }
    }

    // 4. Try Online AI Triage first, fallback to offline
    try {
      final response = await _dio.post('/triage/analyze', data: {
        'symptoms': symptoms,
      });

      if (response.data != null && response.data['status'] == 'success') {
        final aiData = response.data['data'];
        
        // Parse the AI Urgency string to Enum
        UrgencyLevel aiUrgency = switch (aiData['urgency']) {
          'CRITICAL' => UrgencyLevel.critical,
          'URGENT' => UrgencyLevel.urgent,
          _ => UrgencyLevel.normal,
        };

        return TriageResultModel(
          urgencyLevel: aiUrgency,
          matchedProtocol: bestMatch,
          keywords: (aiData['keywords'] as List).cast<String>(),
          recommendation: aiData['clinicalAssessment'], // Use AI Assessment as recommendation
        );
      }
    } catch (e) {
      print('⚠️ Online AI Triage failed, falling back to offline algorithm: $e');
    }

    // 5. Offline Fallback: Determine urgency level
    UrgencyLevel urgency = UrgencyLevel.normal;

    if (bestMatch != null) {
      urgency = bestMatch.urgencyLevel;
    } else {
      // Fallback: check for critical keywords
      urgency = _determineUrgencyFromKeywords(normalized);
    }

    // 6. Generate fallback recommendation
    final recommendation = _generateRecommendation(urgency, bestMatch);

    return TriageResultModel(
      urgencyLevel: urgency,
      matchedProtocol: bestMatch,
      keywords: matchedKeywords.isEmpty ? ['analyse', 'hors-ligne'] : matchedKeywords,
      recommendation: recommendation,
    );
  }

  /// Determine urgency from critical/urgent keywords when no protocol matches
  UrgencyLevel _determineUrgencyFromKeywords(String normalizedText) {
    // Critical keywords (French and Créole)
    final criticalKeywords = [
      'urgence',
      'critique',
      'grave',
      'mourant',
      'inconscient',
      'convulsion',
      'kriz', // crise (Créole)
      'mouri', // mourir (Créole)
      'san', // sang (Créole)
      'pa respire', // ne respire pas (Créole)
    ];

    // Urgent keywords (French and Créole)
    final urgentKeywords = [
      'fièvre',
      'douleur',
      'saignement',
      'vomissement',
      'diarrhée',
      'lafyèv', // fièvre (Créole)
      'doule', // douleur (Créole)
      'vomi', // vomissement (Créole)
      'dyare', // diarrhée (Créole)
    ];

    if (criticalKeywords.any((kw) => normalizedText.contains(kw))) {
      return UrgencyLevel.critical;
    } else if (urgentKeywords.any((kw) => normalizedText.contains(kw))) {
      return UrgencyLevel.urgent;
    }

    return UrgencyLevel.normal;
  }

  /// Generate recommendation based on urgency and protocol
  String _generateRecommendation(
    UrgencyLevel urgency,
    MedicalProtocolModel? protocol,
  ) {
    if (protocol != null) {
      return 'Protocole recommandé: ${protocol.displayName}. '
          'Veuillez suivre les étapes du protocole.';
    }

    return switch (urgency) {
      UrgencyLevel.critical =>
        '🚨 URGENCE CRITIQUE: Référer immédiatement vers un hôpital. '
            'Le patient nécessite une attention médicale urgente.',
      UrgencyLevel.urgent =>
        '⚠️ URGENT: Consulter un médecin dans les plus brefs délais. '
            'Surveillance étroite recommandée.',
      UrgencyLevel.normal =>
        'ℹ️ Cas normal: Continuer la surveillance. '
            'Consulter si les symptômes s\'aggravent.',
    };
  }
}
