import 'package:flutter/material.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Mark as solved
        Expanded(
          child: SecondaryButton(
            text: "Mark as solved",
            onPressed: () async {
              if (myReportViewModel.isLoading == true) return;

              await myReportViewModel.updateOpenedReport({
                'status': solvedStatusValue,
                // also turn off alerts for this report
                'foundAlertSubscription.enabled': false,
              });

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully marked as solved!')),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyReportsScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),

        // Update report
        Expanded(
          child: PrimaryButton(
            text: "Update report",
            onPressed: () async {
              if (myReportViewModel.isLoading == true) return;

              final partial = <String, dynamic>{
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

              if (reportTypeValue == 'lost') {
                partial['foundAlertSubscription'] = {
                  'enabled': receiveFoundAlerts,
                  'area': receiveFoundAlerts ? alertAreaCtrl.text.trim() : '',
                  'lat': receiveFoundAlerts ? alertLat : null,
                  'lng': receiveFoundAlerts ? alertLng : null,
                };
              } else {
                partial['foundAlertSubscription'] = {'enabled': false};
              }

              await myReportViewModel.updateOpenedReport(partial);

              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyReportsScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
