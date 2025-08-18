// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'styles/app_colors.dart';
import '/screens/welcome_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // handle background message if needed
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Because you added GoogleService-Info.plist to the iOS target,
  // iOS can auto-load config. (No options argument needed.)
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: false,
      primaryColor: AppColors.orange,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
    );

    return MaterialApp(
      title: 'PawDetect',
      theme: theme,
      home: const WelcomeScreen(),
    );
  }
}