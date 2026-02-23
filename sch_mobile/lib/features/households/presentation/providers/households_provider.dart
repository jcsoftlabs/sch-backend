import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/household_model.dart';
import '../../data/models/household_member_model.dart';
import '../../data/repositories/households_repository.dart';
import '../../data/repositories/offline_households_repository.dart';

// ── Repository providers ────────────────────────────────────────────────────

final householdsRepositoryProvider = Provider<HouseholdsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HouseholdsRepository(apiClient);
});

final offlineHouseholdsRepositoryProvider =
    Provider<OfflineHouseholdsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineHouseholdsRepository(db);
});

// ── FutureProviders (read-only) ─────────────────────────────────────────────

/// List households — tries API first, falls back to local DB.
final householdsListProvider =
    FutureProvider.autoDispose<List<HouseholdModel>>((ref) async {
  final online = ref.watch(householdsRepositoryProvider);
  final offline = ref.watch(offlineHouseholdsRepositoryProvider);

  try {
    final households = await online.getHouseholds();
    // Cache them locally for offline use
    await offline.saveHouseholds(households);
    return households;
  } catch (_) {
    // Fallback to local DB when offline
    return offline.getAllHouseholds();
  }
});

/// Single household — API first, then local DB fallback.
final householdProvider =
    FutureProvider.autoDispose.family<HouseholdModel, String>((ref, id) async {
  final online = ref.watch(householdsRepositoryProvider);
  final offline = ref.watch(offlineHouseholdsRepositoryProvider);

  try {
    final h = await online.getHousehold(id);
    await offline.saveHousehold(h);
    return h;
  } catch (_) {
    final h = await offline.getHouseholdById(id);
    if (h != null) return h;
    rethrow;
  }
});

/// Members of a household — API first, local DB fallback.
final householdMembersProvider = FutureProvider.autoDispose
    .family<List<HouseholdMemberModel>, String>((ref, householdId) async {
  final online = ref.watch(householdsRepositoryProvider);
  final offline = ref.watch(offlineHouseholdsRepositoryProvider);

  try {
    final members = await online.getHouseholdMembers(householdId);
    await offline.saveMembers(members);
    return members;
  } catch (_) {
    return offline.getHouseholdMembers(householdId);
  }
});

// ── Notifier (write operations) ─────────────────────────────────────────────

class HouseholdsNotifier
    extends StateNotifier<AsyncValue<List<HouseholdModel>>> {
  final HouseholdsRepository _online;
  final OfflineHouseholdsRepository _offline;

  HouseholdsNotifier(this._online, this._offline)
      : super(const AsyncValue.loading()) {
    loadHouseholds();
  }

  Future<void> loadHouseholds() async {
    state = const AsyncValue.loading();
    try {
      final households = await _online.getHouseholds();
      await _offline.saveHouseholds(households);
      state = AsyncValue.data(households);
    } catch (_) {
      // Offline fallback
      try {
        final cached = await _offline.getAllHouseholds();
        state = AsyncValue.data(cached);
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  Future<void> createHousehold(HouseholdModel household) async {
    try {
      final created = await _online.createHousehold(household);
      await _offline.saveHousehold(created.copyWith(isSynced: true));
    } catch (_) {
      // Save locally as pending when offline
      await _offline.saveHousehold(household.copyWith(isSynced: false));
    }
    await loadHouseholds();
  }

  Future<void> updateHousehold(String id, HouseholdModel household) async {
    try {
      final updated = await _online.updateHousehold(id, household);
      await _offline.saveHousehold(updated.copyWith(isSynced: true));
    } catch (_) {
      await _offline.saveHousehold(household.copyWith(isSynced: false));
    }
    await loadHouseholds();
  }

  /// Delete a household — removes from API and local DB.
  Future<void> deleteHousehold(String id) async {
    try {
      await _online.deleteHousehold(id);
    } catch (_) {
      // Continue with local delete even if offline
    }
    await _offline.deleteHousehold(id);
    await loadHouseholds();
  }

  /// Delete a household member — removes from API and local DB.
  Future<void> deleteMember(String householdId, String memberId) async {
    try {
      await _online.deleteHouseholdMember(householdId, memberId);
    } catch (_) {
      // Continue with local delete even if offline
    }
    await _offline.deleteMember(memberId);
  }
}

final householdsNotifierProvider = StateNotifierProvider<HouseholdsNotifier,
    AsyncValue<List<HouseholdModel>>>((ref) {
  final online = ref.watch(householdsRepositoryProvider);
  final offline = ref.watch(offlineHouseholdsRepositoryProvider);
  return HouseholdsNotifier(online, offline);
});
