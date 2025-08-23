import 'package:flutter/material.dart';
import 'package:pawdetect/views/home/widgets/report/reports_from_area.dart';
import 'package:pawdetect/views/shared/app_logo.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/home_viewmodel.dart';
import '../../../styles/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "", showProfileIcon: true),
      body: Column(
        children: [
          const SizedBox(height: 20),
          PrimaryButton(
            text: "Add new report",
            onPressed: () {
              Navigator.pushNamed(context,  "/add_report");
            },
          ),
        ],
      ),
    );
  }
}
