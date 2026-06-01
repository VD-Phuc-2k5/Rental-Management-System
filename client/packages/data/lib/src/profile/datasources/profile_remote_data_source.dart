import '../models/user_profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile({required String token});
  Future<UserProfileModel> updateProfile({
    required String token,
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? avatarUrl,
  });
}
