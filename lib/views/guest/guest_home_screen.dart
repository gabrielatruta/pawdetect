import 'package:flutter/material.dart';
import 'package:pawdetect/views/guest/widgets/guest_bottom_buttons.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/viewmodels/home_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/all_reports_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import '../../../styles/app_colors.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>();

    return ChangeNotifierProvider(
      create: (_) => AllReportsViewModel()..fetchReports(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(title: "", showProfileIcon: true),
        bottomNavigationBar: const GuestBottomButtons(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [const SizedBox(height: 16), const AllReportsForm()],
          ),
        ),
      ),
    );
  }
}
