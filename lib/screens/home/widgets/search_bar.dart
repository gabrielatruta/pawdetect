import 'package:flutter/material.dart';
import '/styles/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onTapSearch, this.onTapMyLocation});
  final VoidCallback? onTapSearch;
  final VoidCallback? onTapMyLocation;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTapSearch,
      decoration: InputDecoration(
        hintText: 'Search location',
        hintStyle: const TextStyle(color: AppColors.lightGrey),
        prefixIcon: const Icon(Icons.search, color: AppColors.lightGrey),
        suffixIcon: IconButton(
          onPressed: onTapMyLocation,
          icon: const Icon(Icons.my_location, color: AppColors.lightGrey),
          tooltip: 'Use my location',
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: AppColors.orange, width: 1.6),
        ),
      ),
    );
  }
}