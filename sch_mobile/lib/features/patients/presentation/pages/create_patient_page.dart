import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/patient_model.dart';
import '../providers/patient_provider.dart';

class CreatePatientPage extends ConsumerStatefulWidget {
  const CreatePatientPage({super.key});

  @override
  ConsumerState<CreatePatientPage> createState() => _CreatePatientPageState();
}

class _CreatePatientPageState extends ConsumerState<CreatePatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  
  DateTime? _dateOfBirth;
  String _gender = 'M';

  @override
  void initState() {
    super.initState();
    // Listen to form state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<PatientFormState>(patientFormProvider, (previous, next) {
        if (next.savedPatient != null && !next.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Patient ${next.savedPatient!.fullName} créé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
          ref.invalidate(patientsProvider);
        }
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red,
            ),
          );
          ref.read(patientFormProvider.notifier).clearError();
        }
      });
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner la date de naissance'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = CreatePatientRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _dateOfBirth!,
      gender: _gender,
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      nationalId: _nationalIdController.text.trim().isEmpty
          ? null
          : _nationalIdController.text.trim(),
    );

    await ref.read(patientFormProvider.notifier).createPatient(request);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(patientFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Patient'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
            // Personal Info Section
            Text(
              'Informations personnelles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // First Name
            TextFormField(
              controller: _firstNameController,
              enabled: !formState.isLoading,
              decoration: const InputDecoration(
                labelText: 'Prénom *',
                hintText: 'Jean',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le prénom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Last Name
            TextFormField(
              controller: _lastNameController,
              enabled: !formState.isLoading,
              decoration: const InputDecoration(
                labelText: 'Nom *',
                hintText: 'Pierre',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date of Birth
            InkWell(
              onTap: formState.isLoading ? null : _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date de naissance *',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: _dateOfBirth != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: formState.isLoading
                              ? null
                              : () => setState(() => _dateOfBirth = null),
                        )
                      : null,
                ),
                child: Text(
                  _dateOfBirth != null
                      ? DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
                      : 'Sélectionner la date',
                  style: TextStyle(
                    color: _dateOfBirth != null ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: const InputDecoration(
                labelText: 'Sexe *',
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'M', child: Text('Masculin')),
                DropdownMenuItem(value: 'F', child: Text('Féminin')),
              ],
              onChanged: formState.isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _gender = value);
                      }
                    },
            ),
            const SizedBox(height: 24),

            // Contact Info Section
            Text(
              'Coordonnées',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Address
            TextFormField(
              controller: _addressController,
              enabled: !formState.isLoading,
              decoration: const InputDecoration(
                labelText: 'Adresse *',
                hintText: 'Rue, Quartier, Ville',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'L\'adresse est requise';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneController,
              enabled: !formState.isLoading,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                hintText: '+509 1234 5678',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // National ID
            TextFormField(
              controller: _nationalIdController,
              enabled: !formState.isLoading,
              decoration: const InputDecoration(
                labelText: 'NIF (Numéro d\'Identification Fiscale)',
                hintText: 'NIF',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: formState.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: formState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Enregistrer le patient'),
            ),
            const SizedBox(height: 16),

            // Required fields note
            Text(
              '* Champs obligatoires',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
}
