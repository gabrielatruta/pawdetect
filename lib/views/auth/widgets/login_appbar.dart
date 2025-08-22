import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.orange,
      title: const Text(
        "Log In",
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      foregroundColor: AppColors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
