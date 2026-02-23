import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/triage_providers.dart';
import '../widgets/triage_result_card.dart';
import '../../data/repositories/case_report_repository.dart';
import '../../data/models/triage_result_model.dart';
import '../../data/models/case_report_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/draft_service.dart';

/// Page to create a new case report with symptom analysis
class CreateCaseReportPage extends ConsumerStatefulWidget {
  const CreateCaseReportPage({super.key});

  @override
  ConsumerState<CreateCaseReportPage> createState() =>
      _CreateCaseReportPageState();
}

class _CreateCaseReportPageState extends ConsumerState<CreateCaseReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  
  TriageResultModel? _triageResult;
  bool _isAnalyzing = false;
  bool _isCreating = false;
  bool _isDirty = false;
  double? _latitude;
  double? _longitude;

  // Draft auto-save
  final _draft = DraftService(DraftKeys.caseReport);

  @override
  void initState() {
    super.initState();
    _captureLocation();
    _initDraft();
  }

  Future<void> _initDraft() async {
    await _draft.init();
    if (_draft.hasDraft && mounted) {
      final d = _draft.data!;
      _symptomsController.text = d['symptoms'] ?? '';
      final shouldRestore = await _showRestoreDialog();
      if (shouldRestore) {
        setState(() => _isDirty = true);
      } else {
        _symptomsController.clear();
        await _draft.clear();
      }
    }
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
            'Vous avez une description de symptômes non soumise. La reprendre ?'),
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
    _symptomsController.dispose();
    _draft.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }
    } catch (e) {
      print('Error capturing location: $e');
    }
  }

  Future<void> _analyzeSymptoms() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isAnalyzing = true;
      _isDirty = true;
    });

    // Save symptoms draft immediately before async operation
    await _draft.saveNow({'symptoms': _symptomsController.text});

    try {
      final triageService = ref.read(triageServiceProvider);
      final result = await triageService.analyzeSymptoms(
        _symptomsController.text,
      );

      HapticFeedback.lightImpact();
      setState(() {
        _triageResult = result;
        _isAnalyzing = false;
      });

      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      if (mounted) {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'analyse: $e"),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm)),
          ),
        );
      }
    }
  }

  Future<void> _createCaseReport() async {
    if (!_formKey.currentState!.validate() || _triageResult == null) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final user = ref.read(authStateProvider).user;
      
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      final dto = CreateCaseReportDto(
        agentId: user.id!,
        symptoms: _symptomsController.text,
        urgency: _triageResult!.urgencyLevel,
        latitude: _latitude,
        longitude: _longitude,
      );

      await ref
          .read(caseReportsProvider.notifier)
          .createCaseReport(dto);

      if (mounted) {
        HapticFeedback.heavyImpact();
        await _draft.clear(); // Clear draft on successful submit
        setState(() => _isDirty = false);
        context.go('/triage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm)),
            backgroundColor: AppColors.success,
            content: const Row(children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cas créé et envoyé au médecin ✓',
                  style: TextStyle(
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
      setState(() {
        _isCreating = false;
      });
      if (mounted) {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
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
            'La description des symptômes et l\'analyse seront perdues.'),
        actions: [
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Continuer'),
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
          title: const Text('Nouveau Cas'),
          leading: BackButton(
            onPressed: () async {
              if (await _onWillPop()) context.pop();
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Instructions card — better contrast for field
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Décrivez les symptômes en détail. L'analyse déterminera le niveau d'urgence automatiquement.",
                        style: TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Symptoms Input
              TextFormField(
                controller: _symptomsController,
                maxLines: 6,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  labelText: 'Symptômes *',
                  hintText: 'Ex: Fièvre élevée, maux de tête, vomissements...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez décrire les symptômes';
                  }
                  if (value.trim().length < 10) {
                    return 'Description trop courte (min. 10 caractères)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Location indicator
              if (_latitude != null && _longitude != null)
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: AppColors.success),
                    const SizedBox(width: 6),
                    Text(
                      'Position GPS capturée',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              // Analyze Button
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeSymptoms,
                  icon: _isAnalyzing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.analytics),
                  label: Text(_isAnalyzing
                      ? 'Analyse en cours...'
                      : 'Analyser les Symptômes'),
                ),
              ),

              // Triage Result
              if (_triageResult != null) ...[
                const SizedBox(height: 24),
                TriageResultCard(result: _triageResult!),
                const SizedBox(height: 24),

                // Create Case Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isCreating ? null : _createCaseReport,
                    icon: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isCreating
                        ? 'Création en cours...'
                        : 'Créer le Cas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
