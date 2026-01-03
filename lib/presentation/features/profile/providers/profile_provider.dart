import 'package:clifting_app/presentation/features/profile/domain/repositories/profile_repository.dart';
import 'package:clifting_app/presentation/features/profile/providers/profile_repository_provider.dart';
import 'package:clifting_app/presentation/features/profile/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) {
    final profileRepository = ref.read(profileRepositoryProvider);
    return ProfileNotifier(profileRepository);
  },
);

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileNotifier(this._profileRepository) : super(const ProfileState());
 
   // get user profile api
  Future<void> getUserProfile() async {
    try {
      // Start loading
      state = state.copyWith(isLoading: true, error: null);

      // Call repository
      final response = await _profileRepository.getUserProfile();

    if (response.success ?? false) {
        // Success
        state = state.copyWith(
          isLoading: false,
          data: response,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
          data: null,
        );
      }
    } catch (e) {
      // Handle error
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}