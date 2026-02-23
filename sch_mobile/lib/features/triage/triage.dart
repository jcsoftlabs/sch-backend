// Triage Module Exports

// Data Models
export 'data/models/case_report_model.dart';
export 'data/models/medical_protocol_model.dart';
export 'data/models/triage_result_model.dart';

// Repositories
export 'data/repositories/case_report_repository.dart';
export 'data/repositories/medical_protocol_repository.dart';
export 'data/repositories/offline_case_report_repository.dart';
export 'data/repositories/offline_medical_protocol_repository.dart';

// Services
export 'domain/services/triage_service.dart';
export 'domain/services/case_report_sync_service.dart';

// Providers
export 'presentation/providers/triage_providers.dart';

// Widgets
export 'presentation/widgets/urgency_badge.dart';
export 'presentation/widgets/sync_status_indicator.dart';
export 'presentation/widgets/protocol_card.dart';
export 'presentation/widgets/case_report_card.dart';
export 'presentation/widgets/triage_result_card.dart';

// Pages
export 'presentation/pages/case_reports_page.dart';
export 'presentation/pages/create_case_report_page.dart';
export 'presentation/pages/case_report_details_page.dart';
