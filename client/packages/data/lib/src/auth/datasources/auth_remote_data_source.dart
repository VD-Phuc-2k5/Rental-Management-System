import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Stream<UserModel?> get onAuthStateChanged;

  Future<UserModel> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  });

  Future<void> logout();
}
