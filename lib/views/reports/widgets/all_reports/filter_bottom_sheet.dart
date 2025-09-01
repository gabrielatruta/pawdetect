import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_action_buttons.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/report/all_reports_viewmodel.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            loc.filter,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 24),

          // Animal Filter
          Consumer<AllReportsViewModel>(
            builder: (context, viewModel, child) {
              return FilterDropdown(
                label: loc.filter_animal_type,
                hint: loc.filter_animal_hint,
                value: viewModel.selectedAnimal,
                items: ["Dog", "Cat", "Other"],
                display: (code) {
                  switch (code) {
                    case 'Dog':
                      return loc.filter_dog;
                    case 'Cat':
                      return loc.filter_cat;
                    default:
                      return loc.filter_other;
                  }
                },
                onChanged: viewModel.setAnimalFilter,
              );
            },
          ),
          const SizedBox(height: 20),

          // Status Filter
          Consumer<AllReportsViewModel>(
            builder: (context, viewModel, child) {
              return FilterDropdown(
                label: loc.filter_report_type,
                hint: loc.filter_report_hint,
                value: viewModel.selectedStatus,
                items: const ["Lost", "Found"],
                display: (code) {
                  switch (code) {
                    case 'Lost':
                      return loc.filter_report_lost;
                    case 'Found':
                      return loc.filter_report_found;
                    default:
                      return code;
                  }
                },
                onChanged: viewModel.setStatusFilter,
              );
            },
          ),
          const SizedBox(height: 24),

          // Action buttons
          const FilterActionButtons(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
