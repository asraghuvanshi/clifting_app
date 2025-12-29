import 'package:clifting_app/core/router/app_navigator.dart';
import 'package:clifting_app/presentation/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel {
  final Ref ref;
  
  LoginViewModel(this.ref);
  
  Future<void> login(String email, String password) async {
    await ref.read(authProvider.notifier).login(email, password);
  }
  
  void navigateToSignup() {
    AppNavigator.toSignup();
  }
}