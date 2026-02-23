import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/models/case_report_model.dart';
import '../../data/models/medical_protocol_model.dart';
import '../../data/repositories/case_report_repository.dart';
import '../../data/repositories/medical_protocol_repository.dart';
import '../../data/repositories/offline_case_report_repository.dart';
import '../../data/repositories/offline_medical_protocol_repository.dart';
import '../../domain/services/triage_service.dart';

// ============================================================================
// Repository Providers
// ============================================================================

final caseReportRepositoryProvider = Provider<CaseReportRepository>((ref) {
  return CaseReportRepository(ApiClient());
});

final medicalProtocolRepositoryProvider =
    Provider<MedicalProtocolRepository>((ref) {
  return MedicalProtocolRepository(ApiClient());
});

final offlineCaseReportRepositoryProvider =
    Provider<OfflineCaseReportRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineCaseReportRepository(db);
});

final offlineMedicalProtocolRepositoryProvider =
    Provider<OfflineMedicalProtocolRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfflineMedicalProtocolRepository(db);
});

// ============================================================================
// Service Providers
// ============================================================================

final triageServiceProvider = Provider<TriageService>((ref) {
  return TriageService(
    ref.read(medicalProtocolRepositoryProvider),
    ApiClient().dio,
  );
});

// ============================================================================
// State Providers
// ============================================================================

/// Provider for medical protocols (online + offline fallback)
final medicalProtocolsProvider =
    FutureProvider<List<MedicalProtocolModel>>((ref) async {
  try {
    // Try to fetch from backend
    final protocols =
        await ref.read(medicalProtocolRepositoryProvider).getActiveProtocols();

    // Save to local database
    await ref
        .read(offlineMedicalProtocolRepositoryProvider)
        .saveProtocolsLocally(protocols);

    return protocols;
  } catch (e) {
    // Fallback to local database if offline

    return ref
        .read(offlineMedicalProtocolRepositoryProvider)
        .getLocalActiveProtocols();
  }
});

/// Provider for case reports of current agent
final caseReportsProvider = StateNotifierProvider<CaseReportsNotifier,
    AsyncValue<List<CaseReportModel>>>((ref) {
  return CaseReportsNotifier(
    ref.read(caseReportRepositoryProvider),
    ref.read(offlineCaseReportRepositoryProvider),
  );
});

/// State Notifier for managing case reports
class CaseReportsNotifier
    extends StateNotifier<AsyncValue<List<CaseReportModel>>> {
  final CaseReportRepository _onlineRepo;
  final OfflineCaseReportRepository _offlineRepo;

  CaseReportsNotifier(this._onlineRepo, this._offlineRepo)
      : super(const AsyncValue.loading());

  /// Load case reports for an agent
  Future<void> loadCaseReports(String agentId) async {
    state = const AsyncValue.loading();

    try {
      // Try online first
      final caseReports = await _onlineRepo.getCaseReports(agentId);

      // Save to local database
      for (final caseReport in caseReports) {
        await _offlineRepo.saveCaseReportLocally(caseReport);
      }

      state = AsyncValue.data(caseReports);
    } catch (e, stack) {
      // Fallback to offline

      try {
        final localCaseReports = await _offlineRepo.getLocalCaseReports(agentId);
        state = AsyncValue.data(localCaseReports);
      } catch (offlineError, offlineStack) {
        state = AsyncValue.error(offlineError, offlineStack);
      }
    }
  }

  /// Create a new case report
  Future<CaseReportModel?> createCaseReport(
    CreateCaseReportDto dto,
  ) async {
    try {
      // Try online first
      final caseReport = await _onlineRepo.createCaseReport(dto);

      // Save to local database
      await _offlineRepo.saveCaseReportLocally(caseReport);

      // Update state
      state.whenData((caseReports) {
        state = AsyncValue.data([caseReport, ...caseReports]);
      });

      return caseReport;
    } catch (e) {
      // Create offline

      final caseReport = await _offlineRepo.createCaseReportLocally(
        agentId: dto.agentId,
        patientId: dto.patientId,
        symptoms: dto.symptoms,
        urgency: dto.urgency,
        channel: dto.channel,
        imageUrl: dto.imageUrl,
        latitude: dto.latitude,
        longitude: dto.longitude,
        zone: dto.zone,
      );

      // Update state
      state.whenData((caseReports) {
        state = AsyncValue.data([caseReport, ...caseReports]);
      });

      return caseReport;
    }
  }

  /// Update a case report
  Future<void> updateCaseReport(
    String id,
    UpdateCaseReportDto dto,
  ) async {
    try {
      // Try online first
      final updatedCaseReport = await _onlineRepo.updateCaseReport(id, dto);

      // Update local database
      await _offlineRepo.saveCaseReportLocally(updatedCaseReport);

      // Update state
      state.whenData((caseReports) {
        final index = caseReports.indexWhere((c) => c.id == id);
        if (index != -1) {
          final updated = [...caseReports];
          updated[index] = updatedCaseReport;
          state = AsyncValue.data(updated);
        }
      });
    } catch (e) {
      // Update offline

      // Note: We need to get the full case report to update it
      final existingCase = await _offlineRepo.getCaseReportById(id);
      if (existingCase != null) {
        final updatedCase = CaseReportModel(
          id: existingCase.id,
          agentId: existingCase.agentId,
          patientId: existingCase.patientId,
          symptoms: existingCase.symptoms,
          urgency: existingCase.urgency,
          channel: existingCase.channel,
          status: dto.status ?? existingCase.status,
          doctorId: existingCase.doctorId,
          response: dto.response ?? existingCase.response,
          referral: dto.referral ?? existingCase.referral,
          imageUrl: existingCase.imageUrl,
          latitude: existingCase.latitude,
          longitude: existingCase.longitude,
          zone: existingCase.zone,
          resolvedAt: existingCase.resolvedAt,
          createdAt: existingCase.createdAt,
          updatedAt: DateTime.now(),
        );

        await _offlineRepo.updateCaseReportLocally(updatedCase);

        // Update state
        state.whenData((caseReports) {
          final index = caseReports.indexWhere((c) => c.id == id);
          if (index != -1) {
            final updated = [...caseReports];
            updated[index] = updatedCase;
            state = AsyncValue.data(updated);
          }
        });
      }
    }
  }

  /// Sync pending case reports
  Future<void> syncPendingCaseReports() async {
    final pendingCases = await _offlineRepo.getPendingSyncCaseReports();

    for (final caseReport in pendingCases) {
      try {
        // Try to sync to backend
        final dto = CreateCaseReportDto(
          agentId: caseReport.agentId,
          patientId: caseReport.patientId,
          symptoms: caseReport.symptoms,
          urgency: caseReport.urgency,
          channel: caseReport.channel,
          imageUrl: caseReport.imageUrl,
          latitude: caseReport.latitude,
          longitude: caseReport.longitude,
          zone: caseReport.zone,
        );

        await _onlineRepo.createCaseReport(dto);

        // Mark as synced
        await _offlineRepo.markAsSynced(caseReport.id);


      } catch (e) {

        // Continue with next case
      }
    }
  }
}
