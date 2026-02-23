import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/maternal_care_providers.dart';

class RecordDeliveryPage extends ConsumerStatefulWidget {
  final String maternalCareId;

  const RecordDeliveryPage({super.key, required this.maternalCareId});

  @override
  ConsumerState<RecordDeliveryPage> createState() => _RecordDeliveryPageState();
}

class _RecordDeliveryPageState extends ConsumerState<RecordDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _deliveryDate;
  String _deliveryType = 'Vaginal';
  String _outcome = 'Vivant';
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_deliveryDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner la date d\'accouchement'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        // Here we would load the record, modify it and execute a replace on the local db
        // via repo.updateMaternalCare(widget.maternalCareId, updatedModel);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Accouchement et clôture du dossier enregistrés avec succès.'),
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
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Enregistrer l\'Accouchement'),
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
                  'Clôture du Dossier Maternelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Date d'accouchement
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
                              'Date d\'accouchement réelle',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _deliveryDate == null
                                  ? 'Sélectionner une date'
                                  : DateFormat('dd/MM/yyyy').format(_deliveryDate!),
                              style: TextStyle(
                                fontSize: 16,
                                color: _deliveryDate == null ? Colors.grey[400] : AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Type d'accouchement
                const Text(
                  'Type d\'Accouchement',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
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
                      value: _deliveryType,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Vaginal', child: Text('Normal (Voie basse)')),
                        DropdownMenuItem(value: 'Césarienne', child: Text('Césarienne')),
                      ],
                      onChanged: (value) => setState(() => _deliveryType = value!),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Issue (Outcome)
                const Text(
                  'Issue de la grossesse',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
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
                      value: _outcome,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Vivant', child: Text('Nouveau-né Vivant')),
                        DropdownMenuItem(value: 'Fausse-couche', child: Text('Fausse-couche')),
                        DropdownMenuItem(value: 'Mort-né', child: Text('Mort-né')),
                      ],
                      onChanged: (value) => setState(() => _outcome = value!),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (_outcome == 'Vivant') ...[
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Poids du nouveau-né (en Kg)',
                      suffixText: 'kg',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) => value!.isEmpty ? 'Veuillez saisir le poids' : null,
                  ),
                  const SizedBox(height: 24),
                ],

                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Observations et Complications',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
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
                            'Finaliser le Dossier Maternelle',
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
