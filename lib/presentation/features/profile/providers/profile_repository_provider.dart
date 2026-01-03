

import 'package:clifting_app/presentation/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clifting_app/core/providers/api_client_provider.dart';
import 'package:clifting_app/presentation/features/profile/data/repositories/profile_api.dart';
import 'package:clifting_app/presentation/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    UserProfileApi(ref.read(apiClientProvider)),
  );
});
