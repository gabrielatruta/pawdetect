import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  String? errorMessage;

  ProfileViewModel() {
    _loadUser();
  }

  void _loadUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      
      notifyListeners();
      await _auth.signOut();
    } catch (e) {
      errorMessage = "Failed to log out.";
      notifyListeners();
    }
  }
}
