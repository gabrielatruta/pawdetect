import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/auth/login_viewmodel.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/auth/widgets/shared/app_logo.dart';
import 'package:pawdetect/views/auth/widgets/shared/appname_title.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/auth/widgets/login/login_form.dart';
import 'package:pawdetect/views/auth/widgets/login/login_subtitle.dart';
import 'package:pawdetect/views/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import '../../styles/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginViewModel>().clearError();
    });
  }

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: loc.login),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: const [
                SizedBox(height: 20),
                AppLogo(),
                SizedBox(height: 16),
                AppnNameTitle(),
                SizedBox(height: 8),
                LoginSubtitle(),
                SizedBox(height: 24),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
