import 'package:clifting_app/core/providers/auth_repository_provider.dart';
import 'package:clifting_app/presentation/features/auth/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clifting_app/core/router/app_navigator.dart';
import 'package:clifting_app/presentation/features/auth/data/auth_repository.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return AuthNotifier(authRepository);
  },
);

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> login(String email, String password) async {
    try {
      // Start loading
      state = state.copyWith(isLoading: true, error: null);

      // Call repository
      final response = await _authRepository.login(email, password);

      if (response.success ?? false) {
        state = state.copyWith(
          isLoading: false,
          user: response,
          isAuthenticated: true,
          error: null,
        );

        AppNavigator.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
          isAuthenticated: false,
        );
      }
    } catch (e) {
      // Handle error
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authRepository.logout();
      
      state = const AuthState(isAuthenticated: false);
      
      // Navigate to login screen
      AppNavigator.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      
      state = state.copyWith(
        isAuthenticated: isLoggedIn,
      );
      
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}