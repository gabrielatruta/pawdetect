import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/models/user_model.dart';
import 'package:pawdetect/services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService;

  User? authUser; // FirebaseAuth user
  UserModel? profileUser; // Firestore user document
  String? errorKey; // store language key here
  bool isLoading = false;

  StreamSubscription<User?>? _authSub;

  ProfileViewModel(this._userService) {
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
    _onAuthChanged(_auth.currentUser);
  }

  Future<void> _onAuthChanged(User? user) async {
    authUser = user;
    if (user == null) {
      _clear();
      return;
    }
    await _fetchOrCreateUser(user);
  }

  Future<void> _fetchOrCreateUser(User user) async {
    isLoading = true;
    notifyListeners();
    try {
      final existing = await _userService.getUser(user.uid);
      if (existing != null) {
        profileUser = existing;
      } else {
        final created = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          notificationsEnabled: false,
        );
        await _userService.createUser(created);
        profileUser = created;
      }
      errorKey = null;
    } catch (_) {
      errorKey = 'profile_unavailable';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _clear() {
    profileUser = null;
    errorKey = null;
    isLoading = false;
    notifyListeners();
  }

  /// Update name/phone/email; preserves other fields.
  Future<void> updateProfile(String name, String phone, String email) async {
    final current = profileUser;
    final uid = authUser?.uid;
    if (current == null || uid == null) return;

    final updated = UserModel(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      notificationsEnabled: current.notificationsEnabled,
    );

    try {
      isLoading = true;
      notifyListeners();
      await _userService.updateUser(updated);
      profileUser = updated;
      errorKey = null;
    } catch (_) {
      errorKey = 'profile_updated_f';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle notification preference only.
  Future<void> updateNotifications(bool enabled) async {
    final current = profileUser;
    final uid = authUser?.uid;
    if (current == null || uid == null) return;

    final updated = UserModel(
      uid: uid,
      name: current.name,
      email: current.email,
      phone: current.phone,
      notificationsEnabled: enabled,
    );

    try {
      isLoading = true;
      notifyListeners();
      await _userService.updateUser(updated);
      profileUser = updated;
      errorKey = null;
    } catch (_) {
      errorKey = 'alerts_fail';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } finally {
      _clear();
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
