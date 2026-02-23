import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/case_report_model.dart';
import '../widgets/urgency_badge.dart';
import '../widgets/sync_status_indicator.dart';
import '../providers/triage_providers.dart';

/// Page to display detailed information about a case report
class CaseReportDetailsPage extends ConsumerWidget {
  final String caseReportId;

  const CaseReportDetailsPage({
    super.key,
    required this.caseReportId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseReportsAsync = ref.watch(caseReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Cas'),
      ),
      body: caseReportsAsync.when(
        data: (caseReports) {
          final caseReport = caseReports.firstWhere(
            (c) => c.id == caseReportId,
            orElse: () => throw Exception('Cas non trouvé'),
          );

          return _buildContent(context, caseReport);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CaseReportModel caseReport) {
    final dateFormat = DateFormat('dd/MM/yyyy à HH:mm');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UrgencyBadge(urgency: caseReport.urgency),
                    SyncStatusIndicator(syncStatus: 'pending'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Créé le',
                  dateFormat.format(caseReport.createdAt),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.update,
                  'Mis à jour le',
                  dateFormat.format(caseReport.updatedAt),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.info_outline,
                  'Statut',
                  caseReport.statusLabel,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Symptoms Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.description, color: Color(0xFF3B82F6)),
                    SizedBox(width: 8),
                    Text(
                      'Symptômes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  caseReport.symptoms,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ),

        // Doctor Response Card
        if (caseReport.response != null) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.medical_services, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Réponse du Médecin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    caseReport.response!,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Referral Card
        if (caseReport.referral) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.local_hospital, color: Colors.red[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Patient référé vers un hôpital',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Location Card
        if (caseReport.latitude != null && caseReport.longitude != null) ...[
          const SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF3B82F6)),
                      SizedBox(width: 8),
                      Text(
                        'Localisation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        caseReport.latitude!,
                        caseReport.longitude!,
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('case_location'),
                        position: LatLng(
                          caseReport.latitude!,
                          caseReport.longitude!,
                        ),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
                if (caseReport.zone != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Zone: ${caseReport.zone}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],

        // Resolved Date
        if (caseReport.resolvedAt != null) ...[
          const SizedBox(height: 16),
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Résolu le ${dateFormat.format(caseReport.resolvedAt!)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
