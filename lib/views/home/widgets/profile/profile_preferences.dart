import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class PreferencesForm extends StatelessWidget {
  final bool romanianLanguage;
  final ValueChanged<bool> onLanguageChanged;

  const PreferencesForm({
    super.key,
    required this.romanianLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferences",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 8),

        Card(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.orange, width: 1),
          ),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              // Notification switch
              SwitchListTile(
                title: const Text("Turn off push notifications"),
                value: profileViewModel.profileUser!.notificationsEnabled,
                activeThumbColor: AppColors.orange,
                inactiveThumbColor: AppColors.lightBackground,
                onChanged: (val) async {
                  await profileViewModel.updateNotifications(val);
                },
              ),
              const Divider(height: 1, color: AppColors.orange),

              // Language switch
              SwitchListTile(
                title: const Text("Switch to Romanian"),
                value: romanianLanguage,
                activeThumbColor: AppColors.orange,
                inactiveThumbColor: AppColors.lightBackground,
                onChanged: onLanguageChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
