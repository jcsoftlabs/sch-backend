import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../households/presentation/providers/households_provider.dart';
import '../../../households/presentation/pages/household_details_page.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class HouseholdsPage extends ConsumerStatefulWidget {
  const HouseholdsPage({super.key});

  @override
  ConsumerState<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends ConsumerState<HouseholdsPage> {
  String _searchQuery = '';
  String? _selectedHouseholdId;

  @override
  Widget build(BuildContext context) {
    final householdsState = ref.watch(householdsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ménages'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un ménage...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: householdsState.when(
        data: (households) {
          // Filter households based on search query
          final filteredHouseholds = households.where((household) {
            return household.householdHeadName.toLowerCase().contains(_searchQuery) ||
                household.address.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredHouseholds.isEmpty) {
            return EmptyStateWidget(
              icon: _searchQuery.isNotEmpty ? Icons.search_off : Icons.home_work_outlined,
              title: _searchQuery.isNotEmpty ? 'Aucun résultat trouvé' : 'Aucun ménage enregistré',
              description: _searchQuery.isNotEmpty
                  ? 'Essayez de modifier votre terme de recherche.'
                  : 'Commencez par recenser votre premier ménage dans cette zone.',
              actionLabel: _searchQuery.isEmpty ? 'Nouveau Ménage' : null,
              actionIcon: _searchQuery.isEmpty ? Icons.add : null,
              onAction: _searchQuery.isEmpty ? () => context.push('/households/create') : null,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 600;
              
              Widget listWidget = RefreshIndicator(
                onRefresh: () async {
                  ref.read(householdsNotifierProvider.notifier).loadHouseholds();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredHouseholds.length,
                  itemBuilder: (context, index) {
                    final household = filteredHouseholds[index];
                    final isSelected = _selectedHouseholdId == household.id;
                    
                    return Dismissible(
                      key: Key(household.id ?? index.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(height: 4),
                            Text('Supprimer',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Supprimer le ménage'),
                            content: Text(
                                'Supprimer "${household.householdHeadName}" ?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Supprimer',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) async {
                        try {
                          await ref
                              .read(householdsNotifierProvider.notifier)
                              .deleteHousehold(household.id!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ménage supprimé'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          if (_selectedHouseholdId == household.id) {
                            setState(() => _selectedHouseholdId = null);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erreur: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (isTablet) {
                            setState(() => _selectedHouseholdId = household.id);
                          } else {
                            context.push('/households/${household.id}');
                          }
                        },
                        child: Container(
                          decoration: isTablet && isSelected
                              ? BoxDecoration(
                                  border: Border.all(color: AppColors.primary, width: 2),
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                  boxShadow: AppShadows.coloredPrimary,
                                )
                              : null,
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: isTablet && isSelected
                                ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg))
                                : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(
                                  household.householdHeadName[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                household.householdHeadName,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          household.address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.people,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                          '${household.memberCount} membre(s)'),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.gps_fixed,
                                          size: 14, color: Colors.green),
                                      const SizedBox(width: 4),
                                      const Text('GPS'),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );

              if (isTablet) {
                // ─── MASTER-DETAIL VIEW ───
                return Row(
                  children: [
                    // MASTER (Left - 35%)
                    SizedBox(
                      width: constraints.maxWidth * 0.35,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: AppColors.lightBorder, width: 1)),
                        ),
                        child: listWidget,
                      ),
                    ),
                    // DETAIL (Right - 65%)
                    Expanded(
                      child: _selectedHouseholdId != null
                          ? HouseholdDetailsPage(
                              key: ValueKey(_selectedHouseholdId),
                              householdId: _selectedHouseholdId!,
                            )
                          : const EmptyStateWidget(
                              icon: Icons.home_work_outlined,
                              title: 'Sélectionnez un ménage',
                              description: 'Les détails complets et la liste des membres s\'afficheront ici.',
                            ),
                    ),
                  ],
                );
              } else {
                // ─── MOBILE VIEW ───
                return listWidget;
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(householdsNotifierProvider.notifier).loadHouseholds();
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
          context.push('/households/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau Ménage'),
      ),
    );
  }
}
