import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'init_dependencies.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/Auth/presentation/bloc/auth_bloc.dart';
import 'features/fcm/presentation/bloc/fcm_bloc.dart';

/// Background message handler for FCM.
/// Must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set up FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize dependencies (GetIt)
  await initDependencies();

  // Request FCM permissions (iOS)
  await _requestFCMPermissions();

  runApp(const TalentForgeApp());
}

/// Request FCM notification permissions.
Future<void> _requestFCMPermissions() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('FCM Permission status: ${settings.authorizationStatus}');

  // Get FCM token for this device
  final token = await messaging.getToken();
  print('FCM Token: $token');
}

class TalentForgeApp extends StatefulWidget {
  const TalentForgeApp({super.key});

  @override
  State<TalentForgeApp> createState() => _TalentForgeAppState();
}

class _TalentForgeAppState extends State<TalentForgeApp> {
  @override
  void initState() {
    super.initState();
    _setupFCMListeners();
  }

  void _setupFCMListeners() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Notification: ${message.notification?.title}');
        // TODO: Show in-app notification using overlay or snackbar
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app from background!');
      // TODO: Navigate to relevant screen based on message.data
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (_) => sl<FcmBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<FcmBloc>().add(
              UpsertFcmDeviceEvent(
                userId: state.user.id.toString(),
                authStatus: 'logged_in',
              ),
            );
          } else if (state is Unauthenticated) {
            // Optionally handle logout sync
          }
        },
        child: MaterialApp.router(
          title: 'TalentForge',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
