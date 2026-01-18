import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/Auth/data/datasource/auth_remote_datasource.dart';
import 'features/Auth/data/repositories/auth_repository_impl.dart';
import 'features/Auth/domain/repositories/auth_repository.dart';
import 'features/Auth/presentation/bloc/auth_bloc.dart';
import 'features/employee_management/data/datasources/employee_remote_datasource.dart';
import 'features/employee_management/data/repositories/employee_repository_impl.dart';
import 'features/employee_management/domain/repositories/employee_repository.dart';
import 'features/employee_management/presentation/bloc/employee_bloc.dart';
import 'features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/presentation/employee/bloc/check_in_bloc.dart';
import 'features/attendance/presentation/admin/bloc/attendance_dashboard_bloc.dart';
import 'features/leave_management/data/datasources/leave_remote_datasource.dart';
import 'features/leave_management/data/repositories/leave_repository_impl.dart';
import 'features/leave_management/domain/repositories/leave_repository.dart';
import 'features/leave_management/presentation/employee/bloc/leave_request_bloc.dart';
import 'features/leave_management/presentation/admin/bloc/leave_approval_bloc.dart';
import 'features/fcm/data/datasource/fcm_remote_datasource.dart';
import 'features/fcm/data/repositories/fcm_repository_impl.dart';
import 'features/fcm/domain/repositories/fcm_repository.dart';
import 'features/fcm/domain/usecases/upsert_device.dart';
import 'features/fcm/presentation/bloc/fcm_bloc.dart';
import 'core/services/device_info_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final sl = GetIt.instance;

/// Initialize all dependencies.
/// Call this in main() before runApp().
Future<void> initDependencies() async {
  // ============================================================
  // EXTERNAL DEPENDENCIES
  // ============================================================

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Secure Storage
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // ============================================================
  // CORE
  // ============================================================

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Dio Client
  sl.registerLazySingleton(() => DioClient(secureStorage: sl()));

  // ============================================================
  // FEATURES - AUTH
  // ============================================================

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );

  // BLoCs
  sl.registerLazySingleton(() => AuthBloc(authRepository: sl()));

  // ============================================================
  // FEATURES - EMPLOYEE MANAGEMENT
  // ============================================================
  // Data Sources
  sl.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(sl()),
  );

  // BLoCs
  sl.registerFactory(() => EmployeeBloc(employeeRepository: sl()));

  // ============================================================
  // FEATURES - ATTENDANCE
  // ============================================================

  // Data Sources
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // BLoCs
  sl.registerFactory(() => CheckInBloc(repository: sl()));
  sl.registerFactory(() => AttendanceDashboardBloc(repository: sl()));
  // sl.registerFactory(() => LeaveRequestBloc(...));
  // sl.registerFactory(() => LeaveApprovalBloc(...));

  // ============================================================
  // FEATURES - PAYROLL
  // ============================================================
  // sl.registerFactory(() => PayrollBloc(...));

  // ============================================================
  // FEATURES - AI
  // ============================================================
  // sl.registerFactory(() => AnomalyDetectionBloc(...));
  // sl.registerFactory(() => ChatbotBloc(...));
  // sl.registerFactory(() => PerformanceInsightsBloc(...));

  // ============================================================
  // FEATURES - LEAVE MANAGEMENT
  // ============================================================

  // Data Sources
  sl.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // BLoCs
  sl.registerFactory(() => LeaveRequestBloc(repository: sl()));
  sl.registerFactory(() => LeaveApprovalBloc(repository: sl()));

  // ============================================================
  // FEATURES - NOTIFICATIONS
  // ============================================================
  // sl.registerFactory(() => NotificationBloc(...));
  // sl.registerFactory(() => ReportsBloc(...));

  // ============================================================
  // FEATURES - FCM
  // ============================================================

  // External
  sl.registerLazySingleton(() => FirebaseMessaging.instance);

  // Core Services
  sl.registerLazySingleton<DeviceInfoService>(
    () => DeviceInfoServiceImpl(secureStorage: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<FCMRemoteDataSource>(
    () => FCMRemoteDataSourceImpl(dioClient: sl(), firebaseMessaging: sl()),
  );

  // Repositories
  sl.registerLazySingleton<FCMRepository>(
    () => FcmRepositoryImpl(remote: sl(), deviceInfoService: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => UpsertDevice(repository: sl()));

  // BLoCs
  sl.registerFactory(() => FcmBloc(upsertDevice: sl()));
}
