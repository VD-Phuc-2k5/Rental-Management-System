import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/property.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'property_list_event.dart';
part 'property_list_state.dart';

@injectable
class PropertyListBloc extends Bloc<PropertyListEvent, PropertyListState> {
  PropertyListBloc({required GetPropertiesUsecase getPropertiesUsecase})
    : _getPropertiesUsecase = getPropertiesUsecase,
      super(const PropertyListInitial()) {
    on<PropertyListFetched>(_onFetched);
  }

  final GetPropertiesUsecase _getPropertiesUsecase;

  Future<void> _onFetched(
    PropertyListFetched event,
    Emitter<PropertyListState> emit,
  ) async {
    emit(const PropertyListLoadInProgress());
    final result = await _getPropertiesUsecase(const NoParams());
    result.fold(
      (failure) => emit(PropertyListLoadFailure(failure: failure)),
      (data) => emit(PropertyListLoadSuccess(data: data)),
    );
  }
}
