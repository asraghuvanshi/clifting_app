import 'package:clifting_app/presentation/features/profile/data/model/user_profile_model.dart';

class ProfileState {
  final bool isLoading;
  final UserProfileModel? data;
  final String? error;

  const ProfileState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserProfileModel? data,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}