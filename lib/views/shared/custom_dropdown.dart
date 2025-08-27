import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final FormFieldValidator<T>? validator;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.labelText,
    this.validator,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: isExpanded,
      style: const TextStyle(color: AppColors.black),
      iconEnabledColor: AppColors.black,
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: labelText,
            style: const TextStyle(color: AppColors.black),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ],
          ),
        ),
        labelStyle: const TextStyle(color: AppColors.black),
        filled: true,
        fillColor: AppColors.lightBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.black, width: 2),
        ),
      ),
    );
  }
}
