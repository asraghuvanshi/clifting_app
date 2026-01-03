import 'package:clifting_app/presentation/features/profile/data/model/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile();
}
