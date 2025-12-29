import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final LoginResponse user;
  const AuthSuccess(this.user);
}

class SignupSuccess extends AuthState {
  const SignupSuccess();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}