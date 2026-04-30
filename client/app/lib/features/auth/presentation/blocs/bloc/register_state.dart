part of 'register_bloc.dart';

typedef RegisterState = SealedClassState<Failure, void>;

typedef RegisterInitial = SealedClassInitial<Failure, void>;
typedef ReigsterLoadInProgress = SealedClassLoadInProgress<Failure, void>;
typedef RegisterLoadSuccess = SealedClassLoadSuccess<Failure, void>;
typedef RegisterLoadFailure = SealedClassLoadFailure<Failure, void>;
