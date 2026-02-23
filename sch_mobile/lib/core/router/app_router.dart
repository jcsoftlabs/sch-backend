import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/patients/presentation/pages/create_patient_page.dart';
import '../../features/households/presentation/pages/create_household_page.dart';
import '../../features/households/presentation/pages/household_details_page.dart';
import '../../features/households/presentation/pages/add_member_page.dart';
import '../../features/triage/presentation/pages/case_reports_page.dart';
import '../../features/triage/presentation/pages/create_case_report_page.dart';
import '../../features/triage/presentation/pages/case_report_details_page.dart';
import '../../features/vaccinations/presentation/pages/create_vaccination_page.dart';
import '../../features/patients/presentation/pages/create_vital_sign_page.dart';
import '../../features/patients/presentation/pages/create_maternal_care_page.dart';
import '../../features/patients/presentation/pages/record_prenatal_visit_page.dart';
import '../../features/patients/presentation/pages/record_delivery_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/patients/create',
        name: 'create-patient',
        builder: (context, state) => const CreatePatientPage(),
      ),
      GoRoute(
        path: '/households/create',
        name: 'create-household',
        builder: (context, state) => const CreateHouseholdPage(),
      ),
      GoRoute(
        path: '/households/:id',
        name: 'household-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return HouseholdDetailsPage(householdId: id);
        },
      ),
      GoRoute(
        path: '/households/:id/add-member',
        name: 'add-household-member',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddMemberPage(householdId: id);
        },
      ),
      GoRoute(
        path: '/triage',
        name: 'triage',
        builder: (context, state) => const CaseReportsPage(),
      ),
      GoRoute(
        path: '/triage/create',
        name: 'create-case-report',
        builder: (context, state) => const CreateCaseReportPage(),
      ),
      GoRoute(
        path: '/triage/case/:id',
        name: 'case-report-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CaseReportDetailsPage(caseReportId: id);
        },
      ),
      GoRoute(
        path: '/patients/:id/vaccination/new',
        name: 'create-vaccination',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateVaccinationPage(patientId: id);
        },
      ),
      GoRoute(
        path: '/patients/:id/vitals/new',
        name: 'create-vital-signs',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateVitalSignPage(patientId: id);
        },
      ),
      GoRoute(
        path: '/patients/:id/maternal/new',
        name: 'create-maternal-care',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateMaternalCarePage(patientId: id);
        },
      ),
      GoRoute(
        path: '/maternal/:id/visit',
        name: 'record-prenatal-visit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RecordPrenatalVisitPage(maternalCareId: id);
        },
      ),
      GoRoute(
        path: '/maternal/:id/delivery',
        name: 'record-delivery',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RecordDeliveryPage(maternalCareId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
