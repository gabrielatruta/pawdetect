import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawdetect/models/report_model.dart' as report;
import 'package:pawdetect/viewmodels/report/my_reports_viewmodel.dart';
import 'package:pawdetect/views/reports/widgets/my_reports/buttons_edit_report.dart';
import 'package:pawdetect/views/reports/widgets/shared/description_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/location_field.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_color_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_gender_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/pet_type_dropdown.dart';
import 'package:pawdetect/views/reports/widgets/shared/photo_picker.dart';
import 'package:pawdetect/views/reports/widgets/shared/receive_notifications_card.dart';
import 'package:pawdetect/views/reports/widgets/shared/report_type_field.dart';
import 'package:pawdetect/views/shared/phone_field.dart';
import 'package:provider/provider.dart';

class MyReportEditForm extends StatefulWidget {
  const MyReportEditForm({super.key});

  @override
  State<StatefulWidget> createState() => _MyReportDetailsFormState();
}

class _MyReportDetailsFormState extends State<MyReportEditForm> {
  report.ReportType? _reportType;
  report.AnimalType? _animalType;
  report.Gender? _gender;
  report.FurColor? _furColor;

  final _descriptionCtrl = TextEditingController();
  final _phone1Ctrl = TextEditingController();
  final _phone2Ctrl = TextEditingController();

  // location
  final _locationCtrl = TextEditingController();
  // ignore: unused_field
  double? _lat, _lng;

  // photo
  // ignore: unused_field
  XFile? _photo;

  // push notifications
  bool _receiveFoundAlerts = false;
  final _alertAreaCtrl = TextEditingController();
  double? _alertLat, _alertLng;

  bool _hydrated = false;

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
      _lat = r.lat;
      _lng = r.lng;

      _receiveFoundAlerts = vm.openedReceiveFoundAlerts;
      _alertAreaCtrl.text = vm.openedAlertArea;
      _alertLat = vm.openedAlertLat;
      _alertLng = vm.openedAlertLng;

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
            setState(() {
              _lat = lat;
              _lng = lng;
              _locationCtrl.text = addr;
            });
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

        // push notifications preferences
        if (_reportType == report.ReportType.lost) ...[
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

        ButtonsEditReport(
          myReportViewModel: myReportViewModel,
          reportTypeValue: _reportType?.value,
          animalTypeValue: _animalType?.value,
          genderValue: _gender?.value,
          furColorValue: _furColor?.value,
          locationCtrl: _locationCtrl,
          descriptionCtrl: _descriptionCtrl,
          phone1Ctrl: _phone1Ctrl,
          phone2Ctrl: _phone2Ctrl,
          receiveFoundAlerts: _receiveFoundAlerts,
          alertAreaCtrl: _alertAreaCtrl,
          alertLat: _alertLat,
          alertLng: _alertLng,
          solvedStatusValue: report.ReportStatus.solved.value,
          lat: _lat,
          lng: _lng,
        ),
      ],
    );
  }
}
