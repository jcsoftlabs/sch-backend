import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/maternal_care_model.dart';
import '../providers/maternal_care_providers.dart';

class CreateMaternalCarePage extends ConsumerStatefulWidget {
  final String patientId;

  const CreateMaternalCarePage({super.key, required this.patientId});

  @override
  ConsumerState<CreateMaternalCarePage> createState() => _CreateMaternalCarePageState();
}

class _CreateMaternalCarePageState extends ConsumerState<CreateMaternalCarePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _pregnancyStart;
  String _riskLevel = 'NORMAL';
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 300)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _pregnancyStart) {
      setState(() {
        _pregnancyStart = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_pregnancyStart == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner la date de début de grossesse (DDR)'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final authState = ref.read(authProvider);
        if (authState.user == null) throw Exception('Non authentifié');

        final repo = ref.read(maternalCareRepositoryProvider);
        
        final maternalCare = MaternalCareModel(
          id: const Uuid().v4(),
          patientId: widget.patientId,
          pregnancyStart: _pregnancyStart,
          prenatalVisits: 0,
          riskLevel: _riskLevel,
          agentId: authState.user!.id,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          createdAt: DateTime.now(),
        );

        await repo.createMaternalCare(maternalCare);
        
        // Refresh provider to show new data
        ref.invalidate(patientMaternalCareProvider(widget.patientId));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Grossesse enregistrée avec succès. La DPA a été calculée.'),
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
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Déclarer une Grossesse'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informations Initiales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Date Picker pour DDR
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date des dernières règles (DDR)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _pregnancyStart == null
                                  ? 'Sélectionner une date'
                                  : DateFormat('dd/MM/yyyy').format(_pregnancyStart!),
                              style: TextStyle(
                                fontSize: 16,
                                color: _pregnancyStart == null ? Colors.grey[400] : AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                      ],
                    ),
                  ),
                ),
                if (_pregnancyStart != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'DPA Estimée : ${DateFormat('dd MMMM yyyy').format(_pregnancyStart!.add(const Duration(days: 280)))}',
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Niveau de risque
                const Text(
                  'Niveau de Risque Initial',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _riskLevel,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'NORMAL', child: Text('Normal - Aucun antécédent particulier')),
                        DropdownMenuItem(value: 'HIGH', child: Text('Haut Risque - Surveillance accrue')),
                        DropdownMenuItem(value: 'CRITICAL', child: Text('Critique - Référer immédiatement')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          if (value != null) _riskLevel = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Observations et Antécédents',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 40),

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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Enregistrer la Grossesse',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
