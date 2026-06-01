part of 'create_property_bloc.dart';

typedef CreatePropertyState = SealedClassState<Failure, PropertyEntity>;
typedef CreatePropertyInitial = SealedClassInitial<Failure, PropertyEntity>;
typedef CreatePropertyLoadInProgress =
    SealedClassLoadInProgress<Failure, PropertyEntity>;
typedef CreatePropertyLoadSuccess =
    SealedClassLoadSuccess<Failure, PropertyEntity>;
typedef CreatePropertyLoadFailure =
    SealedClassLoadFailure<Failure, PropertyEntity>;
