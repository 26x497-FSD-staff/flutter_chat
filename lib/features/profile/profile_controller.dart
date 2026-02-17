// lib/features/profile/controllers/profile_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_controller.dart';
import 'user_repository.dart';
import '../../models/app_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(FirebaseFirestore.instance);
});

class ProfileState {
  final AppUser? user;
  final bool isLoading;
  final String? error;

  const ProfileState({
    required this.user,
    required this.isLoading,
    this.error,
  });

  factory ProfileState.initial() =>
      const ProfileState(user: null, isLoading: false);

  ProfileState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._userRepo, this._authState) : super(ProfileState.initial()) {
    _init();
  }

  final UserRepository _userRepo;
  final AuthState _authState;
  Stream<AppUser?>? _userStream;
  ProviderSubscription<AppUser?>? _userSub;

  Future<void> _init() async {
    final firebaseUser = _authState.firebaseUser;
    if (firebaseUser == null) return;

    // สร้าง document ผู้ใช้ถ้ายังไม่มี
    await _userRepo.createUserIfNotExists(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    );

    // subscribe userdoc
    _userStream = _userRepo.watchUser(firebaseUser.uid);
    _userStream!.listen((user) {
      state = state.copyWith(user: user);
    });
  }

  Future<void> updateProfile({
    required String screenName,
    required List<String> hobbies,
  }) async {
    final firebaseUser = _authState.firebaseUser;
    if (firebaseUser == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _userRepo.updateProfile(
        uid: firebaseUser.uid,
        screenName: screenName,
        hobbies: hobbies,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  final authState = ref.watch(authControllerProvider);
  return ProfileController(userRepo, authState);
});