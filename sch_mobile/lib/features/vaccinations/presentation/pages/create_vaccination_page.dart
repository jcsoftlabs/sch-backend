import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/vaccination_model.dart';
import '../../data/models/vaccine_schedule.dart';
import '../providers/vaccination_providers.dart';

class CreateVaccinationPage extends ConsumerStatefulWidget {
  final String patientId;

  const CreateVaccinationPage({super.key, required this.patientId});

  @override
  ConsumerState<CreateVaccinationPage> createState() =>
      _CreateVaccinationPageState();
}

class _CreateVaccinationPageState extends ConsumerState<CreateVaccinationPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedVaccine;
  int _doseNumber = 1;
  DateTime _dateGiven = DateTime.now();
  String? _batchNumber;
  String? _notes;

  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVaccine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un vaccin')),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final user = ref.read(authStateProvider).user;
    if (user == null) {
      setState(() { _isLoading = false; });
      return;
    }

    // Auto-calculate next due date
    final nextDue = VaccinationProtocol.calculateNextDueDate(
      _selectedVaccine!,
      _doseNumber,
      _dateGiven,
    );

    final newVaccination = VaccinationModel(
      patientId: widget.patientId,
      vaccine: _selectedVaccine!,
      doseNumber: _doseNumber,
      dateGiven: _dateGiven,
      nextDueDate: nextDue,
      batchNumber: _batchNumber,
      agentId: user.id!,
      notes: _notes,
      createdAt: DateTime.now(),
    );

    await ref
        .read(patientVaccinationsProvider(widget.patientId).notifier)
        .addVaccination(newVaccination);

    if (mounted) {
      context.pop(); // Return to patient details
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vaccin enregistré avec succès'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateGiven,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateGiven) {
      setState(() {
        _dateGiven = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vaccines = VaccinationProtocol.getUniqueVaccineNames();
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Vaccin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vaccine Selection
              Text(
                'Choix du Vaccin *',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _selectedVaccine,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Sélectionnez un vaccin',
                ),
                items: vaccines.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVaccine = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Ce champ est requis' : null,
              ),
              
              const SizedBox(height: AppSpacing.lg),

              // Dose Number
              Text(
                'Numéro de Dose *',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<int>(
                initialValue: _doseNumber,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [0, 1, 2, 3, 4, 5].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value == 0 ? 'Dose de naissance (0)' : 'Dose $value'),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _doseNumber = newValue!;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Date Administered
              Text(
                'Date d\'administration *',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(dateFormat.format(_dateGiven)),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Batch Number
              Text(
                'Numéro de lot',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: F5464',
                ),
                onSaved: (value) => _batchNumber = value,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Notes
              Text(
                'Observations (Optionnel)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Effets secondaires, retard, etc.',
                ),
                onSaved: (value) => _notes = value,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Enregistrement...' : 'Enregistrer le vaccin'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(AppSpacing.md),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
