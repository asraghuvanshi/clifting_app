import 'package:clifting_app/presentation/features/auth/data/model/change_password_response.dart';

class ChangePasswordState {
  final bool isLoading;
  final ChangePasswordResponse? data;
  final String? error;

  const ChangePasswordState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  ChangePasswordState copyWith({
    bool? isLoading,
    ChangePasswordResponse? data,
    String? error,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}