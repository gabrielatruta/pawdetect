import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/views/home/profile_screen.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:provider/provider.dart';
import '../../styles/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfileIcon; //display profile icon on homepage

  const CustomAppBar({
    super.key,
    required this.title,
    this.showProfileIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.orange,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      foregroundColor: AppColors.white,
      automaticallyImplyLeading: !showProfileIcon,

      // profile icon
      leading: showProfileIcon
          ? IconButton(
              icon: const Icon(Icons.person_outline),
              color: AppColors.white,
              tooltip: 'My profile',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
                
                if (!context.mounted) return;
                  // Safely try to reset pagination in all reports
                  try {
                    context.read<AllReportsViewModel>().resetPagination();
                  } catch (_) {}
              },
            )
          : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      elevation: 0,

      // my reports icon
      actions: showProfileIcon
          ? [
              IconButton(
                icon: const Icon(Icons.assignment_outlined),
                color: AppColors.white,
                tooltip: 'My reports',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyReportsScreen()),
                  );

                  if (!context.mounted) return;
                  // Safely try to reset pagination in all reports
                  try {
                    context.read<AllReportsViewModel>().resetPagination();
                  } catch (_) {}
                },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
