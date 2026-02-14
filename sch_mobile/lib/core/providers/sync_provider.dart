import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../services/connectivity_service.dart';
import '../services/sync_queue_service.dart';
import '../services/sync_service.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Sync Queue Service Provider
final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  final db = ref.watch(databaseProvider);
  return SyncQueueService(db);
});

// Sync Service Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final queueService = ref.watch(syncQueueServiceProvider);

  final service = SyncService(db, apiClient, connectivity, queueService);
  
  // Start auto-sync
  service.startAutoSync();

  // Cleanup on dispose
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

// Sync Status Provider
final syncStatusProvider = StateProvider<SyncStatus>((ref) {
  return SyncStatus.idle;
});

// Pending Sync Count Provider
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final queueService = ref.watch(syncQueueServiceProvider);
  return await queueService.getPendingCount();
});

// Manual Sync Trigger
final manualSyncProvider = FutureProvider.autoDispose<void>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  await syncService.syncAll();
});
