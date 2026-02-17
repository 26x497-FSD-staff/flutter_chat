// lib/features/profile/models/app_user.dart
class AppUser {
  final String id;
  final String email;
  final String? screenName;
  final List<String> hobbies; // งานอดิเรก
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.createdAt,
    this.screenName,
    this.hobbies = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      email: map['email'] as String,
      screenName: map['screenName'] as String?,
      hobbies: List<String>.from(map['hobbies'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as int?) ?? 0,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'screenName': screenName,
      'hobbies': hobbies,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}