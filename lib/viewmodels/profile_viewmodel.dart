import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/models/user_model.dart';
import 'package:pawdetect/services/user_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService;

  User? authUser; // FirebaseAuth user
  UserModel? profileUser; // Firestore user
  String? errorMessage;

  ProfileViewModel(this._userService) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      profileUser = await _userService.getUser(currentUser.uid);
    }
    notifyListeners();
  }

  Future<void> loadUserData(String uid) async {
    notifyListeners();

    try {
      profileUser = await _userService.getUser(uid);
    } catch (e) {
      errorMessage = "Failed to load profile.";
      notifyListeners();
    }
  }

  Future<void> updateProfile(String name, String phone, String email) async {
  if (profileUser == null) return;

  final updated = UserModel(
    uid: profileUser!.uid,
    name: name,
    phone: phone,
    email: email,
    notificationsEnabled: profileUser!.notificationsEnabled,
  );

  await _userService.updateUser(updated);
  profileUser = updated;
  notifyListeners();
}

  Future<void> updateNotifications(bool enabled) async {
    if (profileUser == null) return;

    final updated = UserModel(
      uid: profileUser!.uid,
      name: profileUser!.name,
      phone: profileUser!.phone,
      email: profileUser!.email,
      notificationsEnabled: enabled,
    );

    await _userService.updateUser(updated);
    profileUser = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
