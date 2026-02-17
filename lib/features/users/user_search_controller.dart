// lib/features/users/controllers/user_search_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../auth/auth_controller.dart';
import 'user_search_repository.dart';

final userSearchRepositoryProvider = Provider<UserSearchRepository>((ref) {
  return UserSearchRepository(FirebaseFirestore.instance);
});

class UserSearchState {
  final List<AppUser> results;
  final bool isLoading;
  final String? error;
  final String query;

  const UserSearchState({
    required this.results,
    required this.isLoading,
    required this.query,
    this.error,
  });

  factory UserSearchState.initial() =>
      const UserSearchState(results: [], isLoading: false, query: '');

  UserSearchState copyWith({
    List<AppUser>? results,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return UserSearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      error: error,
    );
  }
}

class UserSearchController extends StateNotifier<UserSearchState> {
  UserSearchController(this._repo, this._authState)
      : super(UserSearchState.initial()) {
    search('');
  }

  final UserSearchRepository _repo;
  final AuthState _authState;

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, query: query, error: null);
    try {
      final uid = _authState.firebaseUser?.uid;
      final results = await _repo.searchUsers(query: query, excludeUid: uid);
      state = state.copyWith(results: results);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final userSearchControllerProvider =
    StateNotifierProvider<UserSearchController, UserSearchState>((ref) {
  final repo = ref.read(userSearchRepositoryProvider);
  final authState = ref.watch(authControllerProvider);
  return UserSearchController(repo, authState);
});