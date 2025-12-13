import 'package:clifting_app/features/auth/data/model/login_model.dart';
import 'package:clifting_app/features/auth/data/repositories/auth_repositories.dart';
import 'package:clifting_app/utility/local_storage_service/local_storage_service.dart';
import 'package:clifting_app/utility/network_services/api_services.dart';
import 'package:clifting_app/utility/network_services/conectivity_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


// Services Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final localStorageProvider = Provider<LocalStorageService>((ref) => LocalStorageService());

final connectivityProvider = Provider<ConnectivityService>((ref) => ConnectivityService());

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(apiServiceProvider),
    ref.read(localStorageProvider),
  );
});

// State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(connectivityProvider),
  );
});

// State Classes
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthResponse response;
  
  const AuthSuccess(this.response);
}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthTokenExpired extends AuthState {}

class AuthNoInternet extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final ConnectivityService _connectivityService;
  
  AuthNotifier(this._authRepository, this._connectivityService)
      : super(AuthInitial());

  Future<void> login(String email, String password) async {
    try {
      // Check internet connection
      final hasConnection = await _connectivityService.hasInternetConnection();
      if (!hasConnection) {
        state = AuthNoInternet();
        return;
      }

      state = AuthLoading();
      
      final response = await _authRepository.login(email, password);
      
      state = AuthSuccess(response);
    } on UnauthorizedException {
      state = AuthTokenExpired();
    } on NetworkException {
      state = AuthNoInternet();
    } on ApiException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = AuthUnauthenticated();
    } catch (e) {
      state = AuthError('Logout failed');
    }
  }

  Future<void> checkAuthentication() async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      state = isAuthenticated 
          ? AuthAuthenticated()
          : AuthUnauthenticated();
    } catch (e) {
      state = AuthUnauthenticated();
    }
  }

  Future<void> refreshAuthToken() async {
    try {
      state = AuthLoading();
      await _authRepository.refreshToken();
      state = AuthAuthenticated();
    } on UnauthorizedException {
      state = AuthTokenExpired();
    } catch (e) {
      state = AuthUnauthenticated();
    }
  }
}