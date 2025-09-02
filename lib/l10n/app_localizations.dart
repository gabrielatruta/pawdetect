import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
  ];

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @username_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username!'**
  String get username_empty;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phone_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number!'**
  String get phone_empty;

  /// No description provided for @phone_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get phone_invalid;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email!'**
  String get email_empty;

  /// No description provided for @email_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Email address is not valid!'**
  String get email_not_valid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password!'**
  String get password_empty;

  /// No description provided for @password_regex.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters, include \nan uppercase letter, number and symbol.'**
  String get password_regex;

  /// No description provided for @password_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get password_reset;

  /// No description provided for @password_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get password_confirm;

  /// No description provided for @password_no_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_no_match;

  /// No description provided for @login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get login_forgot_password;

  /// No description provided for @login_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get login_no_account;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please log in to continue.'**
  String get login_subtitle;

  /// No description provided for @signup_description.
  ///
  /// In en, this message translates to:
  /// **'Create your account to access all functionalities.'**
  String get signup_description;

  /// No description provided for @singup_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get singup_create_account;

  /// No description provided for @location_consent_question.
  ///
  /// In en, this message translates to:
  /// **'Allow location for this account?'**
  String get location_consent_question;

  /// No description provided for @location_consent_description.
  ///
  /// In en, this message translates to:
  /// **'We use your location only to center the home map near you.\n You can change this anytime in Settings.'**
  String get location_consent_description;

  /// No description provided for @location_consent_allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get location_consent_allow;

  /// No description provided for @location_consent_not_now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get location_consent_not_now;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profile_title;

  /// No description provided for @profile_update.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get profile_update;

  /// No description provided for @profile_unavailable.
  ///
  /// In en, this message translates to:
  /// **'No user profile available'**
  String get profile_unavailable;

  /// No description provided for @profile_updated_s.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_s;

  /// No description provided for @profile_account_info.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get profile_account_info;

  /// No description provided for @profile_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profile_preferences;

  /// No description provided for @profile_turn_notifications.
  ///
  /// In en, this message translates to:
  /// **'Turn off push notifications'**
  String get profile_turn_notifications;

  /// No description provided for @profile_switch_language.
  ///
  /// In en, this message translates to:
  /// **'Switch to Romanian'**
  String get profile_switch_language;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PawDetect!'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your real-time investigator searching for your lost pet!'**
  String get welcome_subtitle;

  /// No description provided for @welcome_continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue without an account'**
  String get welcome_continue_as_guest;

  /// No description provided for @map_search.
  ///
  /// In en, this message translates to:
  /// **'Search place'**
  String get map_search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filter_bottom_title.
  ///
  /// In en, this message translates to:
  /// **'Filter Reports'**
  String get filter_bottom_title;

  /// No description provided for @filter_animal_type.
  ///
  /// In en, this message translates to:
  /// **'Animal Type'**
  String get filter_animal_type;

  /// No description provided for @filter_animal_hint.
  ///
  /// In en, this message translates to:
  /// **'Select Animal'**
  String get filter_animal_hint;

  /// No description provided for @filter_report_type.
  ///
  /// In en, this message translates to:
  /// **'Report Type'**
  String get filter_report_type;

  /// No description provided for @filter_report_hint.
  ///
  /// In en, this message translates to:
  /// **'Lost or Found'**
  String get filter_report_hint;

  /// No description provided for @filter_clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get filter_clear_all;

  /// No description provided for @filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filter_apply;

  /// No description provided for @report_add_new.
  ///
  /// In en, this message translates to:
  /// **'Add new report'**
  String get report_add_new;

  /// No description provided for @report_in_area.
  ///
  /// In en, this message translates to:
  /// **'Reports in your chosen area(s)'**
  String get report_in_area;

  /// No description provided for @report_no_area_selected.
  ///
  /// In en, this message translates to:
  /// **'No alerts/areas selected yet.'**
  String get report_no_area_selected;

  /// No description provided for @report_in_area_empty.
  ///
  /// In en, this message translates to:
  /// **'No found reports in your selected area yet.'**
  String get report_in_area_empty;

  /// No description provided for @report_all_not_available.
  ///
  /// In en, this message translates to:
  /// **'No reports available'**
  String get report_all_not_available;

  /// No description provided for @report_all.
  ///
  /// In en, this message translates to:
  /// **'All reports'**
  String get report_all;

  /// No description provided for @report_no_id.
  ///
  /// In en, this message translates to:
  /// **'Missing report id'**
  String get report_no_id;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @report_create.
  ///
  /// In en, this message translates to:
  /// **'Create report'**
  String get report_create;

  /// No description provided for @report_not_found.
  ///
  /// In en, this message translates to:
  /// **'Report not found'**
  String get report_not_found;

  /// No description provided for @report_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get report_error_generic;

  /// No description provided for @report_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit report'**
  String get report_edit;

  /// No description provided for @report_edit_my.
  ///
  /// In en, this message translates to:
  /// **'Edit my report'**
  String get report_edit_my;

  /// No description provided for @report_no_personal.
  ///
  /// In en, this message translates to:
  /// **'No reports to display. Start reporting!'**
  String get report_no_personal;

  /// No description provided for @report_my_reports.
  ///
  /// In en, this message translates to:
  /// **'My reports'**
  String get report_my_reports;

  /// No description provided for @report_mark_as_solved.
  ///
  /// In en, this message translates to:
  /// **'Mark as solved'**
  String get report_mark_as_solved;

  /// No description provided for @report_update_report.
  ///
  /// In en, this message translates to:
  /// **'Update report'**
  String get report_update_report;

  /// No description provided for @report_solved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get report_solved;

  /// No description provided for @report_unsolved.
  ///
  /// In en, this message translates to:
  /// **'Unsolved'**
  String get report_unsolved;

  /// No description provided for @report_lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get report_lost;

  /// No description provided for @report_found.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get report_found;

  /// No description provided for @report_type.
  ///
  /// In en, this message translates to:
  /// **'Report type'**
  String get report_type;

  /// No description provided for @report_type_empty.
  ///
  /// In en, this message translates to:
  /// **'Please select a report type'**
  String get report_type_empty;

  /// No description provided for @report_not_filled.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get report_not_filled;

  /// No description provided for @report_guest_create.
  ///
  /// In en, this message translates to:
  /// **'Create found report'**
  String get report_guest_create;

  /// No description provided for @guest_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit as guest.'**
  String get guest_error;

  /// No description provided for @guest_create_report.
  ///
  /// In en, this message translates to:
  /// **'Report a found animal'**
  String get guest_create_report;

  /// No description provided for @guest_profile.
  ///
  /// In en, this message translates to:
  /// **'Guest profile'**
  String get guest_profile;

  /// No description provided for @guest_create_profile.
  ///
  /// In en, this message translates to:
  /// **'Create an account to unlock every feature'**
  String get guest_create_profile;

  /// No description provided for @guest_text.
  ///
  /// In en, this message translates to:
  /// **'Track your pets, customize your experience, and explore everything PawDetect has to offer!'**
  String get guest_text;

  /// No description provided for @guest_back_welcome.
  ///
  /// In en, this message translates to:
  /// **'Back to Welcome page'**
  String get guest_back_welcome;

  /// No description provided for @guest_switch_language.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get guest_switch_language;

  /// No description provided for @alerts_receive.
  ///
  /// In en, this message translates to:
  /// **'Receive found alerts'**
  String get alerts_receive;

  /// No description provided for @alerts_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a new \'Found\' report appears in a chosen area.'**
  String get alerts_subtitle;

  /// No description provided for @alerts_helper.
  ///
  /// In en, this message translates to:
  /// **'Tip: Choose how broad you want alerts to be:\n• Whole country (e.g., Romania)\n\'• City (e.g., Cluj-Napoca)\n\'• Neighbourhood (e.g., Mănăștur)'**
  String get alerts_helper;

  /// No description provided for @alerts_area.
  ///
  /// In en, this message translates to:
  /// **'Alert area'**
  String get alerts_area;

  /// No description provided for @alerts_empty_area.
  ///
  /// In en, this message translates to:
  /// **'Please choose an alert area before enabling notifications.'**
  String get alerts_empty_area;

  /// No description provided for @animal.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animal;

  /// No description provided for @animal_type_dog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get animal_type_dog;

  /// No description provided for @animal_type_cat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get animal_type_cat;

  /// No description provided for @animal_type_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get animal_type_other;

  /// No description provided for @animal_empty.
  ///
  /// In en, this message translates to:
  /// **'Please select an animal'**
  String get animal_empty;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @colors_empty.
  ///
  /// In en, this message translates to:
  /// **'Please select a color'**
  String get colors_empty;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @pick_photo.
  ///
  /// In en, this message translates to:
  /// **'Pick Photo'**
  String get pick_photo;

  /// No description provided for @pick_photo_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get pick_photo_gallery;

  /// No description provided for @pick_photo_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get pick_photo_camera;

  /// No description provided for @pick_photo_change.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get pick_photo_change;

  /// No description provided for @last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get last_updated;

  /// No description provided for @gender_male.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get gender_male;

  /// No description provided for @gender_female.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get gender_female;

  /// No description provided for @gender_unknown.
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get gender_unknown;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @gender_empty.
  ///
  /// In en, this message translates to:
  /// **'Please select a gender'**
  String get gender_empty;

  /// No description provided for @color_black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get color_black;

  /// No description provided for @color_white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get color_white;

  /// No description provided for @color_brown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get color_brown;

  /// No description provided for @color_gray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get color_gray;

  /// No description provided for @color_orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get color_orange;

  /// No description provided for @color_yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get color_yellow;

  /// No description provided for @color_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get color_red;

  /// No description provided for @color_tan.
  ///
  /// In en, this message translates to:
  /// **'Tan'**
  String get color_tan;

  /// No description provided for @color_beige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get color_beige;

  /// No description provided for @color_cream.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get color_cream;

  /// No description provided for @color_golden.
  ///
  /// In en, this message translates to:
  /// **'Golden'**
  String get color_golden;

  /// No description provided for @color_brindle.
  ///
  /// In en, this message translates to:
  /// **'Brindle'**
  String get color_brindle;

  /// No description provided for @color_mixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get color_mixed;

  /// No description provided for @color_spotted.
  ///
  /// In en, this message translates to:
  /// **'Spotted'**
  String get color_spotted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
