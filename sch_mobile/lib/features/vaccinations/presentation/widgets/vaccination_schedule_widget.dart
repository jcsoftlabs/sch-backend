import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/vaccination_model.dart';
import '../providers/vaccination_providers.dart';

class VaccinationScheduleWidget extends ConsumerWidget {
  final String patientId;

  const VaccinationScheduleWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaccinationsAsync = ref.watch(patientVaccinationsProvider(patientId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Carnet de Vaccination',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              onPressed: () => context.push('/patients/$patientId/vaccination/new'),
              icon: const Icon(Icons.vaccines),
              label: const Text('Nouveau Vaccin'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        vaccinationsAsync.when(
          data: (vaccinations) {
            if (vaccinations.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Text('Aucun vaccin enregistré pour ce patient.'),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vaccinations.length,
              itemBuilder: (context, index) {
                final vac = vaccinations[index];
                return _buildVaccinationCard(context, vac);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Erreur lors du chargement des vaccins: $error',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaccinationCard(BuildContext context, VaccinationModel vac) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isPendingSync = !vac.isSynced;

    // Check if next dose is overdue
    bool isOverdue = false;
    if (vac.nextDueDate != null) {
      isOverdue = vac.nextDueDate!.isBefore(DateTime.now());
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withAlpha(25),
          child: const Icon(Icons.vaccines, color: AppColors.primary),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${vac.vaccine} - Dose ${vac.doseNumber == 0 ? "Nais." : vac.doseNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isPendingSync)
              const Tooltip(
                message: 'En attente de synchronisation',
                child: Icon(Icons.cloud_upload_outlined,
                    size: 16, color: AppColors.warning),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Administré le : ${dateFormat.format(vac.dateGiven)}'),
            if (vac.nextDueDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      isOverdue ? Icons.warning_amber_rounded : Icons.schedule,
                      size: 16,
                      color: isOverdue ? AppColors.error : AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Prochaine dose prévue : ${dateFormat.format(vac.nextDueDate!)}',
                      style: TextStyle(
                        color: isOverdue ? AppColors.error : AppColors.textLight,
                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            if (vac.notes != null && vac.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('Notes: ${vac.notes}',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
