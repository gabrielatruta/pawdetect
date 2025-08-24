import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/models/user_model.dart';
import 'package:pawdetect/services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService;

  User? authUser;                 // FirebaseAuth user
  UserModel? profileUser;         // Firestore user document
  String? errorMessage;
  bool isLoading = false;

  StreamSubscription<User?>? _authSub;

  ProfileViewModel(this._userService) {
    // Keep profile in sync with login/logout + first app open
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
    // Also attempt an immediate load in case the user is already logged in
    _loadUser();
  }

  Future<void> _onAuthChanged(User? user) async {
    authUser = user;
    if (user == null) {
      _clear();
      return;
    }
    await _fetchOrCreateUser(user);
  }

  Future<void> _loadUser() async {
    final user = _auth.currentUser;
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
      // Try to get existing profile
      final existing = await _userService.getUser(user.uid);
      if (existing != null) {
        profileUser = existing;
      } else {
        // Create a minimal profile on first login so fields populate
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
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load profile.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _clear() {
    profileUser = null;
    errorMessage = null;
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
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to update profile.';
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
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to update preferences.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out and clear local UI state so the profile page is clean.
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