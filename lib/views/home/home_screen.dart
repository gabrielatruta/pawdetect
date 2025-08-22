import 'package:flutter/material.dart';
import 'package:pawdetect/views/home/profile_screen.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/home_viewmodel.dart';
import '../../../styles/app_colors.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_navbar.dart';
import 'widgets/report_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    final screens = [
      ReportFeed(reports: vm.feedReports), // tab 0
      const MyReportsScreen(),             // tab 1
      const ProfileScreen(),               // tab 2
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const HomeAppBar(),
      body: screens[vm.selectedIndex],
      bottomNavigationBar: HomeNavBar(
        selectedIndex: vm.selectedIndex,
        onTabSelected: vm.changeTab,
      ),
    );
  }
}
