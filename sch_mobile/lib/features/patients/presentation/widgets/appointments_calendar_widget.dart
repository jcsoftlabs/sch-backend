import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/appointment_providers.dart';

class AppointmentsCalendarWidget extends ConsumerWidget {
  final String patientId;

  const AppointmentsCalendarWidget({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(patientAppointmentsProvider(patientId));

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
                  'Rendez-Vous',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/patients/$patientId/appointments/new'),
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('Planifier'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            appointmentsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Aucun rendez-vous prévu.',
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
                    final appointment = records[index];
                    final dateStr = DateFormat('EEEE d MMM yyyy', 'fr_FR').format(appointment.scheduledAt);
                    final timeStr = DateFormat('HH:mm').format(appointment.scheduledAt);
                    
                    Color statusColor = _getStatusColor(appointment.status);
                    String statusLabel = _getStatusLabel(appointment.status);

                    final bool isPast = appointment.scheduledAt.isBefore(DateTime.now());

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isPast && appointment.status == 'SCHEDULED' 
                                  ? Colors.red.withOpacity(0.1) 
                                  : statusColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.event_note, 
                              color: isPast && appointment.status == 'SCHEDULED' ? Colors.red : statusColor, 
                              size: 20
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${dateStr[0].toUpperCase()}${dateStr.substring(1)} à $timeStr',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 15,
                                          decoration: appointment.status == 'CANCELLED' ? TextDecoration.lineThrough : null,
                                          color: isPast && appointment.status == 'SCHEDULED' ? Colors.red : Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isPast && appointment.status == 'SCHEDULED' 
                                            ? Colors.red.withOpacity(0.1) 
                                            : statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isPast && appointment.status == 'SCHEDULED' ? Colors.red : statusColor
                                        ),
                                      ),
                                      child: Text(
                                        isPast && appointment.status == 'SCHEDULED' ? 'EN RETARD' : statusLabel,
                                        style: TextStyle(
                                          color: isPast && appointment.status == 'SCHEDULED' ? Colors.red : statusColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  appointment.reason ?? 'Motif non précisé',
                                  style: TextStyle(
                                    color: Colors.grey[700], 
                                    fontSize: 14,
                                    decoration: appointment.status == 'CANCELLED' ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    appointment.notes!,
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13, fontStyle: FontStyle.italic),
                                  )
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text('${appointment.duration} minutes', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                  ],
                                )
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return Colors.blue;
      case 'CONFIRMED':
        return Colors.green;
      case 'COMPLETED':
        return Colors.purple;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return 'PRÉVU';
      case 'CONFIRMED':
        return 'CONFIRMÉ';
      case 'COMPLETED':
        return 'TERMINÉ';
      case 'CANCELLED':
        return 'ANNULÉ';
      default:
        return 'PRÉVU';
    }
  }
}
