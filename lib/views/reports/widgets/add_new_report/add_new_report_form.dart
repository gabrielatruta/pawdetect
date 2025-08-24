import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/views/reports/widgets/add_new_report/location_field.dart';
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

  // used for location field
  final _locationCtrl = TextEditingController();
  double? _lat, _lng;

  //photo
  // photo
  XFile? _photo;

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _phone1Ctrl.dispose();
    _phone2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        PhoneField(controller: _phone1Ctrl),
        const SizedBox(height: 16),

        // phone number 2
        PhoneField(controller: _phone2Ctrl),
        const SizedBox(height: 16),

        // photo picker
        PhotoPicker(onChanged: (file) => setState(() => _photo = file)),
        const SizedBox(height: 16),

        // bottom buttons
        Row(
          children: [
            // cancel
            Expanded(
              child: SecondaryButton(
                text: "Cancel",
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
              ),
            ),
            const SizedBox(width: 12),

            // create report
            Expanded(
              child: PrimaryButton(
                text: "Create report",
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
              ),
            ),
            
          ],
        ),
      ],
    );
  }
}
