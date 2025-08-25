import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class LocationConsent {
  static String _promptedKey(String userId) => 'loc_prompted_$userId';
  static String _acceptedKey(String userId) => 'loc_accepted_$userId';

  /// Returns true if this account *accepted* AND OS permission/services are available.
  static Future<bool> ensureForUser({
    required String userId,
    Future<bool> Function()? inAppPrompt,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    bool prompted = prefs.getBool(_promptedKey(userId)) ?? false;
    bool accepted = prefs.getBool(_acceptedKey(userId)) ?? false;

    // Ask only if this account was never prompted
    if (!prompted) {
      accepted = await (inAppPrompt?.call() ?? false);
      await prefs.setBool(_promptedKey(userId), true);
      await prefs.setBool(_acceptedKey(userId), accepted);
    }

    // Respect the account's choice EVERY time.
    if (!accepted) return false;

    // Now ensure OS permission/services (app-level).
    try {
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        status = await Geolocator.requestPermission();
      }

      final servicesOn = await Geolocator.isLocationServiceEnabled();
      final granted = servicesOn &&
          (status == LocationPermission.always ||
           status == LocationPermission.whileInUse);

      if (!granted && status == LocationPermission.deniedForever) {
        // Optional: you may want to open settings only when user taps a button.
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
      }
      return granted;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isAcceptedForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_acceptedKey(userId)) ?? false;
  }

  // Handy for testing:
  static Future<void> resetForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_promptedKey(userId));
    await prefs.remove(_acceptedKey(userId));
  }
}
