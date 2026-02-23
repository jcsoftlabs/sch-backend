import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/case_report_model.dart';
import 'urgency_badge.dart';
import 'sync_status_indicator.dart';

/// Card widget to display case report in a list
class CaseReportCard extends StatelessWidget {
  final CaseReportModel caseReport;
  final VoidCallback? onTap;

  const CaseReportCard({
    super.key,
    required this.caseReport,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Urgency + Sync Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UrgencyBadge(urgency: caseReport.urgency),
                  SyncStatusIndicator(
                    syncStatus: 'pending', // TODO: Get from model
                    isCompact: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Symptoms (truncated)
              Text(
                caseReport.symptoms,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Status + Date
              Row(
                children: [
                  _buildStatusChip(caseReport.status),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dateFormat.format(caseReport.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),

              // Doctor response indicator
              if (caseReport.response != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 16,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Réponse du médecin disponible',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],

              // Referral indicator
              if (caseReport.referral) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Référé vers hôpital',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(CaseReportStatus status) {
    Color color;
    String label;

    switch (status) {
      case CaseReportStatus.pending:
        color = Colors.orange;
        label = 'En attente';
        break;
      case CaseReportStatus.assigned:
        color = Colors.blue;
        label = 'Assigné';
        break;
      case CaseReportStatus.resolved:
        color = Colors.green;
        label = 'Résolu';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
