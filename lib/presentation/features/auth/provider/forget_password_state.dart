
import 'package:clifting_app/presentation/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';

class ForgetPasswordState {
  final bool isLoading;
  final ForgotPasswordResponse? data;
  final String? error;

  const ForgetPasswordState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  ForgetPasswordState copyWith({
    bool? isLoading,
    ForgotPasswordResponse? data,
    String? error,
  }) {
    return ForgetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}