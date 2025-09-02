import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/all_reports/filter_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/viewmodels/report/all_reports_viewmodel.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  int _getActiveFilterCount(AllReportsViewModel viewModel) {
    int count = 0;
    if (viewModel.selectedAnimal != null) count++;
    if (viewModel.selectedStatus != null) count++;
    return count;
  }

  void _showFilterBottomSheet(BuildContext context) {
    final viewModel = context.read<AllReportsViewModel>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => ChangeNotifierProvider.value(
        value: viewModel,
        child: const FilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AllReportsViewModel>();

    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return Container(
      decoration: BoxDecoration(
        color: AppColors.orange50,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.orange200, width: 1),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => _showFilterBottomSheet(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, color: AppColors.orange700, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.filter,
                  style: TextStyle(
                    color: AppColors.orange700,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                // Show active filter count if any filters are applied
                if (_getActiveFilterCount(viewModel) > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.orange600,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_getActiveFilterCount(viewModel)}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
