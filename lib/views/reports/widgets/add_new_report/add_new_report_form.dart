import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/views/reports/widgets/add_new_report/receive_notifications_card.dart';
import 'package:provider/provider.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/add_report_viewmodel.dart';

import 'package:pawdetect/views/reports/widgets/shared/location_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/description_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_gender_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/photo_picker.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_type_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_type_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_color_dropdown.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:pawdetect/views/shared/phone_field.dart';

class AddNewReportForm extends StatefulWidget {
  const AddNewReportForm({super.key});

  @override
  State<AddNewReportForm> createState() => _AddNewReportFormState();
}

class _AddNewReportFormState extends State<AddNewReportForm> {
  report.ReportType? _reportType;
  report.AnimalType? _animalType;
  report.Gender? _gender;
  report.FurColor? _furColor;

  final _descriptionCtrl = TextEditingController();
  final _phone1Ctrl = TextEditingController();
  final _phone2Ctrl = TextEditingController();

  // location
  final _locationCtrl = TextEditingController();
  double? _lat, _lng;

  // photo
  XFile? _photo;

  // push notifications
  bool _receiveFoundAlerts = false;
  final _alertAreaCtrl = TextEditingController();
  double? _alertLat, _alertLng;

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _phone1Ctrl.dispose();
    _phone2Ctrl.dispose();
    _locationCtrl.dispose();
    _alertAreaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addReportViewModel = context.watch<AddReportViewModel>();
    final isPhone1Required = _reportType == report.ReportType.lost;

    return Column(
      children: [
        // report type
        ReportTypeField(
          value: _reportType,
          onChanged: (v) => setState(() => _reportType = v),
        ),
        const SizedBox(height: 16),

        // pet type
        PetTypeDropdown(
          value: _animalType,
          onChanged: (v) => setState(() => _animalType = v),
        ),
        const SizedBox(height: 16),

        // pet gender
        PetGenderDropdown(
          value: _gender,
          onChanged: (v) => setState(() => _gender = v),
        ),
        const SizedBox(height: 16),

        // pet color
        PetColorDropdown(
          value: _furColor,
          onChanged: (v) => setState(() => _furColor = v),
        ),
        const SizedBox(height: 16),

        // location
        LocationField(
          controller: _locationCtrl,
          country: 'ro',
          onSelected: (addr, lat, lng) {
            _lat = lat;
            _lng = lng;
          },
        ),
        const SizedBox(height: 16),

        // description input
        DescriptionField(controller: _descriptionCtrl),
        const SizedBox(height: 16),

        // phone number 1
        PhoneField(controller: _phone1Ctrl, isRequired: isPhone1Required),
        const SizedBox(height: 16),

        // phone number 2
        PhoneField(controller: _phone2Ctrl, isRequired: false),
        const SizedBox(height: 16),

        // photo picker
        PhotoPicker(onChanged: (file) => setState(() => _photo = file)),
        const SizedBox(height: 16),

        // receive alerts checkbox for lost reportws
        if (_reportType == report.ReportType.lost) ...[
          const SizedBox(height: 16),
          ReceiveNotifications(
            enabled: _receiveFoundAlerts,
            areaController: _alertAreaCtrl,
            onEnabledChanged: (v) => setState(() => _receiveFoundAlerts = v),
            onAreaSelected: (address, lat, lng) {
              setState(() {
                _alertAreaCtrl.text = address;
                _alertLat = lat;
                _alertLng = lng;
              });
            },
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 16),

        // bottom buttons
        Row(
          children: [
            // cancel
            Expanded(
              child: SecondaryButton(
                text: "Cancel",
                onPressed: () {
                  if (addReportViewModel.isLoading) return; // just ignore tap
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(width: 12),

            // create report
            Expanded(
              child: PrimaryButton(
                text: "Create report",
                onPressed: () async {
                  if (addReportViewModel.isLoading) {
                    return; // ignore taps while saving
                  }

                  final requiresPhone1 = _reportType == report.ReportType.lost;

                  // minimal validation
                  if (_reportType == null ||
                      _animalType == null ||
                      _gender == null ||
                      _furColor == null ||
                      _locationCtrl.text.trim().isEmpty ||
                      (requiresPhone1 && _phone1Ctrl.text.trim().isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields.'),
                      ),
                    );

                    return;
                  }

                  final ok = await addReportViewModel.submitReport(
                    reportType: _reportType!,
                    animalType: _animalType!,
                    gender: _gender!,
                    furColor: _furColor!,
                    description: _descriptionCtrl.text.trim(),
                    phone1: _phone1Ctrl.text.trim(),
                    phone2: _phone2Ctrl.text.trim(),
                    location: _locationCtrl.text.trim(),
                    lat: _lat,
                    lng: _lng,
                    photo: _photo,
                    receiveFoundAlerts: _receiveFoundAlerts,
                    alertArea: _receiveFoundAlerts
                        ? _alertAreaCtrl.text.trim()
                        : null,
                    alertLat: _receiveFoundAlerts ? _alertLat : null,
                    alertLng: _receiveFoundAlerts ? _alertLng : null,
                  );

                  if (ok && mounted) {
                    Navigator.pop(context);
                  } else if (!ok &&
                      mounted &&
                      addReportViewModel.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(addReportViewModel.errorMessage!)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
