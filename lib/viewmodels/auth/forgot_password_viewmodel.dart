import 'package:flutter/material.dart';
import 'package:pawdetect/l10n/app_localizations.dart';
import 'package:pawdetect/services/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? errorMessage;

  Future<void> sendResetEmail(BuildContext context, String email) async {
    final loc = AppLocalizations.of(context)!;
    if (email.trim().isEmpty) {
      errorMessage = loc.email_empty;
      notifyListeners();
      return;
    }
    errorMessage = null;
    notifyListeners();
    try {
      await _authService.resetPassword(context, email.trim());
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    notifyListeners();
  }
}
