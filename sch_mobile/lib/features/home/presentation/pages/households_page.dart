import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../households/presentation/providers/households_provider.dart';

class HouseholdsPage extends ConsumerStatefulWidget {
  const HouseholdsPage({super.key});

  @override
  ConsumerState<HouseholdsPage> createState() => _HouseholdsPageState();
}

class _HouseholdsPageState extends ConsumerState<HouseholdsPage> {
  String _searchQuery = '';

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Aucun ménage enregistré'
                        : 'Aucun résultat trouvé',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isEmpty)
                    Text(
                      'Appuyez sur + pour ajouter un ménage',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(householdsNotifierProvider.notifier).loadHouseholds();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredHouseholds.length,
              itemBuilder: (context, index) {
                final household = filteredHouseholds[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        household.householdHeadName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      household.householdHeadName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
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
                            const Icon(Icons.people, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${household.memberCount} membre(s)'),
                            const SizedBox(width: 16),
                            const Icon(Icons.gps_fixed, size: 14, color: Colors.green),
                            const SizedBox(width: 4),
                            Text('GPS'),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (household.id != null) {
                        context.push('/households/${household.id}');
                      }
                    },
                  ),
                );
              },
            ),
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
