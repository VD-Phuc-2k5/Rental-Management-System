// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/auth.dart' as _i41;
import 'package:data/property.dart' as _i83;
import 'package:data/room.dart' as _i586;
import 'package:domain/auth.dart' as _i378;
import 'package:domain/property.dart' as _i369;
import 'package:domain/room.dart' as _i142;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart'
    as _i652;
import '../../features/auth/presentation/blocs/forgot_password/forgot_password_bloc.dart'
    as _i1047;
import '../../features/auth/presentation/blocs/login/login_bloc.dart' as _i1018;
import '../../features/auth/presentation/blocs/register/register_bloc.dart'
    as _i517;
import '../../features/auth/presentation/blocs/register_landlord/register_landlord_bloc.dart'
    as _i165;
import '../../features/auth/presentation/blocs/verify_otp/verify_otp_bloc.dart'
    as _i452;
import '../../features/property/presentation/blocs/create_property/create_property_bloc.dart'
    as _i509;
import '../../features/property/presentation/blocs/delete_property/delete_property_bloc.dart'
    as _i634;
import '../../features/property/presentation/blocs/property_list/property_list_bloc.dart'
    as _i327;
import '../../features/property/presentation/blocs/update_property/update_property_bloc.dart'
    as _i1054;
import '../../features/room/presentation/blocs/create_room/create_room_bloc.dart'
    as _i621;
import '../../features/room/presentation/blocs/delete_room/delete_room_bloc.dart'
    as _i171;
import '../../features/room/presentation/blocs/room_list/room_list_bloc.dart'
    as _i187;
