// lib/features/auth/controllers/auth_controller.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

class AuthState {
  final bool isLoading;
  final User? firebaseUser;

  const AuthState({
    required this.isLoading,
    required this.firebaseUser,
  });

  bool get isLoggedIn => firebaseUser != null;

  AuthState copyWith({
    bool? isLoading,
    User? firebaseUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      firebaseUser: firebaseUser ?? this.firebaseUser,
    );
  }

  factory AuthState.initial() {
    return const AuthState(isLoading: false, firebaseUser: null);
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authRepository) : super(AuthState.initial()) {
    _sub = _authRepository.authStateChanges().listen((user) {
      state = state.copyWith(firebaseUser: user);
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _sub;

  Stream<User?> get authStateChanges => _authRepository.authStateChanges();

  Future<void> signUpWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signUpWithEmail(email: email, password: password);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signInWithGoogle();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});