import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/household_model.dart';
import '../../data/models/household_member_model.dart';
import '../providers/households_provider.dart';
import '../../../../core/theme/app_theme.dart';

class HouseholdDetailsPage extends ConsumerWidget {
  final String householdId;

  const HouseholdDetailsPage({
    super.key,
    required this.householdId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdAsync = ref.watch(householdProvider(householdId));
    final membersAsync = ref.watch(householdMembersProvider(householdId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Ménage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Modification à venir')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Supprimer le ménage',
            onPressed: () => _showDeleteHouseholdDialog(context, ref),
          ),
        ],
      ),
      body: householdAsync.when(
        data: (household) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Household Info Card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations du Ménage',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.person,
                        label: 'Chef de ménage',
                        value: household.householdHeadName,
                      ),
                      _InfoRow(
                        icon: Icons.location_on,
                        label: 'Adresse',
                        value: household.address,
                      ),
                      if (household.neighborhood != null)
                        _InfoRow(
                          icon: Icons.location_city,
                          label: 'Quartier',
                          value: household.neighborhood!,
                        ),
                      if (household.commune != null)
                        _InfoRow(
                          icon: Icons.map,
                          label: 'Commune',
                          value: household.commune!,
                        ),
                      if (household.phone != null)
                        _InfoRow(
                          icon: Icons.phone,
                          label: 'Téléphone',
                          value: household.phone!,
                        ),
                      _InfoRow(
                        icon: Icons.gps_fixed,
                        label: 'GPS',
                        value: '${household.latitude.toStringAsFixed(6)}, ${household.longitude.toStringAsFixed(6)}',
                      ),
                      if (household.housingType != null)
                        _InfoRow(
                          icon: Icons.home,
                          label: 'Type de logement',
                          value: household.housingType!,
                        ),
                      if (household.numberOfRooms != null)
                        _InfoRow(
                          icon: Icons.meeting_room,
                          label: 'Nombre de pièces',
                          value: household.numberOfRooms.toString(),
                        ),
                      _InfoRow(
                        icon: Icons.electric_bolt,
                        label: 'Électricité',
                        value: household.hasElectricity ? 'Oui' : 'Non',
                      ),
                      _InfoRow(
                        icon: Icons.people,
                        label: 'Nombre de membres',
                        value: household.memberCount.toString(),
                      ),
                    ],
                  ),
                ),
              ),

              // Members Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Membres du Ménage',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/households/$householdId/add-member');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Members List
              membersAsync.when(
                data: (members) {
                  if (members.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.people_outline, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Aucun membre enregistré',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: member.gender == 'M'
                                ? Colors.blue
                                : member.gender == 'F'
                                    ? Colors.pink
                                    : Colors.grey,
                            child: Text(
                              member.fullName[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            member.fullName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${member.age} ans • ${member.relationshipToHead}'),
                              if (member.hasHealthInsurance)
                                const Row(
                                  children: [
                                    Icon(Icons.health_and_safety, size: 14, color: Colors.green),
                                    SizedBox(width: 4),
                                    Text('Assuré', style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button — 48x48 touch target
                              Tooltip(
                                message: 'Modifier',
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Modification à venir')),
                                    );
                                  },
                                  child: const SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Icon(Icons.edit_outlined, size: 22,
                                        color: AppColors.primary),
                                  ),
                                ),
                              ),
                              // Delete button — 48x48 touch target
                              Tooltip(
                                message: 'Supprimer',
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    _showDeleteDialog(
                                        context, ref, householdId, member);
                                  },
                                  child: const SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Icon(Icons.delete_outline_rounded,
                                        size: 22, color: AppColors.error),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Erreur: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: ${error.toString()}'),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteHouseholdDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Supprimer le ménage'),
        content: const Text(
            'Cette action supprimera le ménage et tous ses membres. Cette opération est irréversible.'),
        actions: [
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
          ),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await ref
                      .read(householdsNotifierProvider.notifier)
                      .deleteHousehold(householdId);
                  if (context.mounted) {
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(children: [
                          Icon(Icons.check_circle_rounded, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Ménage supprimé'),
                        ]),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm)),
                      ),
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Supprimer définitivement'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String householdId,
    HouseholdMemberModel member,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Supprimer le membre'),
        content: Text(
            'Voulez-vous vraiment supprimer ${member.fullName} du ménage ?'),
        actions: [
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
          ),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await ref
                      .read(householdsNotifierProvider.notifier)
                      .deleteMember(householdId, member.id!);
                  ref.invalidate(householdMembersProvider(householdId));
                  if (context.mounted) {
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white),
                          const SizedBox(width: 12),
                          Text('${member.fullName} supprimé'),
                        ]),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm)),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Supprimer'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
