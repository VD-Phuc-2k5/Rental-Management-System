import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'create_room_event.dart';
part 'create_room_state.dart';

@injectable
class CreateRoomBloc extends Bloc<CreateRoomEvent, CreateRoomState> {
  CreateRoomBloc({required CreateRoomUsecase createRoomUsecase})
    : _createRoomUsecase = createRoomUsecase,
      super(const CreateRoomInitial()) {
    on<CreateRoomSubmitted>(_onSubmitted);
  }

  final CreateRoomUsecase _createRoomUsecase;

  Future<void> _onSubmitted(
    CreateRoomSubmitted event,
    Emitter<CreateRoomState> emit,
  ) async {
    emit(const CreateRoomLoadInProgress());
    final result = await _createRoomUsecase(
      CreateRoomParams(
        propertyId: event.propertyId,
        title: event.title,
        areaSqm: event.areaSqm,
        monthlyRent: event.monthlyRent,
        depositAmount: event.depositAmount,
        electricityRatePerKwh: event.electricityRatePerKwh,
        waterRatePerM3: event.waterRatePerM3,
        includedAmenityCodes: event.includedAmenityCodes,
        addonAmenities: event.addonAmenities,
        description: event.description,
        images: event.images,
        parkingFees: event.parkingFees,
      ),
    );
    result.fold(
      (failure) => emit(CreateRoomLoadFailure(failure: failure)),
      (data) => emit(CreateRoomLoadSuccess(data: data)),
    );
  }
}
