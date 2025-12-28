import 'package:clifting_app/core/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/auth_repository.dart';
import '../state/login_state.dart';
import '../../../core/network/api_exception.dart';

class LoginController extends StateNotifier<LoginState> {
  final AuthRepository repo;

  LoginController(this.repo) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    state = LoginLoading();
    try {
      final user = await repo.login(email, password);
      state = LoginSuccess(user);
    } on ApiException catch (e) {
      state = LoginError(e);
    }
  }
}


final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref.read(authRepositoryProvider));
});
