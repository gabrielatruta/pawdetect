import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/guest/guest_home_screen.dart';
import 'package:pawdetect/views/reports/widgets/add_new_report/guest_add_new_report_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';

class GuestAddNewReportScreen extends StatelessWidget {
  const GuestAddNewReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent default pop so we can override it
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const GuestHomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(title: "Create found report"),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(child: GuestAddNewReportForm()),
          ),
        ),
      ),
    );
  }
}
