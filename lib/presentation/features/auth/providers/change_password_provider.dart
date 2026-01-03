import 'package:clifting_app/presentation/features/auth/states/change_password_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clifting_app/presentation/features/auth/providers/auth_repository_provider.dart';
import 'package:clifting_app/presentation/features/auth/data/repository/auth_repository.dart';

final changePasswordProvider = StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return ChangePasswordNotifier(authRepository);
  },
);

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordNotifier(this._authRepository) : super(const ChangePasswordState());

  Future<void> changePassword(String token, String newPassword) async {
    try {
      // Start loading
      state = state.copyWith(isLoading: true, error: null, data: null);

      final response = await _authRepository.resetPassword(token, newPassword);

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
    state = const ChangePasswordState();
  }
}