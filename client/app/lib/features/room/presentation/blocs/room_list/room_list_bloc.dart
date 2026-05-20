import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'room_list_event.dart';
part 'room_list_state.dart';

@injectable
class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  RoomListBloc({required GetRoomsUsecase getRoomsUsecase})
      : _getRoomsUsecase = getRoomsUsecase,
        super(const RoomListInitial()) {
    on<RoomListFetched>(_onFetched);
  }

  final GetRoomsUsecase _getRoomsUsecase;

  Future<void> _onFetched(RoomListFetched event, Emitter<RoomListState> emit) async {
    emit(const RoomListLoadInProgress());
    final result = await _getRoomsUsecase(GetRoomsParams(propertyId: event.propertyId));
    result.fold(
      (failure) => emit(RoomListLoadFailure(failure: failure)),
      (data) => emit(RoomListLoadSuccess(data: data)),
    );
  }
}

