import 'package:flutter/material.dart';
import 'package:pawdetect/models/user_model.dart';
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

  String? _lastUid;
  void _sync(UserModel? u) {
    if (u == null) {
      if (_lastUid != null) {
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _lastUid = null;
      }
      return;
    }
    if (_lastUid == u.uid) return;
    _nameController.text = u.name;
    _phoneController.text = u.phone;
    _emailController.text = u.email;
    _lastUid = u.uid;
  }

  @override
  void initState() {
    super.initState();

    final profileViewModel = context.read<ProfileViewModel>();
    final user = profileViewModel.profileUser;

    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
    }
  }

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
    _sync(profileViewModel.profileUser);

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
      ],
    );
  }
}
