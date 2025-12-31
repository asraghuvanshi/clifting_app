

import 'package:clifting_app/presentation/features/auth/data/model/forget_password_model.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<ForgotPasswordResponse> forgetPassword(ResetPasswordRequest request);
  Future<ForgotPasswordResponse> resetPassword(ResetPasswordRequest request);
  Future<void> signup(Map<String, dynamic> userData);
  Future<void> logout();
  Future<bool> isLoggedIn();
}