import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/maternal_care_providers.dart';

class MaternalCareCardWidget extends ConsumerWidget {
  final String patientId;

  const MaternalCareCardWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maternalAsync = ref.watch(patientMaternalCareProvider(patientId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Suivi Maternelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/patients/$patientId/maternal/new'),
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('Déclarer grossesse'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            maternalAsync.when(
              data: (records) {
                // Filter active pregnancies (no delivery date yet)
                final activePregnancies = records.where((r) => r.deliveryDate == null).toList();

                if (activePregnancies.isEmpty) {
                  return const Text(
                    'Aucune grossesse en cours.',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  );
                }

                final currentPregnancy = activePregnancies.first;
                final today = DateTime.now();
                
                // Calculate weeks pregnant
                int weeksPregnant = 0;
                if (currentPregnancy.pregnancyStart != null) {
                  weeksPregnant = today.difference(currentPregnancy.pregnancyStart!).inDays ~/ 7;
                }
                
                // Progress metric (40 weeks total)
                double progressStr = (weeksPregnant / 40.0).clamp(0.0, 1.0);

                Color riskColor = _getRiskColor(currentPregnancy.riskLevel);
                String riskLabel = _getRiskLabel(currentPregnancy.riskLevel);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: riskColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: riskColor),
                          ),
                          child: Text(
                            riskLabel,
                            style: TextStyle(
                              color: riskColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (currentPregnancy.syncStatus == 'pending') ...[
                          const Icon(Icons.cloud_upload_outlined, size: 16, color: Colors.orange),
                        ]
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progression : $weeksPregnant / 40 Semaines',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'DPA : ${currentPregnancy.expectedDelivery != null ? DateFormat('dd/MM/yyyy').format(currentPregnancy.expectedDelivery!) : 'Inconnue'}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progressStr,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${currentPregnancy.prenatalVisits} visite(s) prénatale(s) effectuée(s)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push('/maternal/${currentPregnancy.id}/visit'),
                            child: const Text('Visite Prénatale'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.push('/maternal/${currentPregnancy.id}/delivery'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successColor),
                            child: const Text('Accouchement', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Erreur de chargement: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'NORMAL':
        return Colors.green;
      case 'HIGH':
        return Colors.orange;
      case 'CRITICAL':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getRiskLabel(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'NORMAL':
        return 'Risque Normal';
      case 'HIGH':
        return 'Haut Risque';
      case 'CRITICAL':
        return 'Risque Critique';
      default:
        return riskLevel;
    }
  }
}
