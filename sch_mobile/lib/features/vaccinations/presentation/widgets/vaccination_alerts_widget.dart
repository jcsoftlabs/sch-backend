import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/vaccination_model.dart';
import '../providers/vaccination_providers.dart';

class VaccinationAlertsWidget extends ConsumerWidget {
  const VaccinationAlertsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(dueVaccinationsProvider);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Délais vaccinaux dépassés',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          alertsAsync.when(
            data: (alerts) {
              if (alerts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'Aucun vaccin en retard détecté dans votre zone.',
                      style: TextStyle(color: AppColors.lightTextMuted),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return _buildAlertTile(context, alerts[index]);
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'Erreur: $error',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertTile(BuildContext context, VaccinationModel vac) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isOverdue = vac.nextDueDate!.isBefore(DateTime.now());

    return ListTile(
      leading: const Icon(Icons.vaccines, color: AppColors.error),
      title: Text(
        '${vac.vaccine} - Dose ${vac.doseNumber + 1} due',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If we had a way to join Patient name easily, we would put here.
          // For now, redirect to patient profile is best because we only have patientId
          Text(
            'Patient ID: ${vac.patientId.substring(0, 8)}...',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Date due: ${dateFormat.format(vac.nextDueDate!)}',
            style: TextStyle(
              color: isOverdue ? AppColors.error : AppColors.textLight,
              fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push('/patients/${vac.patientId}/vaccination/new');
      },
    );
  }
}
