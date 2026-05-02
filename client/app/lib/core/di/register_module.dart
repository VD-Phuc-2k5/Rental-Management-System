import 'package:data/auth.dart';
import 'package:domain/auth.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../config/router/app_router.dart';

@module
abstract class RegisterModule {
  @singleton
  http.Client get httpClient => http.Client();

  @singleton
  GoRouter router(AuthenticationBloc authBloc) => createRouter(authBloc);

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

  @Injectable()
  LogoutUsecase get logoutUsecase;
}
