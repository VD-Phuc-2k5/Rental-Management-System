part of 'reset_password_bloc.dart';

typedef ResetPasswordState = SealedClassState<Failure, void>;

typedef ResetPasswordInitial = SealedClassInitial<Failure, void>;
typedef ResetPasswordLoadInProgress = SealedClassLoadInProgress<Failure, void>;
typedef ResetPasswordLoadFailure = SealedClassLoadFailure<Failure, void>;
typedef ResetPasswordLoadSuccess = SealedClassLoadSuccess<Failure, void>;
