import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/nutrition_providers.dart';

class NutritionHistoryWidget extends ConsumerWidget {
  final String patientId;

  const NutritionHistoryWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionAsync = ref.watch(patientNutritionProvider(patientId));

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
                  'Suivi Nutritionnel (MUAC)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/patients/$patientId/nutrition/new'),
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('Nouveau Relevé'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            nutritionAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Aucun relevé nutritionnel enregistré.',
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final record = records[index];
                    final dateStr = record.date != null ? DateFormat('dd MMM yyyy').format(record.date!) : 'Date inconnue';
                    final isPending = record.status == 'pending'; // Actually using syncStatus would be better but keeping simple for UI demo
                    
                    Color statusColor = _getStatusColor(record.status);
                    String statusLabel = _getStatusLabel(record.status);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.monitor_weight_outlined, color: statusColor, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dateStr,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: statusColor),
                                      ),
                                      child: Text(
                                        statusLabel,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    _buildMetric('Poids', '${record.weight} kg'),
                                    _buildMetric('Taille', '${record.height} cm'),
                                    if (record.muac != null)
                                      _buildMetric('MUAC', '${record.muac} mm', color: statusColor),
                                  ],
                                ),
                                if (record.notes != null && record.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    record.notes!,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13, fontStyle: FontStyle.italic),
                                  )
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
              error: (error, stack) => Center(child: Text('Erreur: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: color ?? AppTheme.textPrimary)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NORMAL':
        return Colors.green;
      case 'MAM':
        return Colors.orange;
      case 'MAS':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'NORMAL':
        return 'NORMAL';
      case 'MAM':
        return 'MAM - Modérée';
      case 'MAS':
        return 'MAS - Sévere';
      default:
        return 'INCONNU';
    }
  }
}
