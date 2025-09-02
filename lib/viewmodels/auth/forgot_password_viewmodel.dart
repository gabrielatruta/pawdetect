import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/l10n/app_localizations.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? errorMessage;

  Future<void> sendResetEmail(BuildContext context, String email) async {
    final loc = AppLocalizations.of(context)!; // localized strings

    if (email.isEmpty) {
      errorMessage = loc.email_empty;
      notifyListeners();
      return;
    }

    errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = loc.login_no_user_found;
        notifyListeners();
      } else {
        errorMessage = loc.login_invalid_email;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = loc.default_error;
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    notifyListeners();
  }
}
