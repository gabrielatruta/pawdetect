// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get logout => 'Log out';

  @override
  String get login => 'Log In';

  @override
  String get signup => 'Sign Up';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get username => 'Username';

  @override
  String get username_empty => 'Please enter your username!';

  @override
  String get phone => 'Phone';

  @override
  String get phone_empty => 'Please enter your phone number!';

  @override
  String get phone_invalid => 'Enter a valid phone number';

  @override
  String get email => 'Email';

  @override
  String get email_empty => 'Please enter your email!';

  @override
  String get email_not_valid => 'Email address is not valid!';

  @override
  String get password => 'Password';

  @override
  String get password_empty => 'Please enter your password!';

  @override
  String get password_regex =>
      'Password must be at least 8 characters, include \nan uppercase letter, number and symbol.';

  @override
  String get password_reset => 'Reset password';

  @override
  String get password_confirm => 'Confirm Password';

  @override
  String get password_no_match => 'Passwords do not match';

  @override
  String get login_forgot_password => 'Forgot Password?';

  @override
  String get login_no_account => 'Don\'t have an account? ';

  @override
  String get login_subtitle => 'Welcome back! Please log in to continue.';

  @override
  String get signup_description =>
      'Create your account to access all functionalities.';

  @override
  String get singup_create_account => 'Create Account';

  @override
  String get location_consent_question => 'Allow location for this account?';

  @override
  String get location_consent_description =>
      'We use your location only to center the home map near you.\n You can change this anytime in Settings.';

  @override
  String get location_consent_allow => 'Allow';

  @override
  String get location_consent_not_now => 'Not now';

  @override
  String get profile_title => 'My profile';

  @override
  String get profile_update => 'Update Profile';

  @override
  String get profile_unavailable => 'No user profile available';

  @override
  String get profile_updated_s => 'Profile updated successfully';

  @override
  String get profile_account_info => 'Account Information';

  @override
  String get profile_preferences => 'Preferences';

  @override
  String get profile_turn_notifications => 'Turn off push notifications';

  @override
  String get profile_switch_to_romanian => 'Switch to Romanian';

  @override
  String get welcome_title => 'Welcome to PawDetect!';

  @override
  String get welcome_subtitle =>
      'Your real-time investigator searching for your lost pet!';

  @override
  String get welcome_continue_as_guest => 'Continue without an account';
}
