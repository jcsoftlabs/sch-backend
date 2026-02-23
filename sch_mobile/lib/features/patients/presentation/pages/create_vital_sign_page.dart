import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/vital_signs_provider.dart';
import '../data/models/vital_sign_model.dart';
import '../../../../core/widgets/custom_button.dart';

class CreateVitalSignPage extends ConsumerStatefulWidget {
  final String patientId;

  const CreateVitalSignPage({super.key, required this.patientId});

  @override
  ConsumerState<CreateVitalSignPage> createState() => _CreateVitalSignPageState();
}

class _CreateVitalSignPageState extends ConsumerState<CreateVitalSignPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _tempController = TextEditingController();
  final _sysController = TextEditingController();
  final _diaController = TextEditingController();
  final _hrController = TextEditingController();
  final _rrController = TextEditingController();
  final _spo2Controller = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _tempController.dispose();
    _sysController.dispose();
    _diaController.dispose();
    _hrController.dispose();
    _rrController.dispose();
    _spo2Controller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Check that at least one field is filled
    if (_tempController.text.isEmpty &&
        _sysController.text.isEmpty &&
        _diaController.text.isEmpty &&
        _hrController.text.isEmpty &&
        _rrController.text.isEmpty &&
        _spo2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez renseigner au moins une constante vitale.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).user;
      if (user == null || user.id == null) throw Exception('Utilisateur non connecté');

      final model = VitalSignModel(
        medicalRecordId: null, // Will be set by backend
        temperature: _tempController.text.isNotEmpty ? double.parse(_tempController.text) : null,
        bloodPressureSys: _sysController.text.isNotEmpty ? int.parse(_sysController.text) : null,
        bloodPressureDia: _diaController.text.isNotEmpty ? int.parse(_diaController.text) : null,
        heartRate: _hrController.text.isNotEmpty ? int.parse(_hrController.text) : null,
        respiratoryRate: _rrController.text.isNotEmpty ? int.parse(_rrController.text) : null,
        oxygenSaturation: _spo2Controller.text.isNotEmpty ? double.parse(_spo2Controller.text) : null,
        agentId: user.id!,
      );

      final repo = ref.read(vitalSignsRepositoryProvider);
      await repo.createVitalSign(widget.patientId, model);

      // Refresh the provider
      ref.invalidate(patientVitalSignsProvider(widget.patientId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Constantes enregistrées avec succès')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisir Constantes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Relevé des Constantes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Saisissez les paramètres vitaux. Ne remplissez que les champs mesurés.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              _buildInputField('Température (°C)', _tempController, 'Ex: 37.5', isDecimal: true),
              
              Row(
                children: [
                  Expanded(child: _buildInputField('Tension Sys (mmHg)', _sysController, 'Ex: 120')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputField('Tension Dia (mmHg)', _diaController, 'Ex: 80')),
                ],
              ),
              
              Row(
                children: [
                  Expanded(child: _buildInputField('Pouls (bpm)', _hrController, 'Ex: 75')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputField('Respiration (/min)', _rrController, 'Ex: 16')),
                ],
              ),

              _buildInputField('SpO2 (%)', _spo2Controller, 'Ex: 98', isDecimal: true),

              const SizedBox(height: 32),
              
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.save),
                      label: const Text('Enregistrer le relevé'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, {bool isDecimal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return null; // Optional
          if (isDecimal) {
            if (double.tryParse(value) == null) return 'Nombre invalide';
          } else {
            if (int.tryParse(value) == null) return 'Nombre entier requis';
          }
          return null;
        },
      ),
    );
  }
}
