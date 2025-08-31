import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawdetect/viewmodels/all_reports_viewmodel.dart';
import 'package:pawdetect/views/guest/widgets/guest_profile_replacement.dart';
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

  bool _isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && !(user.isAnonymous);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _isLoggedIn();

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
              tooltip: isLoggedIn ? 'My profile' : 'Guest profile',
              onPressed: () async {
                final route = isLoggedIn
                    ? MaterialPageRoute(builder: (_) => ProfileScreen())
                    : MaterialPageRoute(
                        builder: (_) => const GuestProfileReplacement(),
                      );
                await Navigator.push(context, route);

                if (!context.mounted) return;
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

      // my reports icon visible only for logged-in users
      actions: showProfileIcon && isLoggedIn
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
