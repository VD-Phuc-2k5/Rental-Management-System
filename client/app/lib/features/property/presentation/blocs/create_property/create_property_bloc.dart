import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/property.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'create_property_event.dart';
part 'create_property_state.dart';

@injectable
class CreatePropertyBloc
    extends Bloc<CreatePropertyEvent, CreatePropertyState> {
  CreatePropertyBloc({required CreatePropertyUsecase createPropertyUsecase})
    : _createPropertyUsecase = createPropertyUsecase,
      super(const CreatePropertyInitial()) {
    on<CreatePropertySubmitted>(_onSubmitted);
  }

  final CreatePropertyUsecase _createPropertyUsecase;

  Future<void> _onSubmitted(
    CreatePropertySubmitted event,
    Emitter<CreatePropertyState> emit,
  ) async {
    emit(const CreatePropertyLoadInProgress());
    final result = await _createPropertyUsecase(
      CreatePropertyParams(
        name: event.name,
        address: event.address,
        ward: event.ward,
        district: event.district,
        city: event.city,
        description: event.description,
        amenityCodes: event.amenityCodes,
      ),
    );
    result.fold(
      (failure) => emit(CreatePropertyLoadFailure(failure: failure)),
      (data) => emit(CreatePropertyLoadSuccess(data: data)),
    );
  }
}
