import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/home/widgets/profile/profile_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: CustomAppBar(title: loc.profile_title),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileForm(),
            const SizedBox(height: 16),

            // Log out
            PrimaryButton(
              text: loc.logout,
              onPressed: () async {
                await profileViewModel.logout();
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
