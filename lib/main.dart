import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // if you used FlutterFire CLI


// viewmodels
import 'package:pawdetect/viewmodels/welcome_viewmodel.dart';
import 'package:pawdetect/viewmodels/login_viewmodel.dart';
import 'package:pawdetect/viewmodels/signup_viewmodel.dart';
import 'package:pawdetect/viewmodels/add_report_viewmodel.dart';

// views
import 'package:pawdetect/views/welcome/welcome_screen.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/signup_screen.dart';
import 'package:pawdetect/views/reports/add_report_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        // add more ViewModels here as your project grows
      ],
      child: MaterialApp(
        title: 'PawDetect',
        debugShowCheckedModeBanner: false,
        initialRoute: "/welcome",
        routes: {
          "/welcome": (_) => const WelcomeScreen(),
          "/login": (_) => const LoginScreen(),
          "/signup": (_) => const SignUpScreen(),
          "/add_report": (_) => const AddReportScreen(),
        },
      ),
    );
  }
}
