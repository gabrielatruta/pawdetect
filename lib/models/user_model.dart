class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool notificationsEnabled;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.notificationsEnabled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      notificationsEnabled: (data['notificationsEnabled'] as bool?) ?? false,
    );
  }

   factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      uid: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      notificationsEnabled: (data['notificationsEnabled'] as bool?) ?? false,
    );
  }
}
