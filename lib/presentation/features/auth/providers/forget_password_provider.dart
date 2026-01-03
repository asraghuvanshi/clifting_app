// lib/presentation/features/auth/providers/forget_password_provider.dart

import 'package:clifting_app/presentation/features/auth/states/forget_password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clifting_app/presentation/features/auth/providers/auth_repository_provider.dart';
import 'package:clifting_app/presentation/features/auth/data/repository/auth_repository.dart';

final forgetPasswordProvider = StateNotifierProvider<ForgetPasswordNotifier, ForgetPasswordState>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return ForgetPasswordNotifier(authRepository);
  },
);

class ForgetPasswordNotifier extends StateNotifier<ForgetPasswordState> {
  final AuthRepository _authRepository;

  ForgetPasswordNotifier(this._authRepository) : super(const ForgetPasswordState());

  Future<void> forgetPassword(String email) async {
    try {
      // Start loading
      state = state.copyWith(isLoading: true, error: null, data: null);

      final response = await _authRepository.forgetPassword(email);

      if (response.success) {
        // Success
        state = state.copyWith(
          isLoading: false,
          data: response,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
          data: null,
        );
      }
    } catch (e) {
      // Handle error
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        data: null,
      );
      rethrow;
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  void clearData() {
    state = const ForgetPasswordState();
  }
}