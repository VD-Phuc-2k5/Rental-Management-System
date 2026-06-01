import 'package:domain/rental_request.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();

  if (!getIt.isRegistered<CreatePenaltyUsecase>()) {
    getIt.registerLazySingleton(
      () => CreatePenaltyUsecase(repository: getIt()),
    );
    getIt.registerLazySingleton(() => GetPenaltiesUsecase(repository: getIt()));
  }
}
