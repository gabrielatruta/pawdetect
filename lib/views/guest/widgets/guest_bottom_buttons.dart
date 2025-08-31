import 'package:flutter/material.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';

class GuestBottomButtons extends StatelessWidget {
  const GuestBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: PrimaryButton(
          text: "Add new found report",
          onPressed: () async {
            // TODO: allow the user to only create found report
          },
        ),
      ),
    );
  }
}