import '../../features/room/presentation/blocs/update_room/update_room_bloc.dart'
    as _i746;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule(this);
    gh.singleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i41.AuthRemoteDataSource>(
      () => registerModule.authRemoteDataSource,
    );
    gh.lazySingleton<_i378.AuthRepository>(() => registerModule.authRepository);
    gh.lazySingleton<_i83.PropertyRemoteDataSource>(
      () => registerModule.propertyRemoteDataSource,
    );
    gh.lazySingleton<_i586.RoomRemoteDataSource>(
      () => registerModule.roomRemoteDataSource,
    );
    gh.factory<_i378.RegisterUsecase>(() => registerModule.registerUseCase);
    gh.factory<_i378.RegisterLandlordUsecase>(
      () => registerModule.registerLandlordUsecase,
    );
    gh.factory<_i378.LoginUsecase>(() => registerModule.loginUsecase);
    gh.factory<_i378.LogoutUsecase>(() => registerModule.logoutUsecase);
    gh.factory<_i378.ForgotPasswordUsecase>(
      () => registerModule.forgotPasswordUsecase,
    );
    gh.factory<_i378.VerifyOtpUsecase>(() => registerModule.verifyOtpUsecase);
    gh.factory<_i378.ResetPasswordUsecase>(
      () => registerModule.resetPasswordUsecase,
    );
    gh.factory<_i1047.ForgotPasswordBloc>(
      () => _i1047.ForgotPasswordBloc(
        forgotPasswordUsecase: gh<_i378.ForgotPasswordUsecase>(),
      ),
    );
    gh.factory<_i165.RegisterLandlordBloc>(
      () => _i165.RegisterLandlordBloc(
        registerLandlordUsecase: gh<_i378.RegisterLandlordUsecase>(),
      ),
    );
    gh.factory<_i452.VerifyOtpBloc>(
      () => _i452.VerifyOtpBloc(
        verifyOtpUsecase: gh<_i378.VerifyOtpUsecase>(),
        forgotPasswordUsecase: gh<_i378.ForgotPasswordUsecase>(),
      ),
    );
    gh.singleton<_i652.AuthenticationBloc>(
      () => _i652.AuthenticationBloc(
        authRepository: gh<_i378.AuthRepository>(),
        logoutUseCase: gh<_i378.LogoutUsecase>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i142.RoomRepository>(
      () => registerModule.roomRepository(
        gh<_i586.RoomRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i652.AuthenticationBloc>()),
    );
    gh.factory<_i517.RegisterBloc>(
      () => _i517.RegisterBloc(registerUsecase: gh<_i378.RegisterUsecase>()),
    );
    gh.factory<_i1018.LoginBloc>(
      () => _i1018.LoginBloc(loginUsecase: gh<_i378.LoginUsecase>()),
    );
    gh.factory<_i142.GetRoomsUsecase>(() => registerModule.getRoomsUsecase);
    gh.factory<_i142.GetRoomByIdUsecase>(
      () => registerModule.getRoomByIdUsecase,
    );
    gh.factory<_i142.CreateRoomUsecase>(() => registerModule.createRoomUsecase);
    gh.factory<_i142.UpdateRoomUsecase>(() => registerModule.updateRoomUsecase);
    gh.factory<_i142.DeleteRoomUsecase>(() => registerModule.deleteRoomUsecase);
    gh.factory<_i746.UpdateRoomBloc>(
      () => _i746.UpdateRoomBloc(
        updateRoomUsecase: gh<_i142.UpdateRoomUsecase>(),
      ),
    );
    gh.lazySingleton<_i369.PropertyRepository>(
      () => registerModule.propertyRepository(
        gh<_i83.PropertyRemoteDataSource>(),
        gh<_i652.AuthenticationBloc>(),
      ),
    );
    gh.factory<_i187.RoomListBloc>(
      () => _i187.RoomListBloc(getRoomsUsecase: gh<_i142.GetRoomsUsecase>()),
    );
    gh.factory<_i171.DeleteRoomBloc>(
      () => _i171.DeleteRoomBloc(
        deleteRoomUsecase: gh<_i142.DeleteRoomUsecase>(),
      ),
    );
    gh.factory<_i621.CreateRoomBloc>(
      () => _i621.CreateRoomBloc(
        createRoomUsecase: gh<_i142.CreateRoomUsecase>(),
      ),
    );
    gh.factory<_i369.GetPropertiesUsecase>(
      () => registerModule.getPropertiesUsecase,
    );
    gh.factory<_i369.GetPropertyByIdUsecase>(
      () => registerModule.getPropertyByIdUsecase,
    );
    gh.factory<_i369.CreatePropertyUsecase>(
      () => registerModule.createPropertyUsecase,
    );
    gh.factory<_i369.UpdatePropertyUsecase>(
      () => registerModule.updatePropertyUsecase,
    );
    gh.factory<_i369.DeletePropertyUsecase>(
      () => registerModule.deletePropertyUsecase,
    );
    gh.factory<_i1054.UpdatePropertyBloc>(
      () => _i1054.UpdatePropertyBloc(
        updatePropertyUsecase: gh<_i369.UpdatePropertyUsecase>(),
      ),
    );
    gh.factory<_i634.DeletePropertyBloc>(
      () => _i634.DeletePropertyBloc(
        deletePropertyUsecase: gh<_i369.DeletePropertyUsecase>(),
      ),
    );
    gh.factory<_i327.PropertyListBloc>(
      () => _i327.PropertyListBloc(
        getPropertiesUsecase: gh<_i369.GetPropertiesUsecase>(),
      ),
    );
    gh.factory<_i509.CreatePropertyBloc>(
      () => _i509.CreatePropertyBloc(
        createPropertyUsecase: gh<_i369.CreatePropertyUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {
  _$RegisterModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i41.HttpAuthRemoteDataSource get authRemoteDataSource =>
      _i41.HttpAuthRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i41.AuthRepositoryImpl get authRepository => _i41.AuthRepositoryImpl(
    authRemoteDataSource: _getIt<_i41.AuthRemoteDataSource>(),
  );

  @override
  _i83.HttpPropertyRemoteDataSource get propertyRemoteDataSource =>
      _i83.HttpPropertyRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i586.HttpRoomRemoteDataSource get roomRemoteDataSource =>
      _i586.HttpRoomRemoteDataSource(client: _getIt<_i519.Client>());

  @override
  _i378.RegisterUsecase get registerUseCase =>
      _i378.RegisterUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.RegisterLandlordUsecase get registerLandlordUsecase =>
      _i378.RegisterLandlordUsecase(
        authRepository: _getIt<_i378.AuthRepository>(),
      );

  @override
  _i378.LoginUsecase get loginUsecase =>
      _i378.LoginUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.LogoutUsecase get logoutUsecase =>
      _i378.LogoutUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.ForgotPasswordUsecase get forgotPasswordUsecase =>
      _i378.ForgotPasswordUsecase(
        authRepository: _getIt<_i378.AuthRepository>(),
      );

  @override
  _i378.VerifyOtpUsecase get verifyOtpUsecase =>
      _i378.VerifyOtpUsecase(authRepository: _getIt<_i378.AuthRepository>());

  @override
  _i378.ResetPasswordUsecase get resetPasswordUsecase =>
      _i378.ResetPasswordUsecase(
        authRepository: _getIt<_i378.AuthRepository>(),
      );

  @override
  _i142.GetRoomsUsecase get getRoomsUsecase =>
      _i142.GetRoomsUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.GetRoomByIdUsecase get getRoomByIdUsecase =>
      _i142.GetRoomByIdUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.CreateRoomUsecase get createRoomUsecase =>
      _i142.CreateRoomUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.UpdateRoomUsecase get updateRoomUsecase =>
      _i142.UpdateRoomUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i142.DeleteRoomUsecase get deleteRoomUsecase =>
      _i142.DeleteRoomUsecase(roomRepository: _getIt<_i142.RoomRepository>());

  @override
  _i369.GetPropertiesUsecase get getPropertiesUsecase =>
      _i369.GetPropertiesUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.GetPropertyByIdUsecase get getPropertyByIdUsecase =>
      _i369.GetPropertyByIdUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.CreatePropertyUsecase get createPropertyUsecase =>
      _i369.CreatePropertyUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.UpdatePropertyUsecase get updatePropertyUsecase =>
      _i369.UpdatePropertyUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );

  @override
  _i369.DeletePropertyUsecase get deletePropertyUsecase =>
      _i369.DeletePropertyUsecase(
        propertyRepository: _getIt<_i369.PropertyRepository>(),
      );
}
