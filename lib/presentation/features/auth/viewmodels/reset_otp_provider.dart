import 'package:clifting_app/presentation/features/auth/states/verify_reset_otp_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clifting_app/core/providers/auth_repository_provider.dart';
import 'package:clifting_app/presentation/features/auth/data/auth_repository.dart';

final verifyResetOtpProvider = StateNotifierProvider<VerifyResetOtpNotifier, VerifyResetOtpState>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return VerifyResetOtpNotifier(authRepository);
  },
);

class VerifyResetOtpNotifier extends StateNotifier<VerifyResetOtpState> {
  final AuthRepository _authRepository;

  VerifyResetOtpNotifier(this._authRepository) : super(const VerifyResetOtpState());

  Future<void> verifyResetOtp(String email, String otp) async {
    try {
      // Start loading
      state = state.copyWith(isLoading: true, error: null, data: null);

      final response = await _authRepository.resetPasswordWithOTP(email , otp);

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
    state = const VerifyResetOtpState();
  }
}