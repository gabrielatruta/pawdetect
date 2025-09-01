import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/viewmodels/localization_viewmodel.dart';
import 'package:pawdetect/views/shared/custom_input_field.dart';
import 'package:provider/provider.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLogin;
  const PasswordField({
    super.key,
    required this.controller,
    required this.isLogin,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // localized strings
    context.watch<LocalizationViewModel>(); // current language

    return CustomInputField(
      label: loc.password,
      controller: widget.controller,
      obscureText: _obscure,
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      validator: (v) {
        final value = v?.trim() ?? '';
        if (value.isEmpty) return loc.password_empty;
        final regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
        );
        if (!regex.hasMatch(value) && !widget.isLogin) {
          return loc.password_regex;
        }
        return null;
      },
    );
  }
}
