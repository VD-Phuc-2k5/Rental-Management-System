import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  });
}
