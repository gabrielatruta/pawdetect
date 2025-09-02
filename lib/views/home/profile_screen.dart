import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/home/widgets/profile/profile_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/home/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // re-build on language change

    final errorText = switch (vm.errorKey) {
      'profile_unavailable' => loc.profile_unavailable,
      'profile_updated_f' => loc.profile_updated_f,
      'alerts_fail' => loc.alerts_area,
      null => null,
      _ => loc.default_error,
    };

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: loc.profile_title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorText != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(errorText),
              ),
            ],
            const ProfileForm(),
            const SizedBox(height: 16),
            PrimaryButton(
              text: loc.logout,
              onPressed: () async {
                await vm.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
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
