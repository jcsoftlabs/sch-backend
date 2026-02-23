import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/vital_signs_provider.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class VitalSignsHistoryWidget extends ConsumerWidget {
  final String patientId;

  const VitalSignsHistoryWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vitalsAsync = ref.watch(patientVitalSignsProvider(patientId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Constantes Vitales',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    context.push('/patients/${patientId}/vitals/new');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            vitalsAsync.when(
              data: (vitals) {
                if (vitals.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Aucune constante vitale enregistrée pour ce patient.',
                        style: TextStyle(color: AppColors.lightTextMuted),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vitals.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final v = vitals[index];
                    final date = v.recordedAt != null 
                        ? DateFormat('dd/MM/yyyy HH:mm').format(v.recordedAt!)
                        : 'Inconnue';

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.monitor_heart, color: AppColors.primary),
                      ),
                      title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
                          children: [
                            if (v.bloodPressureSys != null && v.bloodPressureDia != null)
                              _buildMetricChip('Tension', '${v.bloodPressureSys}/${v.bloodPressureDia} mmHg'),
                            if (v.temperature != null)
                              _buildMetricChip('Temp', '${v.temperature} °C'),
                            if (v.heartRate != null)
                              _buildMetricChip('FC', '${v.heartRate} bpm'),
                            if (v.respiratoryRate != null)
                              _buildMetricChip('FR', '${v.respiratoryRate} /min'),
                            if (v.oxygenSaturation != null)
                              _buildMetricChip('SpO2', '${v.oxygenSaturation} %'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )),
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
