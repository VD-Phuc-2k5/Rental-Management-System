// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/auth.dart' as _i41;
import 'package:domain/auth.dart' as _i378;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/presentation/blocs/bloc/register_bloc.dart'
    as _i939;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule(this);
    gh.lazySingleton<_i519.Client>(() => registerModule.httpClient);
    gh.lazySingleton<_i41.AuthRemoteDataSource>(
      () => registerModule.authRemoteDataSource,
    );
    gh.lazySingleton<_i378.AuthRepository>(() => registerModule.authRepository);
    gh.factory<_i378.RegisterUsecase>(() => registerModule.registerUseCase);
    gh.factory<_i939.RegisterBloc>(
      () => _i939.RegisterBloc(registerUsecase: gh<_i378.RegisterUsecase>()),
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
  _i378.RegisterUsecase get registerUseCase =>
      _i378.RegisterUsecase(authRepository: _getIt<_i378.AuthRepository>());
}
