import 'package:flutter/material.dart';
import '../../data/models/patient_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../vaccinations/presentation/widgets/vaccination_schedule_widget.dart';
import '../widgets/consultations_history_widget.dart';
import '../widgets/maternal_care_card_widget.dart';
import '../widgets/nutrition_history_widget.dart';
import '../widgets/appointments_calendar_widget.dart';

class PatientDetailsPage extends StatelessWidget {
  final PatientModel? patient;
  
  const PatientDetailsPage({super.key, this.patient});

  @override
  Widget build(BuildContext context) {
    if (patient == null) {
      return const EmptyStateWidget(
        icon: Icons.person_outline,
        title: 'Sélectionnez un patient',
        description: 'Les détails complets et le dossier médical s\'afficheront ici.',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${patient!.firstName} ${patient!.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO Edit
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            _buildHeaderCard(context),
            const SizedBox(height: 24),
            
            // Maternal Care Section (Pregnancy Tracking)
            if (patient!.gender == 'F' || patient!.gender == 'Féminin') ...[
              MaternalCareCardWidget(patientId: patient!.id),
              const SizedBox(height: 32),
            ],

            // Vital Signs Section
            VitalSignsHistoryWidget(patientId: patient!.id),
            const SizedBox(height: 32),

            // Nutrition Tracking Section
            NutritionHistoryWidget(patientId: patient!.id),
            const SizedBox(height: 32),

            // Appointments Section
            AppointmentsCalendarWidget(patientId: patient!.id),
            const SizedBox(height: 32),

            // Vaccinations Section
            VaccinationScheduleWidget(patientId: patient!.id),
            
            const SizedBox(height: 32),
            // Consultations History Section
            ConsultationsHistoryWidget(patientId: patient!.id),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                '${patient!.firstName[0]}${patient!.lastName[0]}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'ID: ${patient!.nationalId ?? "Non spécifié"}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightTextMuted,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: AppColors.lightTextMuted),
                      const SizedBox(width: 8),
                      Text(patient!.phone ?? "Aucun numéro"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.lightTextMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          patient!.address ?? "Aucune adresse",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
