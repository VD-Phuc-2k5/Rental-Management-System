part of 'forgot_password_bloc.dart';

typedef ForgotPasswordState = SealedClassState<Failure, void>;

typedef ForgotPasswordInitial = SealedClassInitial<Failure, void>;
typedef ForgotPasswordLoadInProgress = SealedClassLoadInProgress<Failure, void>;
typedef ForgotPasswordLoadSuccess = SealedClassLoadSuccess<Failure, void>;
typedef ForgotPasswordLoadFailure = SealedClassLoadFailure<Failure, void>;
