import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/auth/signup_viewmodel.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/auth/login_screen.dart';
import 'package:pawdetect/views/auth/widgets/shared/app_logo.dart';
import 'package:pawdetect/views/auth/widgets/shared/appname_title.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'widgets/signup/signup_form.dart';
import '../../../styles/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => __SignUpScreenState();
}

class __SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupViewModel>().clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return PopScope(
      canPop: false, //prevent default back pop
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: loc.signup),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              AppLogo(),
              SizedBox(height: 20),
              AppnNameTitle(),
              SizedBox(height: 20),
              Text(
                loc.signup_description,
                style: TextStyle(fontSize: 16, color: AppColors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
