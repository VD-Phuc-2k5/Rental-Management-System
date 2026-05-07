import '../../../auth.dart';

abstract interface class AuthRemoteDataSource {
  Stream<AuthModel?> get onAuthStateChanged;

  Future<void> register({
    required String fullName,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    required bool acceptedTerms,
  });

  Future<AuthModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
