import 'package:flutter/material.dart';
import 'package:pawdetect/views/reports/add_new_report_screen.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
