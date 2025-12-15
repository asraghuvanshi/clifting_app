import 'package:clifting_app/core/network/api_provider.dart';
import 'package:clifting_app/core/services/auth_service.dart';
import 'package:clifting_app/features/auth/data/repositories/auth_repositories.dart';
import 'package:clifting_app/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service providers
final authServiceProvider = Provider<AuthService>((ref) {
   final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepository(
    authService: authService,
    storageService: storageService,
  );
});

// Main auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});