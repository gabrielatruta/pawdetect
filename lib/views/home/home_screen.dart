import 'package:flutter/material.dart';
import 'package:pawdetect/views/home/widgets/home/home_map.dart';
import 'package:pawdetect/views/reports/add_new_report_screen.dart';
import 'package:pawdetect/views/shared/custom_appbar.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/home_viewmodel.dart';
import '../../../styles/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final bool useLocation;
  const HomeScreen({super.key, bool? useLocation})
    : useLocation = useLocation ?? false;

  @override
  Widget build(BuildContext context) {
    context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "", showProfileIcon: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            HomeMapCard(useLocation: useLocation),
            const SizedBox(height: 16),
          ],
        ),
      ),

      // add new report button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: "Add new report",
            onPressed: () async {
              // Push the add-report page and WAIT for it to finish
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const AddNewReportScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
