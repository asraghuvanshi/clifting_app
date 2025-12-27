// features/auth/presentation/notifier/auth_notifier.dart
import 'dart:io';
import 'package:clifting_app/features/auth/data/model/change_password_response.dart';
import 'package:clifting_app/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/features/auth/data/model/user_profile_model.dart';
import 'package:clifting_app/features/auth/data/model/verify_reset_password_otp.dart';
import 'package:clifting_app/features/auth/data/repositories/auth_repositories.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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

class LoginSuccess extends AuthState {
  final LoginModel response;
  LoginSuccess(this.response);
}

/// Reset password
class ResetPasswordSuccess extends AuthState {
  final ForgotPasswordResponse response; 

  ResetPasswordSuccess(this.response);
}

class UserProfileSuccess extends AuthState {
  final UserProfileModel response;
  UserProfileSuccess(this.response);
}

/// Verify OTP Reset Password
class VerifyResetPasswordOtpSuccess extends AuthState {
  final VerifyResetPasswordOtpResponse response;
  VerifyResetPasswordOtpSuccess(this.response);
}


/// Change password
class ChangePasswordSuccess extends AuthState {
  final VerifyResetPasswordOtpResponse response;
  ChangePasswordSuccess(this.response);
}


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
    final response = await _repository.login(email, password);
    state = LoginSuccess(response);
  } catch (e) {
    String errorMessage = 'Login failed';
    
    if (e is DioException) {
      if (e.response != null) {
        final data = e.response!.data;
        errorMessage = data['message'] ?? errorMessage;
        
        // Check for common HTTP status codes
        if (e.response!.statusCode == 401) {
          errorMessage = 'Invalid email or password';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'User not found';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error. Please try again later.';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = 'Invalid server response';
      }
    } else if (e is SocketException) {
      errorMessage = 'No internet connection. Please check your network.';
    } else if (e is FormatException) {
      errorMessage = 'Invalid response from server';
    }
    
    state = AuthError(errorMessage);
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


    /// VERIFY RESET PASSWORD OTP
  Future<void> verifyResetPasswordOTP(String email, String otp) async {
    state = AuthLoading();
    try {
      final response = await _repository.verifyResetPasswordOtp(email, otp);
      state = VerifyResetPasswordOtpSuccess(response);
    } catch (e) {
      String errorMessage = 'Failed to verify OTP';
      
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

  /// RESET PASSWORD WITH TOKEN
  Future<void> changePassword(String token,String password) async {
    state = AuthLoading();
    try {
      final response = await _repository.changePassword(token , password);
      state = ChangePasswordSuccess(response);
    } catch (e) {
      String errorMessage = 'Failed to change password';
      
      if (e is DioException) {
        if (e.response != null) {
          final data = e.response!.data;
          errorMessage = data['message'] ?? errorMessage;
        }
      }
      
      state = AuthError(errorMessage);
    }
  }

   //  Get user profile model
   Future<void> getUserProfile() async {
    state = AuthLoading();
    try {
      final response = await _repository.getUserProfile();
      state = UserProfileSuccess(response);
      print(response);
    } catch (e) {
      String errorMessage = 'Failed to retrieve';
      
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
      print(e);
      state = AuthError(errorMessage);
    }
  }

}