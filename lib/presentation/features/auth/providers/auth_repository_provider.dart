import 'package:clifting_app/core/providers/api_client_provider.dart';
import 'package:clifting_app/core/providers/token_storage_provider.dart';
import 'package:clifting_app/presentation/features/auth/data/repository/auth_api.dart';
import 'package:clifting_app/presentation/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    AuthApi(ref.read(apiClientProvider)),
    ref.read(tokenStorageProvider),
  );
});