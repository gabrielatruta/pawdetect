import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';
import 'package:pawdetect/viewmodels/home/map_viewmodel.dart';

class MapSuggestions extends StatelessWidget {
  final MapViewModel mapViewModel;
  final TextEditingController controller;
  final VoidCallback moveToVm;

  const MapSuggestions({
    super.key,
    required this.mapViewModel,
    required this.controller,
    required this.moveToVm,
  });

  @override
  Widget build(BuildContext context) {
    if (mapViewModel.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 10,
      right: 10,
      top: 62, // just below the search field
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 160),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: mapViewModel.suggestions.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.blackAlpha06),
            itemBuilder: (context, i) {
              final s = mapViewModel.suggestions[i];
              return ListTile(
                dense: true,
                title: Text(
                  s.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: s.subtitle.isEmpty
                    ? null
                    : Text(
                        s.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                onTap: () async {
                  controller.text = s.title;
                  FocusScope.of(context).unfocus();
                  await mapViewModel.applySuggestion(s);
                  moveToVm();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
