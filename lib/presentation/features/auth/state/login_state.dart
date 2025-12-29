import 'package:clifting_app/core/network/api_exception.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';


sealed class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel user;
  LoginSuccess(this.user);
}

class LoginError extends LoginState {
  final ApiException error;
  LoginError(this.error);
}