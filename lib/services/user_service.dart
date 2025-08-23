import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

 /// Create a new user document in Firestore
 Future<void> createUser(UserModel user) async {
    await users.doc(user.uid).set({
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'notificationsEnabled': user.notificationsEnabled,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Fetch a user by UID
  Future<UserModel?> getUser(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Update user data
   Future<void> updateUser(UserModel user) async {
    await users.doc(user.uid).update({
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'notificationsEnabled': user.notificationsEnabled,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
