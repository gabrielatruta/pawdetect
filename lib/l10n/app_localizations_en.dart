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
  String get phone => 'Phone';

  @override
  String get email => 'Email';

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
