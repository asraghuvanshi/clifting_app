import 'package:clifting_app/core/storage/token_storage.dart';
import 'package:clifting_app/presentation/features/auth/data/model/login_model.dart';

import 'auth_api.dart';

class AuthRepository {
  final AuthApi api;
  final TokenStorage storage;

  AuthRepository(this.api, this.storage);

  Future<LoginModel> login(String email, String password) async {
    final json = await api.login({
      "email": email,
      "password": password,
    });

    final user = LoginModel.fromJson(json);

    await storage.saveTokens(
      user.data?.accessToken ?? "",
      user.data?.refreshToken ?? "",
    );

    return user;
  }
}
