import 'package:flutter/material.dart';
import 'package:pawdetect/services/user_service.dart';
import 'package:pawdetect/viewmodels/forgot_password_viewmodel.dart';
import 'package:pawdetect/viewmodels/home_viewmodel.dart';
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/viewmodels/profile_viewmodel.dart';
import 'package:pawdetect/views/auth/forgot_password_screen.dart';
import 'package:pawdetect/views/home/home_screen.dart';
import 'package:pawdetect/views/home/profile_screen.dart';
import 'package:pawdetect/views/reports/add_new_report_screen.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// viewmodels
import 'package:pawdetect/viewmodels/welcome_viewmodel.dart';
import 'package:pawdetect/viewmodels/login_viewmodel.dart';
import 'package:pawdetect/viewmodels/signup_viewmodel.dart';
import 'package:pawdetect/viewmodels/add_report_viewmodel.dart';

// views
import 'package:pawdetect/views/welcome/welcome_screen.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PawDetectApp());
}

class PawDetectApp extends StatelessWidget {
  const PawDetectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => AddReportViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel(UserService())),
          ChangeNotifierProvider(create: (_) => MyReportsViewModel()),
        // add more ViewModels in case it grows
      ],
      child: MaterialApp(
        title: 'PawDetect',
        debugShowCheckedModeBanner: false,
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
        },
      ),
    );
  }
}
