import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/household_member_model.dart';
import '../providers/households_provider.dart';

class AddMemberPage extends ConsumerStatefulWidget {
  final String householdId;

  const AddMemberPage({
    super.key,
    required this.householdId,
  });

  @override
  ConsumerState<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends ConsumerState<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _fullNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String _gender = 'M';
  String _relationshipToHead = 'Enfant';
  final _educationLevelController = TextEditingController();
  final _occupationController = TextEditingController();
  bool _hasHealthInsurance = false;
  final _insuranceProviderController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _educationLevelController.dispose();
    _occupationController.dispose();
    _insuranceProviderController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _submitForm() async {
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

    try {
      final member = HouseholdMemberModel(
        householdId: widget.householdId,
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        gender: _gender,
        relationshipToHead: _relationshipToHead,
        educationLevel: _educationLevelController.text.trim().isEmpty
            ? null
            : _educationLevelController.text.trim(),
        occupation: _occupationController.text.trim().isEmpty
            ? null
            : _occupationController.text.trim(),
        hasHealthInsurance: _hasHealthInsurance,
        insuranceProvider: _hasHealthInsurance && _insuranceProviderController.text.trim().isNotEmpty
            ? _insuranceProviderController.text.trim()
            : null,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      // TODO: Call repository to add member
      // For now, just show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre ajouté avec succès (fonctionnalité à venir)'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Membre'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Full Name
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Nom complet *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date of Birth
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date de naissance *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dateOfBirth == null
                      ? 'Sélectionner une date'
                      : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                  style: TextStyle(
                    color: _dateOfBirth == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Genre *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'M', child: Text('Masculin')),
                DropdownMenuItem(value: 'F', child: Text('Féminin')),
                DropdownMenuItem(value: 'Other', child: Text('Autre')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _gender = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Relationship to Head
            DropdownButtonFormField<String>(
              value: _relationshipToHead,
              decoration: const InputDecoration(
                labelText: 'Relation avec le chef *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.family_restroom),
              ),
              items: const [
                DropdownMenuItem(value: 'Chef', child: Text('Chef de ménage')),
                DropdownMenuItem(value: 'Conjoint', child: Text('Conjoint(e)')),
                DropdownMenuItem(value: 'Enfant', child: Text('Enfant')),
                DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                DropdownMenuItem(value: 'Frère/Sœur', child: Text('Frère/Sœur')),
                DropdownMenuItem(value: 'Autre', child: Text('Autre')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _relationshipToHead = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Education Level
            TextFormField(
              controller: _educationLevelController,
              decoration: const InputDecoration(
                labelText: 'Niveau d\'éducation',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 16),

            // Occupation
            TextFormField(
              controller: _occupationController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
            ),
            const SizedBox(height: 16),

            // Health Insurance
            SwitchListTile(
              title: const Text('Assurance santé'),
              value: _hasHealthInsurance,
              onChanged: (value) {
                setState(() {
                  _hasHealthInsurance = value;
                });
              },
            ),

            // Insurance Provider (conditional)
            if (_hasHealthInsurance) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _insuranceProviderController,
                decoration: const InputDecoration(
                  labelText: 'Fournisseur d\'assurance',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.health_and_safety),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Ajouter le Membre',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
