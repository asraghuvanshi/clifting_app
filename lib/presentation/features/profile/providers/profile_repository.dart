import 'package:clifting_app/presentation/features/auth/data/model/user_profile_model.dart';

abstract class AuthRepository {
  Future<UserProfileModel> fetchUserProfile();
}