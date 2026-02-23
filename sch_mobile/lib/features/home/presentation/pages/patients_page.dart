import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../patients/presentation/providers/patient_provider.dart';
import '../../../patients/presentation/widgets/patient_card.dart';
import '../../../patients/presentation/pages/patient_details_page.dart';
import '../../../patients/data/models/patient_model.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/theme/app_theme.dart';

class PatientsPage extends ConsumerStatefulWidget {
  const PatientsPage({super.key});

  @override
  ConsumerState<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends ConsumerState<PatientsPage> {
  final _searchController = TextEditingController();
  String? _searchQuery;
  PatientModel? _selectedPatient;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value.isEmpty ? null : value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider(_searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un patient...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearch,
            ),
          ),
        ),
      ),
      body: patientsAsync.when(
        data: (patients) {
          if (patients.isEmpty) {
            return EmptyStateWidget(
              icon: _searchQuery != null ? Icons.search_off : Icons.group_outlined,
              title: _searchQuery != null ? 'Aucun patient trouvé' : 'Aucun patient enregistré',
              description: _searchQuery != null 
                  ? 'Vérifiez l\'orthographe ou essayez d\'autres mots-clés.' 
                  : 'Ajoutez votre premier patient pour commencer le suivi médical du ménage.',
              actionLabel: _searchQuery == null ? 'Nouveau Patient' : null,
              actionIcon: _searchQuery == null ? Icons.person_add : null,
              onAction: _searchQuery == null ? () => context.push('/patients/create') : null,
            );
          }


          return LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 600;
              
              if (isTablet) {
                // ─── MASTER-DETAIL VIEW (TABLET) ───
                return Row(
                  children: [
                    // MASTER (Left - 35%)
                    SizedBox(
                      width: constraints.maxWidth * 0.35,
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(right: BorderSide(color: AppColors.lightBorder, width: 1))),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            final isSelected = _selectedPatient?.id == patient.id;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedPatient = patient);
                                },
                                child: Container(
                                  decoration: isSelected
                                      ? BoxDecoration(
                                          border: Border.all(color: AppColors.primary, width: 2),
                                          borderRadius: BorderRadius.circular(AppRadius.lg),
                                          boxShadow: AppShadows.coloredPrimary,
                                        )
                                      : null,
                                  child: PatientCard(
                                    patient: patient,
                                    // On mobile this pushes, on tablet we handled it via the GestureDetector above
                                    onTap: () {
                                      setState(() => _selectedPatient = patient);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // DETAIL (Right - 65%)
                    Expanded(
                      child: _selectedPatient != null
                          ? PatientDetailsPage(
                              key: ValueKey(_selectedPatient!.id),
                              patient: _selectedPatient,
                            )
                          : const PatientDetailsPage(patient: null),
                    ),
                  ],
                );
              } else {
                // ─── STACKED LIST VIEW (MOBILE) ───
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PatientCard(
                        patient: patient,
                        // Mobile still pushes full screen (or currently create page as stub)
                        onTap: () => context.push('/patients/create'),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(patientsProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/patients/create');
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Nouveau Patient'),
      ),
    );
  }
}
