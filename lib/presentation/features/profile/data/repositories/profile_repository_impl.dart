import 'package:clifting_app/presentation/features/profile/data/model/user_profile_model.dart';
import 'package:clifting_app/presentation/features/profile/data/repositories/profile_api.dart';
import 'package:clifting_app/presentation/features/profile/domain/repositories/profile_repository.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final UserProfileApi _api;

  ProfileRepositoryImpl(this._api);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _api.getUserProfile();
      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
