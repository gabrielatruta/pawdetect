import 'package:flutter/material.dart';
import 'package:pawdetect/styles/app_colors.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(color: AppColors.errorRed),
    );
  }
}
