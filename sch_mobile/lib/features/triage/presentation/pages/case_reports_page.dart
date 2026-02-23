import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/triage_providers.dart';
import '../widgets/case_report_card.dart';
import '../../data/models/case_report_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Page to display list of case reports for the current agent
class CaseReportsPage extends ConsumerStatefulWidget {
  const CaseReportsPage({super.key});

  @override
  ConsumerState<CaseReportsPage> createState() => _CaseReportsPageState();
}

class _CaseReportsPageState extends ConsumerState<CaseReportsPage> {
  CaseReportStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // Load case reports on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCaseReports();
    });
  }

  void _loadCaseReports() {
    final user = ref.read(authStateProvider).user;
    if (user != null) {
      ref.read(caseReportsProvider.notifier).loadCaseReports(user.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final caseReportsAsync = ref.watch(caseReportsProvider);
    final user = ref.watch(authStateProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports de Cas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCaseReports,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadCaseReports();
        },
        child: caseReportsAsync.when(
          data: (caseReports) {
            final filteredCases = _filterCases(caseReports);

            if (filteredCases.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredCases.length,
              itemBuilder: (context, index) {
                final caseReport = filteredCases[index];
                return CaseReportCard(
                  caseReport: caseReport,
                  onTap: () {
                    context.push('/triage/case/${caseReport.id}');
                  },
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadCaseReports,
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/triage/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau Cas'),
      ),
    );
  }

  List<CaseReportModel> _filterCases(List<CaseReportModel> cases) {
    if (_selectedFilter == null) {
      return cases;
    }
    return cases.where((c) => c.status == _selectedFilter).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == null
                ? 'Aucun rapport de cas'
                : 'Aucun cas ${_getFilterLabel()}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier rapport de cas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterLabel() {
    switch (_selectedFilter) {
      case CaseReportStatus.pending:
        return 'en attente';
      case CaseReportStatus.assigned:
        return 'assignés';
      case CaseReportStatus.resolved:
        return 'résolus';
      default:
        return '';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(null, 'Tous les cas'),
            _buildFilterOption(CaseReportStatus.pending, 'En attente'),
            _buildFilterOption(CaseReportStatus.assigned, 'Assignés'),
            _buildFilterOption(CaseReportStatus.resolved, 'Résolus'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(CaseReportStatus? status, String label) {
    return RadioListTile<CaseReportStatus?>(
      title: Text(label),
      value: status,
      groupValue: _selectedFilter,
      onChanged: (value) {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }
}
