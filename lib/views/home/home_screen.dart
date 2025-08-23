import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/home/profile_screen.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/home_viewmodel.dart';
import '../../../styles/app_colors.dart';
import 'widgets/report_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    final screens = [
      ReportFeed(reports: homeViewModel.feedReports), // tab 0
      const MyReportsScreen(),             // tab 1
      const ProfileScreen(),               // tab 2
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "", showProfileIcon: true,),
      body: screens[homeViewModel.selectedIndex],
      
    );
  }
}
