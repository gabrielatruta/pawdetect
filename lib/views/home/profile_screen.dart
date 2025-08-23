import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/home/widgets/profile/profile_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';

import 'package:provider/provider.dart';
import '../../../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: CustomAppBar(title: "My profile"),

      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(children: [ProfileForm()]),
      ),
    );
  }
}
