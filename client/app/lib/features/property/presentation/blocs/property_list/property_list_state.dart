part of 'property_list_bloc.dart';
typedef PropertyListState = SealedClassState<Failure, List<PropertyEntity>>;
typedef PropertyListInitial = SealedClassInitial<Failure, List<PropertyEntity>>;
typedef PropertyListLoadInProgress = SealedClassLoadInProgress<Failure, List<PropertyEntity>>;
typedef PropertyListLoadSuccess = SealedClassLoadSuccess<Failure, List<PropertyEntity>>;
typedef PropertyListLoadFailure = SealedClassLoadFailure<Failure, List<PropertyEntity>>;
