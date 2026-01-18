import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../init_dependencies.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/attendance/presentation/employee/pages/check_in_page.dart';
import '../../features/attendance/presentation/admin/pages/attendance_dashboard_page.dart';
import '../../features/attendance/presentation/employee/bloc/check_in_bloc.dart';
import '../../features/attendance/presentation/admin/bloc/attendance_dashboard_bloc.dart';
import '../../features/leave_management/presentation/employee/pages/leave_request_page.dart';
import '../../features/leave_management/presentation/employee/bloc/leave_request_bloc.dart';
import '../../features/leave_management/presentation/admin/pages/leave_approval_page.dart';
import '../../features/leave_management/presentation/admin/bloc/leave_approval_bloc.dart';
import '../../features/employee_management/presentation/pages/employee_list_page.dart';
import '../../features/employee_management/presentation/pages/add_edit_employee_page.dart';
import '../../features/employee_management/presentation/bloc/employee_bloc.dart';
import '../../core/common/entities/user.dart';

/// App Router Configuration using go_router.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // --- Auth Routes ---
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // --- Employee Routes ---
      GoRoute(
        path: '/employee',
        name: 'employee-home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Employee Dashboard - Placeholder')),
        ),
        routes: [
          GoRoute(
            path: 'check-in',
            name: 'check-in',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<CheckInBloc>(),
              child: const CheckInPage(),
            ),
          ),
          GoRoute(
            path: 'leave',
            name: 'leave-request',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<LeaveRequestBloc>(),
              child: const LeaveRequestPage(),
            ),
          ),
          GoRoute(
            path: 'chatbot',
            name: 'chatbot',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('HR Chatbot - Placeholder')),
            ),
          ),
          GoRoute(
            path: 'performance',
            name: 'performance-insights',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Performance Insights - Placeholder')),
            ),
          ),
        ],
      ),

      // --- Admin Routes ---
      GoRoute(
        path: '/admin',
        name: 'admin-home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Admin Dashboard - Placeholder')),
        ),
        routes: [
          GoRoute(
            path: 'attendance',
            name: 'live-attendance',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<AttendanceDashboardBloc>(),
              child: const AttendanceDashboardPage(),
            ),
          ),
          GoRoute(
            path: 'employees',
            name: 'employee-management',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<EmployeeBloc>(),
              child: const EmployeeListPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: 'add-employee',
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<EmployeeBloc>(),
                  child: const AddEditEmployeePage(),
                ),
              ),
              GoRoute(
                path: 'edit',
                name: 'edit-employee',
                builder: (context, state) {
                  final employee = state.extra as User;
                  return BlocProvider(
                    create: (_) => sl<EmployeeBloc>(),
                    child: AddEditEmployeePage(employee: employee),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'leave-approvals',
            name: 'leave-approvals',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<LeaveApprovalBloc>(),
              child: const LeaveApprovalPage(),
            ),
          ),
          GoRoute(
            path: 'payroll',
            name: 'payroll',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Payroll - Placeholder')),
            ),
          ),
          GoRoute(
            path: 'anomalies',
            name: 'anomaly-detection',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('AI Anomalies - Placeholder')),
            ),
          ),
          GoRoute(
            path: 'analytics',
            name: 'performance-analytics',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Performance Analytics - Placeholder')),
            ),
          ),
          GoRoute(
            path: 'reports',
            name: 'reports',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Reports (PDF/Excel) - Placeholder')),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.path}')),
    ),
  );
}
