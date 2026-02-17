// lib/features/profile/data/user_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference get _usersRef => _firestore.collection('users');

  Future<void> createUserIfNotExists({
    required String uid,
    required String email,
  }) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) {
      final user = AppUser(
        id: uid,
        email: email,
        createdAt: DateTime.now(),
      );
      await _usersRef.doc(uid).set(user.toMap());
    }
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<void> updateProfile({
    required String uid,
    required String screenName,
    required List<String> hobbies,
  }) async {
    await _usersRef.doc(uid).update({
      'screenName': screenName,
      'hobbies': hobbies,
    });
  }

  Stream<AppUser?> watchUser(String uid) {
    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  // สำหรับ search ผู้ใช้
  Future<List<AppUser>> searchUsersByName(String query) async {
    if (query.isEmpty) {
      final snap = await _usersRef
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();
      return snap.docs
          .map((d) => AppUser.fromMap(d.data() as Map<String, dynamic>, d.id))
          .toList();
    }

    final snap = await _usersRef
        .where('screenName', isGreaterThanOrEqualTo: query)
        .where('screenName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return snap.docs
        .map((d) => AppUser.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }
}