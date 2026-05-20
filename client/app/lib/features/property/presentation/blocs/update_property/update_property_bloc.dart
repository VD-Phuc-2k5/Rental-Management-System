import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/property.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'update_property_event.dart';
part 'update_property_state.dart';

@injectable
class UpdatePropertyBloc extends Bloc<UpdatePropertyEvent, UpdatePropertyState> {
  UpdatePropertyBloc({required UpdatePropertyUsecase updatePropertyUsecase})
      : _updatePropertyUsecase = updatePropertyUsecase,
        super(const UpdatePropertyInitial()) {
    on<UpdatePropertySubmitted>(_onSubmitted);
  }

  final UpdatePropertyUsecase _updatePropertyUsecase;

  Future<void> _onSubmitted(UpdatePropertySubmitted event, Emitter<UpdatePropertyState> emit) async {
    emit(const UpdatePropertyLoadInProgress());
    final result = await _updatePropertyUsecase(UpdatePropertyParams(
      id: event.id, name: event.name, address: event.address, ward: event.ward,
      district: event.district, city: event.city, description: event.description,
      amenityCodes: event.amenityCodes,
    ));
    result.fold(
      (failure) => emit(UpdatePropertyLoadFailure(failure: failure)),
      (data) => emit(UpdatePropertyLoadSuccess(data: data)),
    );
  }
}
