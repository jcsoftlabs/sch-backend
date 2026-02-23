import '../../../../core/providers/sync_provider.dart';
import '../../presentation/providers/triage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service to sync case reports when connectivity is restored
class CaseReportSyncService {
  final Ref ref;

  CaseReportSyncService(this.ref);

  /// Sync all pending case reports to backend
  Future<void> syncPendingCaseReports() async {
    print('🔄 Starting case report sync...');
    
    final notifier = ref.read(caseReportsProvider.notifier);
    await notifier.syncPendingCaseReports();
    
    print('✅ Case report sync completed');
  }
}

/// Provider for case report sync service
final caseReportSyncServiceProvider = Provider<CaseReportSyncService>((ref) {
  return CaseReportSyncService(ref);
});
