part of 'login_bloc.dart';

typedef LoginState = SealedClassState<Failure, AuthEntity>;

typedef LoginInitial = SealedClassInitial<Failure, AuthEntity>;
typedef LoginLoadInProgress = SealedClassLoadInProgress<Failure, AuthEntity>;
typedef LoginLoadSuccess = SealedClassLoadSuccess<Failure, AuthEntity>;
typedef LoginLoadFailure = SealedClassLoadFailure<Failure, AuthEntity>;
