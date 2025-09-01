import 'package:pawdetect/l10n/app_localizations.dart';

typedef L = AppLocalizations;

/// Centralized helpers to map canonical/English values & labels → localized UI text
class LocMaps {
  // -------- Header parts --------
  static String type(String? v, L l) {
    switch ((v ?? '').toLowerCase().trim()) {
      case 'lost':
        return l.report_lost;
      case 'found':
        return l.report_found;
      default:
        return v ?? '';
    }
  }

  static String animal(String? v, L l) {
    switch ((v ?? '').toLowerCase().trim()) {
      case 'dog':
        return l.animal_type_dog;
      case 'cat':
        return l.animal_type_cat;
      case 'other':
        return l.animal_type_other;
      default:
        return v ?? '';
    }
  }

  static String status(String? v, L l) {
    switch ((v ?? '').toLowerCase().trim()) {
      case 'solved':
        return l.report_solved;
      case 'unsolved':
        return l.report_unsolved;
      default:
        return v ?? '';
    }
  }

  // -------- Detail labels (left column) --------
  static String detailLabel(String key, L l) {
    switch (key.toLowerCase().trim()) {
      case 'location':
        return l.location;
      case 'gender':
        return l.gender;
      case 'colors':
        return l.colors;
      case 'additional info':
        return l.description;
      case 'phone 1':
        return l.phone;
      case 'phone 2':
        return l.phone;
      case 'last updated':
        return l.last_updated;
      default:
        return key;
    }
  }

  // -------- Detail values --------
  static String detailValue(String originalLabelEn, String value, L l) {
    switch (originalLabelEn.toLowerCase().trim()) {
      case 'gender':
        return gender(value, l);
      case 'colors':
        return colorsCsv(value, l);
      default:
        return value; // free text (location, phones, notes, date)
    }
  }

  static String gender(String v, L l) {
    final s = v.trim();
    switch (s.toUpperCase()) {
      case 'M':
      case 'MALE':
        return l.gender_male;
      case 'F':
      case 'FEMALE':
        return l.gender_female;
      case '?':
      case 'U':
      case 'UNKNOWN':
        return l.gender_unknown;
      default:
        return v;
    }
  }

  static String colorsCsv(String v, L l) {
    final parts = v.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    return parts.map((c) => color(c, l)).join(', ');
  }

  static String color(String v, L l) {
    switch (v.toLowerCase().trim()) {
      case 'black':
        return l.color_black;
      case 'white':
        return l.color_white;
      case 'brown':
        return l.color_brown;
      case 'gray':
      case 'grey':
        return l.color_gray;
      case 'orange':
        return l.color_orange;
      case 'yellow':
        return l.color_yellow;
      case 'red':
        return l.color_red;
      case 'tan':
        return l.color_tan;
      case 'beige':
        return l.color_beige;
      case 'cream':
        return l.color_cream;
      case 'golden':
        return l.color_golden;
      case 'brindle':
        return l.color_brindle;
      case 'mixed':
      case 'multicolor':
      case 'multi':
        return l.color_mixed;
      default:
        return v;
    }
  }
}
