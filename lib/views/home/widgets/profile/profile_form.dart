import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/profile_viewmodel.dart';
import 'package:pawdetect/views/home/widgets/profile/profile_information.dart';
import 'package:pawdetect/views/home/widgets/profile/profile_preferences.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:provider/provider.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _romanianLanguage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final user = profileViewModel.profileUser;

    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
    }

    if (user == null) {
      return const Center(child: Text("No user profile available"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Account Information section
        ProfileInformation(
          nameController: _nameController,
          phoneController: _phoneController,
          emailController: _emailController,
        ),

        const SizedBox(height: 32),

        // Preferences section
        PreferencesForm(
          romanianLanguage: _romanianLanguage,
          onLanguageChanged: (val) {
            setState(() => _romanianLanguage = val);
          },
        ),

        const SizedBox(height: 40),

        // Update profile
        SecondaryButton(
          text: "Update profile",
          onPressed: () async {
            await profileViewModel.updateProfile(
              _nameController.text,
              _phoneController.text,
              _emailController.text,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated successfully")),
              );
            }
          },
        ),
        const SizedBox(height: 16),

        // Log out
        PrimaryButton(
          text: "Log Out",
          onPressed: () async {
            await profileViewModel.logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, "/welcome");
            }
          },
        ),
      ],
    );
  }
}
