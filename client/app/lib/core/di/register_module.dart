import 'package:data/auth.dart';
import 'package:domain/auth.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@module
abstract class RegisterModule {
  @lazySingleton
  http.Client get httpClient => http.Client();

  // --- Data Layer Registration (LazySingleton) ---
  // auth
  @LazySingleton(as: AuthRemoteDataSource)
  HttpAuthRemoteDataSource get authRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  // --- Domain Layer (UseCases) Registration (Injectable - factory) ---
  // auth
  @injectable
  RegisterUsecase get registerUseCase;
}
