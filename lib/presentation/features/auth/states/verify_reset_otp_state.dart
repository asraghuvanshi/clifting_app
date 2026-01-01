import 'package:clifting_app/presentation/features/auth/data/model/verify_reset_password_otp.dart';

class VerifyResetOtpState {
  final bool isLoading;
  final VerifyResetOtpResponse? data;
  final String? error;

  const VerifyResetOtpState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  VerifyResetOtpState copyWith({
    bool? isLoading,
    VerifyResetOtpResponse? data,
    String? error,
  }) {
    return VerifyResetOtpState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}