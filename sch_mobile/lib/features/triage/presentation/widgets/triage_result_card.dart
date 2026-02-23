import 'package:flutter/material.dart';
import '../../data/models/triage_result_model.dart';
import '../../data/models/case_report_model.dart'; // For UrgencyLevel
import 'urgency_badge.dart';
import 'protocol_card.dart';

/// Card widget to display triage analysis result
class TriageResultCard extends StatelessWidget {
  final TriageResultModel result;

  const TriageResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Row(
              children: [
                Icon(Icons.analytics, color: Color(0xFF3B82F6)),
                SizedBox(width: 8),
                Text(
                  'Résultat de l\'analyse',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Urgency Level
            Row(
              children: [
                const Text(
                  'Niveau d\'urgence:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                UrgencyBadge(urgency: result.urgencyLevel),
              ],
            ),
            const SizedBox(height: 16),

            // Recommendation
            if (result.recommendation != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getRecommendationColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getRecommendationColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _getRecommendationIcon(),
                      color: _getRecommendationColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        result.recommendation!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Matched Protocol
            if (result.hasProtocol) ...[
              const Text(
                'Protocole identifié:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ProtocolCard(
                protocol: result.matchedProtocol!,
                matchedKeywords: result.keywords,
              ),
            ] else if (result.keywords.isNotEmpty) ...[
              const Text(
                'Mots-clés détectés:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: result.keywords.map((keyword) {
                  return Chip(
                    label: Text(keyword),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getRecommendationColor() {
    return switch (result.urgencyLevel) {
      UrgencyLevel.critical => Colors.red,
      UrgencyLevel.urgent => Colors.orange,
      UrgencyLevel.normal => Colors.green,
    };
  }

  IconData _getRecommendationIcon() {
    return switch (result.urgencyLevel) {
      UrgencyLevel.critical => Icons.warning,
      UrgencyLevel.urgent => Icons.info,
      UrgencyLevel.normal => Icons.check_circle,
    };
  }
}
