import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import '../shared/app_logo.dart';
import 'widgets/welcome_appname.dart';
import 'widgets/welcome_title.dart';
import 'widgets/welcome_description.dart';
import 'widgets/welcome_actions.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Spacer(flex: 2),
                WelcomeAppName(),
                SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  width: 400,
                  child: AppLogo(),
                ),
                SizedBox(height: 24),
                WelcomeTitle(),
                SizedBox(height: 12),
                WelcomeDescription(),
                Spacer(),
                WelcomeActions(),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}