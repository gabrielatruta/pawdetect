import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/my_reports_viewmodel.dart';
import 'package:pawdetect/views/reports/my_reports_screen.dart';
import 'package:pawdetect/views/reports/widgets/shared/description_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/location_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_color_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_gender_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_type_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/photo_picker.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_type_field.dart';
import 'package:pawdetect/views/shared/custom_primary_button.dart';
import 'package:pawdetect/views/shared/custom_secondary_button.dart';
import 'package:pawdetect/views/shared/phone_field.dart';
import 'package:provider/provider.dart';

class MyReportDetailsForm extends StatefulWidget {
  const MyReportDetailsForm({super.key});

  @override
  State<StatefulWidget> createState() => _MyReportDetailsFormState();
}

class _MyReportDetailsFormState extends State<MyReportDetailsForm> {
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

  bool _hydrated = false;

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _phone1Ctrl.dispose();
    _phone2Ctrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = context.watch<MyReportsViewModel>();
    final r = vm.openedReport;
    if (!_hydrated && r != null) {
      _reportType = r.type;
      _animalType = r.animal;
      _gender = r.gender;
      _furColor = (r.colors.isNotEmpty) ? r.colors.first : null;

      _descriptionCtrl.text = r.additionalInfo;
      _phone1Ctrl.text = r.phoneNumber1;
      _phone2Ctrl.text = r.phoneNumber2;
      _locationCtrl.text = r.location;

      _hydrated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final myReportViewModel = context.watch<MyReportsViewModel>();
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

        Row(
          children: [
            // cancel button
            Expanded(
              child: SecondaryButton(
                text: "Cancel",
                onPressed: () {
                  if (myReportViewModel.isLoading)
                    return; // don't change styling, just ignore tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyReportsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // update report button
            Expanded(
              child: PrimaryButton(
                text: "Update report",
                onPressed: () {
                  if (myReportViewModel.isLoading) {
                    return; // ignore taps while saving
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
