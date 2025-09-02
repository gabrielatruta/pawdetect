import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool notificationsEnabled;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.notificationsEnabled = false,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    bool? notificationsEnabled,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      uid: id,
      name: (data['name'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      notificationsEnabled: (data['notificationsEnabled'] as bool?) ?? false,
    );
  }

  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) =>
      UserModel.fromMap(id, data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.notificationsEnabled == notificationsEnabled;
  }

  @override
  int get hashCode =>
      Object.hash(uid, name, email, phone, notificationsEnabled);
}
