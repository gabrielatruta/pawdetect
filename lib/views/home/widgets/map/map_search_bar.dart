import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/home/map_viewmodel.dart';

class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final MapViewModel mapViewModel;

  final VoidCallback moveToVm;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.mapViewModel,
    required this.moveToVm,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      right: 10,
      top: 10,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onChanged: mapViewModel.onQueryChanged,
          onSubmitted: (q) async {
            FocusScope.of(context).unfocus();
            await mapViewModel.searchPlace(q);
            moveToVm();
          },
          decoration: InputDecoration(
            hintText: 'Search place',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: (controller.text.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      mapViewModel.onQueryChanged('');
                      mapViewModel.clearSuggestions();
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
