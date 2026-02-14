import 'package:drift/drift.dart';
import '../database/app_database.dart';

class SyncQueueService {
  final AppDatabase _db;

  SyncQueueService(this._db);

  // Add operation to sync queue
  Future<int> addToQueue({
    required String operation,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    return await _db.into(_db.syncQueue).insert(
      SyncQueueCompanion.insert(
        operation: operation,
        entityType: entityType,
        entityId: entityId,
        payload: _encodeJson(payload),
        createdAt: DateTime.now(),
      ),
    );
  }

  // Get pending operations
  Future<List<SyncQueueData>> getPendingOperations() async {
    return await (_db.select(_db.syncQueue)
          ..where((tbl) => tbl.status.equals('pending'))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
        .get();
  }

  // Mark operation as completed
  Future<void> markAsCompleted(int id) async {
    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(const SyncQueueCompanion(status: Value('completed')));
  }

  // Mark operation as failed
  Future<void> markAsFailed(int id, String errorMessage) async {
    final current = await (_db.select(_db.syncQueue)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();

    await (_db.update(_db.syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(SyncQueueCompanion(
      status: const Value('failed'),
      errorMessage: Value(errorMessage),
      retryCount: Value(current.retryCount + 1),
    ));
  }

  // Retry failed operations
  Future<void> retryFailed() async {
    await (_db.update(_db.syncQueue)
          ..where((tbl) => tbl.status.equals('failed')))
        .write(const SyncQueueCompanion(status: Value('pending')));
  }

  // Clear completed operations
  Future<void> clearCompleted() async {
    await (_db.delete(_db.syncQueue)
          ..where((tbl) => tbl.status.equals('completed')))
        .go();
  }

  // Get queue count
  Future<int> getPendingCount() async {
    final query = _db.selectOnly(_db.syncQueue)
      ..addColumns([_db.syncQueue.id.count()])
      ..where(_db.syncQueue.status.equals('pending'));

    final result = await query.getSingle();
    return result.read(_db.syncQueue.id.count()) ?? 0;
  }

  String _encodeJson(Map<String, dynamic> json) {
    return json.toString(); // In production, use json.encode()
  }

  Map<String, dynamic> _decodeJson(String json) {
    return {}; // In production, use json.decode()
  }
}
