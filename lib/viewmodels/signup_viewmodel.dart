import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool isLoading = false;
  String? errorMessage;

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      errorMessage = null;
      notifyListeners();

      await _authService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      final user = await _authService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          phone: phone,
        );
        await _userService.createUser(newUser);
      }
    } catch (e) {
      errorMessage = e.toString();
       notifyListeners();
    } 
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
