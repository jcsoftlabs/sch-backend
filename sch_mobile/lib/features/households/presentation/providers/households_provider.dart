import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/household_model.dart';
import '../../data/models/household_member_model.dart';
import '../../data/repositories/households_repository.dart';

// Repository provider
final householdsRepositoryProvider = Provider<HouseholdsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HouseholdsRepository(apiClient);
});

// Households list provider
final householdsListProvider =
    FutureProvider.autoDispose<List<HouseholdModel>>((ref) async {
  final repository = ref.watch(householdsRepositoryProvider);
  return await repository.getHouseholds();
});

// Single household provider
final householdProvider =
    FutureProvider.autoDispose.family<HouseholdModel, String>((ref, id) async {
  final repository = ref.watch(householdsRepositoryProvider);
  return await repository.getHousehold(id);
});

// Household members provider
final householdMembersProvider = FutureProvider.autoDispose
    .family<List<HouseholdMemberModel>, String>((ref, householdId) async {
  final repository = ref.watch(householdsRepositoryProvider);
  return await repository.getHouseholdMembers(householdId);
});

// Households notifier for state management
class HouseholdsNotifier extends StateNotifier<AsyncValue<List<HouseholdModel>>> {
  final HouseholdsRepository _repository;

  HouseholdsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHouseholds();
  }

  Future<void> loadHouseholds() async {
    state = const AsyncValue.loading();
    try {
      final households = await _repository.getHouseholds();
      state = AsyncValue.data(households);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createHousehold(HouseholdModel household) async {
    try {
      await _repository.createHousehold(household);
      await loadHouseholds(); // Reload list
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateHousehold(String id, HouseholdModel household) async {
    try {
      await _repository.updateHousehold(id, household);
      await loadHouseholds(); // Reload list
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteHousehold(String id) async {
    try {
      await _repository.deleteHousehold(id);
      await loadHouseholds(); // Reload list
    } catch (e) {
      rethrow;
    }
  }
}

// Households notifier provider
final householdsNotifierProvider =
    StateNotifierProvider<HouseholdsNotifier, AsyncValue<List<HouseholdModel>>>(
  (ref) {
    final repository = ref.watch(householdsRepositoryProvider);
    return HouseholdsNotifier(repository);
  },
);
