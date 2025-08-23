import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/add_report_viewmodel.dart';
import '../../shared/error_message.dart';
import 'pet_type_dropdown.dart';
import 'description_field.dart';
import 'photo_picker.dart';
import 'location_picker.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddReportViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          PetTypeDropdown(onChanged: (val) => vm.petType = val),
          DescriptionField(controller: _description),
          PhotoPicker(onPhotoSelected: (url) => vm.photoUrl = url),
          LocationPicker(onLocationPicked: (loc) => vm.location = loc),
          const SizedBox(height: 16),

          if (vm.errorMessage != null)
            ErrorMessage(message: vm.errorMessage!),

          // vm.isLoading
          //     ? const LoadingIndicator()
          //     : CustomButton(
          //         text: "Submit Report",
          //         onPressed: () async {
          //           if (_formKey.currentState!.validate()) {
          //             vm.description = _description.text;
          //             await vm.submitReport();
          //             if (vm.errorMessage == null && mounted) {
          //               Navigator.pop(context); // go back after success
          //             }
          //           }
          //         },
          //       ),
        ],
      ),
    );
  }
}
