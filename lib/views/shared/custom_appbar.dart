import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/viewmodels/report/all_reports_viewmodel.dart';
import 'package:pawdetect/views/guest/guest_profile_screen.dart';
import 'package:pawdetect/views/home/profile_screen.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:provider/provider.dart';
import '../../styles/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfileIcon; //display profile icon on homepage
  final bool showGuestLanguageIcon; //display language icon on profile for guest

  const CustomAppBar({
    super.key,
    required this.title,
    this.showProfileIcon = false,
    this.showGuestLanguageIcon = false,
  });

  bool _isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && !(user.isAnonymous);
  }

  Widget _flag(String code) =>
      CountryFlag.fromCountryCode(code, width: 24, height: 16, borderRadius: 4);

  /// “EN” icon: GB + US
  Widget _enFlags() => SizedBox(
    width: 28,
    height: 18,
    child: Stack(
      children: [
        Positioned(left: 0, top: 3, child: _flag('gb')),
        Positioned(right: 0, bottom: 3, child: _flag('us')),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _isLoggedIn();
    final loc = AppLocalizations.of(context)!; // localized strings
    final localeVm = context.watch<LocalizationViewModel>();

    // Build actions list for right side icons
    final actions = <Widget>[];

    // My reports for logged-in users on home
    if (showProfileIcon && isLoggedIn) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.assignment_outlined),
          color: AppColors.white,
          tooltip: loc.report_my_reports,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyReportsScreen()),
            );
            if (!context.mounted) return;
            try {
              context.read<AllReportsViewModel>().resetPagination();
            } catch (_) {}
          },
        ),
      );
    }

    // language switch only for guest
    if (showGuestLanguageIcon && !isLoggedIn) {
      final isRO = localeVm.isRomanian;
      actions.add(
        IconButton(
          icon: isRO ? _enFlags() : _flag('ro'),
          color: AppColors.white,
          tooltip: loc.guest_switch_language,
          onPressed: () {
            final vm = context.read<LocalizationViewModel>();
            vm.setLocale(vm.isRomanian ? 'en' : 'ro');
          },
        ),
      );
    }

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
              tooltip: isLoggedIn ? loc.profile_title : loc.guest_profile,
              onPressed: () async {
                final route = isLoggedIn
                    ? MaterialPageRoute(builder: (_) => ProfileScreen())
                    : MaterialPageRoute(builder: (_) => const GuestProfileScreen());
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
      actions: actions.isEmpty ? null : actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
