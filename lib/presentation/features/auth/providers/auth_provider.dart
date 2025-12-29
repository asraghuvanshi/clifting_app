import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';
import 'package:clifting_app/presentation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(AuthRepositoryImpl()),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl _authRepository;
  
  AuthNotifier(this._authRepository) : super(const AuthInitial());
  
  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final response = await _authRepository.login(
        LoginRequest(email: email, password: password),
      );
      state = AuthSuccess(response);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
  
  Future<void> signup(Map<String, dynamic> userData) async {
    state = const AuthLoading();
    try {
      await _authRepository.signup(userData);
      state = const SignupSuccess();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
  
  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthInitial();
  }
}