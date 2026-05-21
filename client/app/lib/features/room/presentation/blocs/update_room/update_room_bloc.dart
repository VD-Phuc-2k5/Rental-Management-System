import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'update_room_event.dart';
part 'update_room_state.dart';

@injectable
class UpdateRoomBloc extends Bloc<UpdateRoomEvent, UpdateRoomState> {
  UpdateRoomBloc({required UpdateRoomUsecase updateRoomUsecase})
    : _updateRoomUsecase = updateRoomUsecase,
      super(const UpdateRoomInitial()) {
    on<UpdateRoomSubmitted>(_onSubmitted);
  }

  final UpdateRoomUsecase _updateRoomUsecase;

  Future<void> _onSubmitted(
    UpdateRoomSubmitted event,
    Emitter<UpdateRoomState> emit,
  ) async {
    emit(const UpdateRoomLoadInProgress());
    final result = await _updateRoomUsecase(
      UpdateRoomParams(
        id: event.id,
        title: event.title,
        status: event.status,
        areaSqm: event.areaSqm,
        monthlyRent: event.monthlyRent,
        depositAmount: event.depositAmount,
        electricityRatePerKwh: event.electricityRatePerKwh,
        waterRatePerM3: event.waterRatePerM3,
        includedAmenityCodes: event.includedAmenityCodes,
        addonAmenities: event.addonAmenities,
        description: event.description,
      ),
    );
    result.fold(
      (failure) => emit(UpdateRoomLoadFailure(failure: failure)),
      (data) => emit(UpdateRoomLoadSuccess(data: data)),
    );
  }
}
