import 'package:flutter/material.dart';
import 'package:pawdetect/services/localization_service.dart';

class LocalizationViewModel extends ChangeNotifier {
  final LocalizationService _repo;
  Locale _locale = const Locale('en');

  LocalizationViewModel({LocalizationService? repo})
    : _repo = repo ?? LocalizationService();

  Locale get locale => _locale;
  bool get isRomanian => _locale.languageCode == 'ro';

  Future<void> load() async {
    final code = await _repo.load();
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    if (_locale.languageCode == code) return;
    _locale = Locale(code);
    await _repo.save(code);
    notifyListeners();
  }

  Future<void> toggleRomanian(bool enabled) => setLocale(enabled ? 'ro' : 'en');
}
