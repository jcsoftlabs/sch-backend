import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/draft_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/household_model.dart';
import '../providers/households_provider.dart';

class CreateHouseholdPage extends ConsumerStatefulWidget {
  const CreateHouseholdPage({super.key});

  @override
  ConsumerState<CreateHouseholdPage> createState() =>
      _CreateHouseholdPageState();
}

class _CreateHouseholdPageState extends ConsumerState<CreateHouseholdPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationService = LocationService();

  // Form controllers
  final _householdHeadController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _communeController = TextEditingController();
  final _phoneController = TextEditingController();

  // GPS data
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _locationError;
  bool _isSubmitting = false;

  // Form data
  String? _housingType;
  int? _numberOfRooms;
  String? _waterSource;
  String? _sanitationType;
  bool _hasElectricity = false;

  // Stepper
  int _currentStep = 0;
  bool _isDirty = false;

  // Draft auto-save
  final _draft = DraftService(DraftKeys.household);

  // Step form keys
  final _step0Key = GlobalKey<FormState>();
  final _step1Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _captureGPS();
    _initDraft();
  }

  Future<void> _initDraft() async {
    await _draft.init();
    if (_draft.hasDraft && mounted) {
      _restoreFromDraft(_draft.data!);
      final shouldRestore = await _showRestoreDialog();
      if (shouldRestore) {
        setState(() => _isDirty = true);
      } else {
        _clearFormFields();
        await _draft.clear();
      }
    }
  }

  void _restoreFromDraft(Map<String, dynamic> d) {
    _householdHeadController.text = d['head'] ?? '';
    _addressController.text = d['address'] ?? '';
    _neighborhoodController.text = d['neighborhood'] ?? '';
    _communeController.text = d['commune'] ?? '';
    _phoneController.text = d['phone'] ?? '';
    setState(() {
      _housingType = d['housingType'] as String?;
      _waterSource = d['waterSource'] as String?;
      _sanitationType = d['sanitationType'] as String?;
      _numberOfRooms = d['rooms'] as int?;
      _hasElectricity = (d['electricity'] as bool?) ?? false;
    });
  }

  void _clearFormFields() {
    _householdHeadController.clear();
    _addressController.clear();
    _neighborhoodController.clear();
    _communeController.clear();
    _phoneController.clear();
    setState(() {
      _housingType = null;
      _waterSource = null;
      _sanitationType = null;
      _numberOfRooms = null;
      _hasElectricity = false;
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
            'Vous avez un brouillon de ménage non soumis. Voulez-vous le reprendre ?'),
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
    _householdHeadController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _communeController.dispose();
    _phoneController.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
    _draft.scheduleSave({
      'head': _householdHeadController.text,
      'address': _addressController.text,
      'neighborhood': _neighborhoodController.text,
      'commune': _communeController.text,
      'phone': _phoneController.text,
      'housingType': _housingType,
      'waterSource': _waterSource,
      'sanitationType': _sanitationType,
      'rooms': _numberOfRooms,
      'electricity': _hasElectricity,
    });
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
            'Les informations du ménage seront perdues. Continuer ?'),
        actions: [
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Continuer la saisie'),
            ),
          ),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Quitter'),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _captureGPS() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentPosition = position;
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _locationError = "Impossible d'obtenir la localisation";
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_currentPosition == null) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.gps_off, color: Colors.white),
            SizedBox(width: 12),
            Text('Veuillez activer le GPS pour continuer'),
          ]),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final household = HouseholdModel(
        householdHeadName: _householdHeadController.text.trim(),
        address: _addressController.text.trim(),
        neighborhood: _neighborhoodController.text.trim().isEmpty
            ? null
            : _neighborhoodController.text.trim(),
        commune: _communeController.text.trim().isEmpty
            ? null
            : _communeController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        gpsAccuracy: _currentPosition!.accuracy,
        housingType: _housingType,
        numberOfRooms: _numberOfRooms,
        waterSource: _waterSource,
        sanitationType: _sanitationType,
        hasElectricity: _hasElectricity,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      await ref
          .read(householdsNotifierProvider.notifier)
          .createHousehold(household);

      if (mounted) {
        HapticFeedback.heavyImpact();
        await _draft.clear(); // Clear draft on successful submit
        setState(() => _isDirty = false);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm)),
            backgroundColor: AppColors.success,
            content: Row(children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ménage "${_householdHeadController.text.trim()}" enregistré ✓',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ]),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _onStepContinue() {
    // Validate current step before advancing
    if (_currentStep == 0) {
      // Step 0: chef + adresse — required
      if (_householdHeadController.text.trim().isEmpty ||
          _addressController.text.trim().isEmpty) {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Veuillez remplir les champs obligatoires (*)'),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm)),
          ),
        );
        return;
      }
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Nouveau Ménage'),
          leading: BackButton(
            onPressed: () async {
              if (await _onWillPop()) context.pop();
            },
          ),
        ),
        body: Form(
          key: _formKey,
          onChanged: _markDirty,
          child: Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            onStepContinue: _onStepContinue,
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
                      onPressed: _isSubmitting ? null : details.onStepContinue,
                      child: _isSubmitting && _currentStep == 2
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_currentStep < 2
                              ? 'Suivant →'
                              : 'Enregistrer ✓'),
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
              // ── Étape 1 : Chef de ménage + Localisation ──────────────────
              Step(
                title: const Text('Chef de ménage'),
                subtitle: const Text('Identité & adresse'),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: _buildStep0(),
              ),
              // ── Étape 2 : Contact & Quartier ─────────────────────────────
              Step(
                title: const Text('Localisation'),
                subtitle: const Text('Quartier, commune & téléphone'),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: _buildStep1(),
              ),
              // ── Étape 3 : Logement ───────────────────────────────────────
              Step(
                title: const Text('Logement'),
                subtitle: const Text('Type, eau, sanitaire & électricité'),
                isActive: _currentStep >= 2,
                content: _buildStep2(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Step 0: Chef + Adresse + GPS ─────────────────────────────────────────
  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GPS Card
        _GpsCard(
          position: _currentPosition,
          isLoading: _isLoadingLocation,
          error: _locationError,
          onRetry: _captureGPS,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _householdHeadController,
          decoration: const InputDecoration(
            labelText: 'Nom du chef de ménage *',
            prefixIcon: Icon(Icons.person, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          textCapitalization: TextCapitalization.words,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Ce champ est requis' : null,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Adresse *',
            prefixIcon: Icon(Icons.location_on, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Ce champ est requis' : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 1: Quartier + Commune + Téléphone ───────────────────────────────
  Widget _buildStep1() {
    return Column(
      children: [
        TextFormField(
          controller: _neighborhoodController,
          decoration: const InputDecoration(
            labelText: 'Quartier',
            prefixIcon: Icon(Icons.location_city, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _communeController,
          decoration: const InputDecoration(
            labelText: 'Commune',
            prefixIcon: Icon(Icons.map, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Téléphone',
            hintText: '+509 1234 5678',
            prefixIcon: Icon(Icons.phone, size: 22),
          ),
          style: const TextStyle(fontSize: 16),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Step 2: Logement ─────────────────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      children: [
        // Housing type — chips
        _OptionChips<String>(
          label: 'Type de logement',
          options: const ['Maison', 'Appartement', 'Cabane', 'Autre'],
          selected: _housingType,
          onSelected: (v) => setState(() {
            _housingType = v;
            _isDirty = true;
          }),
        ),
        const SizedBox(height: 16),

        // Water source — chips
        _OptionChips<String>(
          label: "Source d'eau",
          options: const ['Robinet', 'Puits', 'Rivière', 'Camion-citerne'],
          selected: _waterSource,
          onSelected: (v) => setState(() {
            _waterSource = v;
            _isDirty = true;
          }),
        ),
        const SizedBox(height: 16),

        // Nbr rooms
        Row(
          children: [
            Text('Nombre de pièces',
                style: Theme.of(context).textTheme.labelLarge),
            const Spacer(),
            _CounterField(
              value: _numberOfRooms ?? 0,
              onChanged: (v) => setState(() {
                _numberOfRooms = v == 0 ? null : v;
                _isDirty = true;
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Electricity
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightBorder),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: SwitchListTile(
            title: const Text("Accès à l'électricité",
                style: TextStyle(fontSize: 16)),
            subtitle: Text(
              _hasElectricity ? 'Oui' : 'Non',
              style: TextStyle(
                color: _hasElectricity ? AppColors.success : AppColors.lightTextMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            value: _hasElectricity,
            onChanged: (v) => setState(() {
              _hasElectricity = v;
              _isDirty = true;
            }),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── GPS Card ──────────────────────────────────────────────────────────────────
class _GpsCard extends StatelessWidget {
  final Position? position;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const _GpsCard({
    required this.position,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isOk = position != null;
    final isError = error != null;
    final bgColor = isOk
        ? AppColors.success.withOpacity(0.08)
        : isError
            ? AppColors.error.withOpacity(0.07)
            : AppColors.primary.withOpacity(0.07);
    final iconCol = isOk
        ? AppColors.success
        : isError
            ? AppColors.error
            : AppColors.primary;
    final icon =
        isOk ? Icons.gps_fixed : isError ? Icons.gps_off : Icons.gps_not_fixed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: iconCol.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconCol, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isOk
                      ? 'GPS : ${position!.latitude.toStringAsFixed(5)}, ${position!.longitude.toStringAsFixed(5)}'
                      : isError
                          ? 'GPS : $error'
                          : 'Capture GPS en cours…',
                  style: TextStyle(
                      color: iconCol,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          if (isLoading) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(
              backgroundColor: iconCol.withOpacity(0.15),
              color: iconCol,
            ),
          ],
          if (isError) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Réessayer'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Option Chips ──────────────────────────────────────────────────────────────
class _OptionChips<T> extends StatelessWidget {
  final String label;
  final List<String> options;
  final T? selected;
  final ValueChanged<T?> onSelected;

  const _OptionChips({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => onSelected(isSelected ? null : opt as T),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.lightBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Counter Field ─────────────────────────────────────────────────────────────
class _CounterField extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _CounterField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CounterBtn(
          icon: Icons.remove,
          onTap: value > 0 ? () => onChanged(value - 1) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            value == 0 ? '—' : '$value',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        _CounterBtn(
          icon: Icons.add,
          onTap: value < 20 ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
              color: onTap != null ? AppColors.primary : AppColors.lightBorder),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null ? AppColors.primary : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}
