import 'package:flutter/material.dart';
import '/styles/app_colors.dart';

class FilterOptions {
  //filter the reports based on the below options
  final bool lost, found, dog, cat, other;
  const FilterOptions({
    required this.lost,
    required this.found,
    required this.dog,
    required this.cat,
    required this.other,
  });

  FilterOptions copyWith({
    bool? lost, bool? found, bool? dog, bool? cat, bool? other,
  }) => FilterOptions(
    lost: lost ?? this.lost,
    found: found ?? this.found,
    dog: dog ?? this.dog,
    cat: cat ?? this.cat,
    other: other ?? this.other,
  );

  static const all = FilterOptions(lost: true, found: true, dog: true, cat: true, other: true);
}

Future<FilterOptions?> showFilterDialog(BuildContext context, FilterOptions initial) {
  bool l = initial.lost, f = initial.found, d = initial.dog, c = initial.cat, o = initial.other;

  return showDialog<FilterOptions>(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: StatefulBuilder(
        builder: (context, setLocal) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filters',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  )),
              const Divider(color: AppColors.border, height: 20),
              _check('Lost', l, (v) => setLocal(() => l = v)),
              _check('Found', f, (v) => setLocal(() => f = v)),
              _check('Dog', d, (v) => setLocal(() => d = v)),
              _check('Cat', c, (v) => setLocal(() => c = v)),
              _check('Other', o, (v) => setLocal(() => o = v)),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setLocal(() { l = f = d = c = o = true; }),
                    child: const Text('Reset', style: TextStyle(color: AppColors.lightGrey)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      FilterOptions(lost: l, found: f, dog: d, cat: c, other: o),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _check(String label, bool value, ValueChanged<bool> onChanged) {
  return CheckboxListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    value: value,
    onChanged: (v) => onChanged(v ?? false),
    activeColor: AppColors.orange,
    title: Text(label, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14)),
    controlAffinity: ListTileControlAffinity.leading,
  );
}