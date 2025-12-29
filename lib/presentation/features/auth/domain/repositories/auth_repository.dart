

import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> signup(Map<String, dynamic> userData);
  Future<void> logout();
  Future<bool> isLoggedIn();
}