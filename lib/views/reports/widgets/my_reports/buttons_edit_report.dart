import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/navigation.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class ButtonsEditReport extends StatelessWidget {
  const ButtonsEditReport({
    super.key,
    required this.myReportViewModel,
    required this.reportTypeValue,
    required this.animalTypeValue,
    required this.genderValue,
    required this.furColorValue,
    required this.locationCtrl,
    required this.descriptionCtrl,
    required this.phone1Ctrl,
    required this.phone2Ctrl,
    required this.receiveFoundAlerts,
    required this.alertAreaCtrl,
    required this.alertLat,
    required this.alertLng,
    required this.solvedStatusValue,
    this.lat,
    this.lng,
    this.newPhoto,  
  });

  final dynamic myReportViewModel;

  final String? reportTypeValue;
  final String? animalTypeValue;
  final String? genderValue;
  final String? furColorValue;

  final TextEditingController locationCtrl;
  final TextEditingController descriptionCtrl;
  final TextEditingController phone1Ctrl;
  final TextEditingController phone2Ctrl;

  final bool receiveFoundAlerts;
  final TextEditingController alertAreaCtrl;
  final double? alertLat;
  final double? alertLng;

  final String solvedStatusValue;
  final double? lat;
  final double? lng;

  final XFile? newPhoto;           

  String _normalizeArea(String? s) {
    if (s == null) return '';
    final lower = s.toLowerCase();
    const map = {
      'ă': 'a',
      'â': 'a',
      'î': 'i',
      'ș': 's',
      'ş': 's',
      'ț': 't',
      'ţ': 't',
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'ã': 'a',
      'å': 'a',
      'é': 'e',
      'è': 'e',
      'ë': 'e',
      'ê': 'e',
      'í': 'i',
      'ì': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ö': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ü': 'u',
    };
    final buf = StringBuffer();
    for (final r in lower.runes) {
      final ch = String.fromCharCode(r);
      buf.write(map[ch] ?? ch);
    }
    return buf
        .toString()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings

    return Row(
      children: [
        // Mark as solved
        Expanded(
          child: SecondaryButton(
            text: loc.report_mark_as_solved,
            onPressed: () async {
              if (myReportViewModel.isLoading == true) return;

              await myReportViewModel.updateOpenedReport({
                'status': solvedStatusValue,
                // also turn off alerts for this report
                'foundAlertSubscription.enabled': false,
              });

              appNavigatorKey.currentState?.pop('/myreports');
            },
          ),
        ),
        const SizedBox(width: 12),

        // Update report
        Expanded(
          child: PrimaryButton(
            text: loc.report_update_report,
            onPressed: () async {
              if (myReportViewModel.isLoading == true) return;

              // Use effective (current) type if the user didn't change it.
              final currentType =
                  (reportTypeValue ?? myReportViewModel.openedReport?.type)
                      ?.toString()
                      .toLowerCase();
              final isLost = currentType == 'lost';

              // Require an area (and coords) if enabling alerts on a lost report.
              if (isLost && receiveFoundAlerts) {
                final area = alertAreaCtrl.text.trim();
                if (area.isEmpty || alertLat == null || alertLng == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.alerts_empty_area)),
                  );
                  return; // prevent save
                }
              }

              final partial =
                  <String, dynamic>{
                    if (reportTypeValue != null) 'type': reportTypeValue,
                    if (animalTypeValue != null) 'animal': animalTypeValue,
                    if (genderValue != null) 'gender': genderValue,
                    if (furColorValue != null) 'colors': [furColorValue],
                    'location': locationCtrl.text,
                    'additionalInfo': descriptionCtrl.text,
                    'phoneNumber1': phone1Ctrl.text,
                    'phoneNumber2': phone2Ctrl.text,
                  }..removeWhere(
                    (k, v) => v == null || (v is String && v.trim().isEmpty),
                  );
              // write new coordinates when the user picked a suggestion
              if (lat != null) partial['lat'] = lat;
              if (lng != null) partial['lng'] = lng;

              // if the user edited the address text but didn't pick a suggestion
              // clear stale coords so the pin disappears
              if (locationCtrl.text.trim().isEmpty) {
                partial['lat'] = fs.FieldValue.delete();
                partial['lng'] = fs.FieldValue.delete();
              }

              if (isLost) {
                partial['foundAlertSubscription.enabled'] = receiveFoundAlerts;

                if (receiveFoundAlerts) {
                  final areaText = alertAreaCtrl.text.trim();
                  partial.addAll({
                    'foundAlertSubscription.area': areaText,
                    'foundAlertSubscription.areaKey': _normalizeArea(areaText),
                    'foundAlertSubscription.lat': alertLat,
                    'foundAlertSubscription.lng': alertLng,
                  });
                } else {
                  partial.addAll({
                    'foundAlertSubscription.enabled': false,
                    'foundAlertSubscription.area': fs.FieldValue.delete(),
                    'foundAlertSubscription.areaKey': fs.FieldValue.delete(),
                    'foundAlertSubscription.lat': fs.FieldValue.delete(),
                    'foundAlertSubscription.lng': fs.FieldValue.delete(),
                  });
                }
              }

              await myReportViewModel.updateOpenedReport(partial, newPhoto: newPhoto);
              appNavigatorKey.currentState?.pop('/myreports');
            },
          ),
        ),
      ],
    );
  }
}
