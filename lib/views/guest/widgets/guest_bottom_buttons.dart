import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/views/reports/guest_add_new_report_screen.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';

class GuestBottomButtons extends StatelessWidget {
  const GuestBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: PrimaryButton(
          text: loc.guest_create_report,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GuestAddNewReportScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
