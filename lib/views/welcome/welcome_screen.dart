import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/welcome_viewmodel.dart';
import '../../../styles/app_colors.dart';
import 'widgets/welcome_header.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/welcome_title.dart';
import 'widgets/welcome_description.dart';
import 'widgets/welcome_actions.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const WelcomeHeader(),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WelcomeLogo(),
                SizedBox(height: 32),
                WelcomeTitle(),
                SizedBox(height: 12),
                WelcomeDescription(),
                SizedBox(height: 40),
                WelcomeActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
