import 'package:clifting_app/presentation/features/auth/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = Provider<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel {
  final Ref _ref;

  LoginViewModel(this._ref);

  Future<void> login(String email, String password) async {
    await _ref.read(authProvider.notifier).login(email, password);
  }

  bool get isLoading => _ref.watch(authProvider).isLoading;
  String? get error => _ref.watch(authProvider).error;
  void clearError() => _ref.read(authProvider.notifier).clearError();
}