import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';

import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pawdetect/navigation.dart';
import 'package:pawdetect/services/user_service.dart';

// ViewModels
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/viewmodels/auth/welcome_viewmodel.dart';
import 'package:pawdetect/viewmodels/auth/login_viewmodel.dart';
import 'package:pawdetect/viewmodels/auth/signup_viewmodel.dart';
import 'package:pawdetect/viewmodels/auth/forgot_password_viewmodel.dart';
import 'package:pawdetect/viewmodels/report/add_report_viewmodel.dart';
import 'package:pawdetect/viewmodels/report/all_reports_viewmodel.dart';
import 'package:pawdetect/viewmodels/report/my_reports_viewmodel.dart';
import 'package:pawdetect/viewmodels/home/home_viewmodel.dart';
import 'package:pawdetect/viewmodels/home/profile_viewmodel.dart';

// Screens
import 'package:pawdetect/views/welcome/welcome_screen.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/auth/forgot_password_screen.dart';
import 'package:pawdetect/views/home/home_screen.dart';
import 'package:pawdetect/views/home/profile_screen.dart';
import 'package:pawdetect/views/guest/guest_home_screen.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:pawdetect/views/reports/add_new_report_screen.dart';
import 'package:pawdetect/views/reports/guest_add_new_report_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final app = Firebase.app();
  debugPrint(
    'FIREBASE projectId=${app.options.projectId} appId=${app.options.appId}',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalizationViewModel()..load()),

        // Auth
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),

        // Reports
        ChangeNotifierProvider(create: (_) => AddReportViewModel()),
        ChangeNotifierProvider(create: (_) => AllReportsViewModel()),
        ChangeNotifierProvider(create: (_) => MyReportsViewModel()),

        // Home/Profile
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel(UserService())),
      ],
      child: const PawDetectApp(),
    ),
  );
}

class PawDetectApp extends StatelessWidget {
  const PawDetectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch current locale from the VM
    final localeVm = context.watch<LocalizationViewModel>();

    return MaterialApp(
      title: 'PawDetect',
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      initialRoute: "/welcome",
      routes: {
        "/welcome": (_) => const WelcomeScreen(),
        "/login": (_) => const LoginScreen(),
        "/signup": (_) => const SignUpScreen(),
        "/forgot-password": (_) => const ForgotPasswordScreen(),
        "/home": (_) => const HomeScreen(),
        "/profile": (_) => const ProfileScreen(),
        "/myreports": (_) => const MyReportsScreen(),
        "/add_report": (_) => const AddNewReportScreen(),
        "/guest-home": (_) => const GuestHomeScreen(),
        "/guest-add-found-report": (_) => const GuestAddNewReportScreen(),
      },

      // Localization wiring
      locale: localeVm.locale, // app language comes from the viewmodel
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ro')],
    );
  }
}
