import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_action_buttons.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Filter Reports',
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
                label: 'Animal Type',
                hint: 'Select Animal',
                value: viewModel.selectedAnimal,
                items: const ["Dog", "Cat", "Other"],
                onChanged: viewModel.setAnimalFilter,
              );
            },
          ),
          const SizedBox(height: 20),

          // Status Filter
          Consumer<AllReportsViewModel>(
            builder: (context, viewModel, child) {
              return FilterDropdown(
                label: 'Report Type',
                hint: 'Lost or Found',
                value: viewModel.selectedStatus,
                items: const ["Lost", "Found"],
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
