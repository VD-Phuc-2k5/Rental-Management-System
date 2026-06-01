part of 'update_property_bloc.dart';

typedef UpdatePropertyState = SealedClassState<Failure, PropertyEntity>;
typedef UpdatePropertyInitial = SealedClassInitial<Failure, PropertyEntity>;
typedef UpdatePropertyLoadInProgress =
    SealedClassLoadInProgress<Failure, PropertyEntity>;
typedef UpdatePropertyLoadSuccess =
    SealedClassLoadSuccess<Failure, PropertyEntity>;
typedef UpdatePropertyLoadFailure =
    SealedClassLoadFailure<Failure, PropertyEntity>;
