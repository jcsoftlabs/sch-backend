import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/consultations_provider.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ConsultationsHistoryWidget extends ConsumerWidget {
  final String patientId;

  const ConsultationsHistoryWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultationsAsync = ref.watch(patientConsultationsProvider(patientId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historique des Consultations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            consultationsAsync.when(
              data: (consultations) {
                if (consultations.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Aucune consultation passée pour ce patient.',
                        style: TextStyle(color: AppColors.lightTextMuted),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: consultations.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final consultation = consultations[index];
                    final date = consultation.createdAt != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(consultation.createdAt!)
                        : 'Date inconnue';

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.medical_services_outlined, color: AppColors.primary),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              date,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          _buildStatusBadge(consultation.status),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              consultation.doctorName,
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blueGrey),
                            ),
                            if (consultation.notes != null && consultation.notes!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                consultation.notes!,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'COMPLETED':
        color = Colors.green;
        label = 'Complétée';
        break;
      case 'PENDING':
        color = Colors.orange;
        label = 'En attente';
        break;
      case 'ACCEPTED':
        color = Colors.blue;
        label = 'Acceptée';
        break;
      case 'CANCELLED':
        color = Colors.red;
        label = 'Annulée';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
