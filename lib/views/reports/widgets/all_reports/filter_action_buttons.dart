import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';

class FilterActionButtons extends StatelessWidget {
  const FilterActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AllReportsViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: "Clear all",
                onPressed: () {
                  viewModel.clearFilters();
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                text: "Apply",
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
