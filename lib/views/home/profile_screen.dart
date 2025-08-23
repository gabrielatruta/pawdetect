import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/error_message.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/profile_viewmodel.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_list.dart';
import 'widgets/logout_button.dart';
import '../../../styles/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: vm.errorMessage != null
          ? ErrorMessage(message: vm.errorMessage!)
          : Column(
              children: [
                ProfileHeader(user: vm.user),
                const Expanded(child: SettingsList()),
                LogoutButton(onPressed: vm.logout),
              ],
            ),
    );
  }
}
