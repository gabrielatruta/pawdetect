// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get logout => 'Deconectare';

  @override
  String get login => 'Conectare';

  @override
  String get signup => 'Înregistrare';

  @override
  String get save => 'Salvează';

  @override
  String get cancel => 'Anulează';

  @override
  String get username => 'Nume utilizator';

  @override
  String get phone => 'Număr telefon';

  @override
  String get email => 'Email';

  @override
  String get email_empty => 'Te rog introdu adresa de email!';

  @override
  String get email_not_valid => 'Adresa de email invalidă!';

  @override
  String get password => 'Parolă';

  @override
  String get password_empty => 'Te rog introdu parola!';

  @override
  String get password_regex =>
      'Parola trebuie să aibă minim 8 caractere, să includă \no majusculă, un număr și un simbol.';

  @override
  String get password_reset => 'Resetează parola';

  @override
  String get login_forgot_password => 'Ai uitat parola?';

  @override
  String get login_no_account => 'Nu ai cont? ';

  @override
  String get login_subtitle => 'Bine ai revenit! Conectează-te ca să continui.';

  @override
  String get location_consent_question =>
      'Permiteți accesul la locație pentru acest cont?';

  @override
  String get location_consent_description =>
      'Folosim locația ta doar pentru a centra mapa în jurul tău.\n Poți schimba ulterior această preferință în setări.';

  @override
  String get location_consent_allow => 'Permite';

  @override
  String get location_consent_not_now => 'Nu acum';

  @override
  String get profile_title => 'Profilul meu';

  @override
  String get profile_update => 'Actualizează profilul';

  @override
  String get profile_unavailable => 'Niciun profil disponibil';

  @override
  String get profile_updated_s => 'Profil actualizat cu succes';

  @override
  String get profile_account_info => 'Informații cont';

  @override
  String get profile_preferences => 'Preferințe';

  @override
  String get profile_turn_notifications => 'Dezactivează notificările';

  @override
  String get profile_switch_to_romanian => 'Schimbă pe română';

  @override
  String get welcome_title => 'Bunvenit pe PawDetect!';

  @override
  String get welcome_subtitle =>
      'Detectivul tău în timp real, pe urmele animalului de companie dispărut!';

  @override
  String get welcome_continue_as_guest => 'Continuă fără cont';
}
