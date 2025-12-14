// features/auth/presentation/notifier/auth_notifier.dart
import 'dart:io';
import 'package:clifting_app/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/features/auth/data/repositories/auth_repositories.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {
  AuthInitial();
}

class AuthLoading extends AuthState {
  AuthLoading();
}

class AuthSuccess extends AuthState {
  AuthSuccess();
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

/// Reset password
class ResetPasswordSuccess extends AuthState {
  final ForgotPasswordResponse response; 

  ResetPasswordSuccess(this.response);
}

/// Change password
class ChangePasswordSuccess extends AuthState {}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();
      state = isLoggedIn ? AuthSuccess() : AuthInitial();
    } catch (_) {
      state = AuthInitial();
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      await _repository.login(email, password);
      state = AuthSuccess();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthLoading();
    try {
      await _repository.logout();
      state = AuthInitial();
    } catch (_) {
      state = AuthInitial();
    }
  }

  /// FORGOT PASSWORD
  Future<void> forgetPassword(String email) async {
    state = AuthLoading();
    try {
      final response = await _repository.forgetPassword(email);
      state = ResetPasswordSuccess(response);
    } catch (e) {
      String errorMessage = 'Failed to send reset OTP';
      
      if (e is DioException) {
        if (e.response != null) {
          final data = e.response!.data;
          errorMessage = data['message'] ?? errorMessage;
        } else if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout ||
                  e.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Connection timeout. Please try again.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        }
      } else if (e is SocketException) {
        errorMessage = 'No internet connection. Please check your network.';
      }
      
      state = AuthError(errorMessage);
    }
  }
}