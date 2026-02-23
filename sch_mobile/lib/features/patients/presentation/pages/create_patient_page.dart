import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/patient_model.dart';
import '../providers/patient_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/services/draft_service.dart';

class CreatePatientPage extends ConsumerStatefulWidget {
  const CreatePatientPage({super.key});

  @override
  ConsumerState<CreatePatientPage> createState() => _CreatePatientPageState();
}

class _CreatePatientPageState extends ConsumerState<CreatePatientPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  DateTime? _dateOfBirth;
  String _gender = 'M';
  bool _isDirty = false;

  // Draft auto-save
  final _draft = DraftService(DraftKeys.patient);

  // Stepper
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _initDraft();
  }

  Future<void> _initDraft() async {
    await _draft.init();
    if (_draft.hasDraft && mounted) {
      _restoreFromDraft(_draft.data!);
      final shouldRestore = await _showRestoreDialog();
      if (shouldRestore) {
        setState(() => _isDirty = true); // draft counts as dirty
      } else {
        // User declined — clear the draft and reset fields
        _clearFormFields();
        await _draft.clear();
      }
    }
  }

  void _restoreFromDraft(Map<String, dynamic> d) {
    _firstNameController.text = d['firstName'] ?? '';
    _lastNameController.text = d['lastName'] ?? '';
    _addressController.text = d['address'] ?? '';
    _phoneController.text = d['phone'] ?? '';
    _nationalIdController.text = d['nationalId'] ?? '';
    if (d['gender'] != null) _gender = d['gender'] as String;
    if (d['dob'] != null) {
      try {
        _dateOfBirth = DateTime.parse(d['dob'] as String);
      } catch (_) {}
    }
  }

  void _clearFormFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _nationalIdController.clear();
    setState(() {
      _gender = 'M';
      _dateOfBirth = null;
    });
  }

  Future<bool> _showRestoreDialog() async {
    if (!mounted) return false;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Row(children: [
          Icon(Icons.restore_rounded, color: AppColors.primary),
          SizedBox(width: 10),
          Text('Brouillon enregistré'),
        ]),
        content: const Text(
            'Vous avez un brouillon de patient non soumis. Voulez-vous le reprendre ?'),
        actions: [
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Non, recommencer'),
            ),
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reprendre'),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
    // Auto-save draft with 2s debounce
    _draft.scheduleSave({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'address': _addressController.text,
      'phone': _phoneController.text,
      'nationalId': _nationalIdController.text,
      'gender': _gender,
      'dob': _dateOfBirth?.toIso8601String(),
    });
  }

  void _onSuccessSave(String name) {
    HapticFeedback.heavyImpact();
    _draft.clear(); // Clear draft on successful submit
    context.pop();
    ref.invalidate(patientsProvider);
    // Show strong success confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$name a été enregistré avec succès ✓',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Quitter sans sauvegarder ?'),
        content: const Text(
            'Les informations saisies seront perdues. Voulez-vous continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Continuer la saisie'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    return result ?? false;
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
      setState(() {
        _dateOfBirth = picked;
        _isDirty = true;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner la date de naissance'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
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
    final isTablet = !context.isMobile;

    // ref.listen must be called inside build()
    ref.listen<PatientFormState>(patientFormProvider, (previous, next) {
      if (next.savedPatient != null && !next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => _onSuccessSave(next.savedPatient!.fullName));
      }
      if (next.error != null) {
        HapticFeedback.vibrate();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.error!),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm)),
              ),
            );
            ref.read(patientFormProvider.notifier).clearError();
          }
        });
      }
    });

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nouveau Patient'),
          leading: BackButton(
            onPressed: () async {
              if (await _onWillPop()) context.pop();
            },
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              onChanged: _markDirty,
              child: isTablet
                  ? _buildStepperLayout(formState)
                  : _buildScrollLayout(formState),
            ),
          ),
        ),
      ),
    );
  }

  // ── Tablet: Stepper layout ─────────────────────────────────────────────────
  Widget _buildStepperLayout(PatientFormState formState) {
    return Stepper(
      currentStep: _currentStep,
      onStepTapped: (step) => setState(() => _currentStep = step),
      onStepContinue: () {
        if (_currentStep < 1) {
          setState(() => _currentStep++);
        } else {
          _submit();
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) setState(() => _currentStep--);
      },
      controlsBuilder: (context, details) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: ref.watch(patientFormProvider).isLoading
                    ? null
                    : details.onStepContinue,
                child: ref.watch(patientFormProvider).isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_currentStep < 1 ? 'Suivant →' : 'Enregistrer ✓'),
              ),
            ),
            if (_currentStep > 0) ...[
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Retour'),
                ),
              ),
            ],
          ],
        ),
      ),
      steps: [
        Step(
          title: const Text('Identité'),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          content: _buildPersonalFields(formState),
        ),
        Step(
          title: const Text('Coordonnées'),
          isActive: _currentStep >= 1,
          content: Column(
            children: [
              _buildContactFields(formState),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  // ── Mobile: single scroll layout ──────────────────────────────────────────
  Widget _buildScrollLayout(PatientFormState formState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader('Identité'),
        const SizedBox(height: 12),
        _buildPersonalFields(formState),
        const SizedBox(height: 20),
        _sectionHeader('Coordonnées'),
        const SizedBox(height: 12),
        _buildContactFields(formState),
        const SizedBox(height: 32),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: formState.isLoading ? null : _submit,
            child: formState.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                  )
                : const Text('Enregistrer le patient'),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '* Champs obligatoires',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.lightTextMuted,
                ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) => Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      );

  Widget _buildPersonalFields(PatientFormState formState) {
    return Column(
      children: [
        // First Name
        TextFormField(
          controller: _firstNameController,
          enabled: !formState.isLoading,
          decoration: const InputDecoration(
            labelText: 'Prénom *',
            hintText: 'Jean',
            prefixIcon: Icon(Icons.person_outline, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          textCapitalization: TextCapitalization.words,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Le prénom est requis' : null,
        ),
        const SizedBox(height: 16),

        // Last Name
        TextFormField(
          controller: _lastNameController,
          enabled: !formState.isLoading,
          decoration: const InputDecoration(
            labelText: 'Nom *',
            hintText: 'Pierre',
            prefixIcon: Icon(Icons.person_outline, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          textCapitalization: TextCapitalization.words,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
        ),
        const SizedBox(height: 16),

        // Date of Birth — large tap target
        InkWell(
          onTap: formState.isLoading ? null : _selectDate,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date de naissance *',
              prefixIcon: const Icon(Icons.calendar_today, size: 22),
              suffixIcon: _dateOfBirth != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 22),
                      onPressed: formState.isLoading
                          ? null
                          : () => setState(() => _dateOfBirth = null),
                    )
                  : null,
            ),
            child: SizedBox(
              height: 28,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _dateOfBirth != null
                      ? DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
                      : 'Sélectionner la date',
                  style: TextStyle(
                    fontSize: 16,
                    color: _dateOfBirth != null
                        ? null
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gender — segmented-style chips
        _GenderSelector(
          value: _gender,
          enabled: !formState.isLoading,
          onChanged: (v) => setState(() {
            _gender = v;
            _isDirty = true;
          }),
        ),
      ],
    );
  }

  Widget _buildContactFields(PatientFormState formState) {
    return Column(
      children: [
        TextFormField(
          controller: _addressController,
          enabled: !formState.isLoading,
          decoration: const InputDecoration(
            labelText: 'Adresse *',
            hintText: 'Rue, Quartier, Ville',
            prefixIcon: Icon(Icons.location_on_outlined, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? "L'adresse est requise" : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          enabled: !formState.isLoading,
          decoration: const InputDecoration(
            labelText: 'Téléphone',
            hintText: '+509 1234 5678',
            prefixIcon: Icon(Icons.phone_outlined, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nationalIdController,
          enabled: !formState.isLoading,
          decoration: const InputDecoration(
            labelText: 'NIF (Optionnel)',
            hintText: 'Numéro identification',
            prefixIcon: Icon(Icons.badge_outlined, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

// ── Gender Selector — large touch targets ─────────────────────────────────────

class _GenderSelector extends StatelessWidget {
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _GenderSelector({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sexe *',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.lightTextSecondary,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _GenderChip(
              label: '♂  Masculin',
              selected: value == 'M',
              color: AppColors.primary,
              onTap: enabled ? () => onChanged('M') : null,
            ),
            const SizedBox(width: 12),
            _GenderChip(
              label: '♀  Féminin',
              selected: value == 'F',
              color: AppColors.actionUrgent,
              onTap: enabled ? () => onChanged('F') : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback? onTap;

  const _GenderChip({
    required this.label,
    required this.selected,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 52,
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: selected ? color : AppColors.lightBorder,
              width: selected ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? color : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
