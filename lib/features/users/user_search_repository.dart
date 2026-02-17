// lib/features/users/data/user_search_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';

class UserSearchRepository {
  UserSearchRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference get _usersRef => _firestore.collection('users');

  Future<List<AppUser>> searchUsers({required String query, String? excludeUid}) async {
    Query q = _usersRef;

    if (query.isNotEmpty) {
      q = q
          .where('screenName', isGreaterThanOrEqualTo: query)
          .where('screenName', isLessThanOrEqualTo: '$query\uf8ff');
    } else {
      q = q.orderBy('createdAt', descending: true).limit(30);
    }

    final snap = await q.get();
    final all = snap.docs
        .map((d) => AppUser.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();

    if (excludeUid != null) {
      return all.where((u) => u.id != excludeUid).toList();
    }
    return all;
  }
}