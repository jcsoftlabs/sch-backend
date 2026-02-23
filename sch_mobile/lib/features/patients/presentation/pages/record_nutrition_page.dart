import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/nutrition_record_model.dart';
import '../providers/nutrition_providers.dart';

class RecordNutritionPage extends ConsumerStatefulWidget {
  final String patientId;

  const RecordNutritionPage({super.key, required this.patientId});

  @override
  ConsumerState<RecordNutritionPage> createState() => _RecordNutritionPageState();
}

class _RecordNutritionPageState extends ConsumerState<RecordNutritionPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _muacController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isSubmitting = false;
  String _calculatedStatus = 'NORMAL';
  Color _statusColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _muacController.addListener(_onMuacChanged);
  }

  void _onMuacChanged() {
    if (_muacController.text.isEmpty) {
      if (_calculatedStatus != 'NORMAL') {
        setState(() {
          _calculatedStatus = 'NORMAL';
          _statusColor = Colors.green;
        });
      }
      return;
    }

    final muac = double.tryParse(_muacController.text.replaceAll(',', '.'));
    if (muac != null) {
      String newStatus = 'NORMAL';
      Color newColor = Colors.green;

      // Children 6-59 months MUAC reference (mm)
      if (muac < 115) {
        newStatus = 'MAS';
        newColor = Colors.red;
      } else if (muac < 125) {
        newStatus = 'MAM';
        newColor = Colors.orange;
      }

      if (newStatus != _calculatedStatus) {
        setState(() {
          _calculatedStatus = newStatus;
          _statusColor = newColor;
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final authState = ref.read(authProvider);
        if (authState.user == null) throw Exception('Non authentifié');

        final repo = ref.read(nutritionRepositoryProvider);
        
        final record = NutritionRecordModel(
          patientId: widget.patientId,
          weight: double.parse(_weightController.text.replaceAll(',', '.')),
          height: double.parse(_heightController.text.replaceAll(',', '.')),
          muac: _muacController.text.isNotEmpty ? double.parse(_muacController.text.replaceAll(',', '.')) : null,
          status: _calculatedStatus, // The offline database saves this until the API echoes the final backend validation back
          agentId: authState.user!.id,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          date: DateTime.now()
        );

        await repo.createNutritionRecord(record);
        
        // Refresh provider to show new data immediately in UI
        ref.invalidate(patientNutritionProvider(widget.patientId));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relevé nutritionnel enregistré avec un statut: $_calculatedStatus'),
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
    _heightController.dispose();
    _muacController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Nouveau Relevé Nutritionnel'),
        elevation: 0,
        backgroundColor: _statusColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _statusColor.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Statut Estimé',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _calculatedStatus == 'NORMAL' ? 'NORMAL - Croissance saine' 
                        : _calculatedStatus == 'MAM' ? 'MAM - Malnutrition Aiguë Modérée' 
                        : 'MAS - Malnutrition Aiguë Sévère',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _statusColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Poids et Taille en Ligne
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Poids (kg)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.monitor_weight_outlined),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        validator: (value) => value!.isEmpty ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        decoration: InputDecoration(
                          labelText: 'Taille (cm)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.height),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        validator: (value) => value!.isEmpty ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // MUAC
                TextFormField(
                  controller: _muacController,
                  decoration: InputDecoration(
                    labelText: 'Périmètre Brachial - MUAC (en mm)',
                    helperText: 'Aide: <115mm = MAS, 115-124mm = MAM',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.straighten),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
                const SizedBox(height: 24),

                // Notes
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

                // Bouton Soumettre
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _statusColor,
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
                            'Enregistrer le relevé nutritionnel',
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
