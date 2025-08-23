import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawdetect/models/user_model.dart';
import 'package:pawdetect/services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  Future<User?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Create account in Firebase Auth
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        // Create user profile model
        final newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          phone: phone,
        );

        // Save in Firestore through UserService
        _userService.createUser(newUser);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Reset password failed");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user with the provided email address.";
      case 'wrong-password':
        return "The password is invalid. Please try again.";
      case 'invalid-credential':
        return "The email or password are invalid. Please check and try again.";
      case 'invalid-email':
        return "The email is not valid. Please check and try again.";
      case 'email-already-in-use':
        return "This email is already in use. Please use another.";
      case 'weak-password':
        return "Your password is too weak. Please choose a stronger one.";
      case 'network-request-failed':
        return "Network error. Please check your internet connection.";
      case 'operation-not-allowed':
        return "Sign up with email/password is not enabled. Enable it in Firebase Console.";
      default:
        return e.message ?? "Something went wrong. Please try again.";
    }
  }

  Stream<User?> get userChanges => _auth.authStateChanges();
}
