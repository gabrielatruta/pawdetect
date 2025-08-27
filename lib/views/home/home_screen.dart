import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/views/home/home_map.dart';
import 'package:pawdetect/views/home/widgets/home_bottom_navigation.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/all_reports_form.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../styles/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final bool useLocation;
  const HomeScreen({super.key, bool? useLocation})
    : useLocation = useLocation ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "", showProfileIcon: true),
      bottomNavigationBar: HomeBottomNavigation(),
      body: ChangeNotifierProvider(
        create: (_) => AllReportsViewModel()..fetchReports(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              HomeMapCard(useLocation: useLocation),
              const SizedBox(height: 16),
              const AllReportsForm(),
            ],
          ),
        ),
      ),
    );
  }
}
