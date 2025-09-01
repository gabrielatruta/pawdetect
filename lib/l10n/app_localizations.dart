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

  /// No description provided for @profile_switch_to_romanian.
  ///
  /// In en, this message translates to:
  /// **'Switch to Romanian'**
  String get profile_switch_to_romanian;

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
