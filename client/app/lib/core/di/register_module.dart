import 'package:data/auth.dart';
import 'package:data/property.dart';
import 'package:data/room.dart';
import 'package:domain/auth.dart';
import 'package:domain/property.dart';
import 'package:domain/room.dart';
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

  // --- Data Layer ---
  // auth
  @LazySingleton(as: AuthRemoteDataSource)
  HttpAuthRemoteDataSource get authRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  // property datasource
  @LazySingleton(as: PropertyRemoteDataSource)
  HttpPropertyRemoteDataSource get propertyRemoteDataSource;

  // property repository — needs getToken callback wired to AuthenticationBloc
  @LazySingleton(as: PropertyRepository)
  PropertyRepositoryImpl propertyRepository(
    PropertyRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) =>
      PropertyRepositoryImpl(
        propertyRemoteDataSource: dataSource,
        getToken: () => authBloc.state.user?.token ?? '',
      );

  // room datasource
  @LazySingleton(as: RoomRemoteDataSource)
  HttpRoomRemoteDataSource get roomRemoteDataSource;

  // room repository — needs getToken callback wired to AuthenticationBloc
  @LazySingleton(as: RoomRepository)
  RoomRepositoryImpl roomRepository(
    RoomRemoteDataSource dataSource,
    AuthenticationBloc authBloc,
  ) =>
      RoomRepositoryImpl(
        roomRemoteDataSource: dataSource,
        getToken: () => authBloc.state.user?.token ?? '',
      );

  // --- Domain (UseCases) ---
  // auth
  @injectable
  RegisterUsecase get registerUseCase;

  @injectable
  RegisterLandlordUsecase get registerLandlordUsecase;

  @injectable
  LoginUsecase get loginUsecase;

  @injectable
  LogoutUsecase get logoutUsecase;

  @injectable
  ForgotPasswordUsecase get forgotPasswordUsecase;

  @injectable
  VerifyOtpUsecase get verifyOtpUsecase;

  @injectable
  ResetPasswordUsecase get resetPasswordUsecase;

  // property
  @injectable
  GetPropertiesUsecase get getPropertiesUsecase;

  @injectable
  GetPropertyByIdUsecase get getPropertyByIdUsecase;

  @injectable
  CreatePropertyUsecase get createPropertyUsecase;

  @injectable
  UpdatePropertyUsecase get updatePropertyUsecase;

  @injectable
  DeletePropertyUsecase get deletePropertyUsecase;

  // room
  @injectable
  GetRoomsUsecase get getRoomsUsecase;

  @injectable
  GetRoomByIdUsecase get getRoomByIdUsecase;

  @injectable
  CreateRoomUsecase get createRoomUsecase;

  @injectable
  UpdateRoomUsecase get updateRoomUsecase;

  @injectable
  DeleteRoomUsecase get deleteRoomUsecase;
}
