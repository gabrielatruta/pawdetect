import 'package:flutter/material.dart';
import '../../../../styles/app_colors.dart';

class WelcomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const headerRadius = 28.0;
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.orange,
      foregroundColor: AppColors.white,
      centerTitle: true,
      toolbarHeight: 72,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(headerRadius),
        ),
      ),
      title: const Text(
        "Welcome",
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
