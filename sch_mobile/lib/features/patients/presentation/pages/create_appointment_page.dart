import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/appointment_model.dart';
import '../providers/appointment_providers.dart';

class CreateAppointmentPage extends ConsumerStatefulWidget {
  final String patientId;

  const CreateAppointmentPage({super.key, required this.patientId});

  @override
  ConsumerState<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends ConsumerState<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _durationMinutes = 30; // Default 30 mins

  bool _isSubmitting = false;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final authState = ref.read(authProvider);
        if (authState.user == null) throw Exception('Non authentifié');

        // Combine date and time
        final scheduledAt = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        final repo = ref.read(appointmentRepositoryProvider);
        
        final appointment = AppointmentModel(
          patientId: widget.patientId,
          scheduledAt: scheduledAt,
          duration: _durationMinutes,
          reason: _reasonController.text.isNotEmpty ? _reasonController.text : 'Suivi de routine',
          agentId: authState.user!.id,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          status: 'SCHEDULED', // explicit fallback
          createdAt: DateTime.now()
        );

        await repo.createAppointment(appointment);
        
        ref.invalidate(patientAppointmentsProvider(widget.patientId));
        ref.invalidate(upcomingAppointmentsProvider); // Update agent's personal calendar if present

        // Schedule local notification securely via flutter_local_notifications (Bonus phase)
        await NotificationService().scheduleAppointmentReminder(
          id: appointment.id.hashCode,
          title: 'Rappel de Rendez-vous',
          body: 'Rendez-vous prévu demain à ${DateFormat('HH:mm').format(scheduledAt)} pour : ${appointment.reason ?? 'Suivi médical'}',
          scheduledTime: scheduledAt,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous planifié avec succès.'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    } else {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner une date et une heure.'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Nouveau Rendez-vous'),
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === DATE ET HEURE ===
                Text(
                  'Date et Heure',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedDate == null ? 'Choisir la date' : DateFormat('dd MMM yyyy').format(_selectedDate!),
                                  style: TextStyle(
                                    color: _selectedDate == null ? Colors.grey[600] : Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: AppTheme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedTime == null ? 'L\'heure' : _selectedTime!.format(context),
                                  style: TextStyle(
                                    color: _selectedTime == null ? Colors.grey[600] : Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // === MOTIF ===
                Text(
                  'Détails du Suivi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: 'Motif de la visite (ex: Vaccin, Renouvellement Ordonnance)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.medical_services_outlined, color: Colors.grey),
                  ),
                  validator: (value) => value!.isEmpty ? 'Le motif est requis' : null,
                ),
                const SizedBox(height: 20),
                
                // Durée Dropdown
                DropdownButtonFormField<int>(
                  value: _durationMinutes,
                  decoration: InputDecoration(
                    labelText: 'Durée estimée',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.timer_outlined, color: Colors.grey),
                  ),
                  items: const [
                    DropdownMenuItem(value: 15, child: Text("15 minutes")),
                    DropdownMenuItem(value: 30, child: Text("30 minutes")),
                    DropdownMenuItem(value: 60, child: Text("1 heure")),
                  ],
                  onChanged: (val) {
                    setState(() { _durationMinutes = val!; });
                  },
                ),
                const SizedBox(height: 20),

                // Informations Additionnelles
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes pour l\'agent (optionnel)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 48),

                // Bouton Soumettre
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Planifier le Rendez-vous',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
