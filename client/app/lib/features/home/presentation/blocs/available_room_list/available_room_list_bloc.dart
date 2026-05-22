import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'available_room_list_event.dart';
part 'available_room_list_state.dart';

@injectable
class AvailableRoomListBloc
    extends Bloc<AvailableRoomListEvent, AvailableRoomListState> {
  AvailableRoomListBloc(
      {required GetAvailableRoomsUsecase getAvailableRoomsUsecase})
      : _usecase = getAvailableRoomsUsecase,
        super(const AvailableRoomListInitial()) {
    on<AvailableRoomListFetched>(_onFetched);
  }

  final GetAvailableRoomsUsecase _usecase;

  Future<void> _onFetched(
    AvailableRoomListFetched event,
    Emitter<AvailableRoomListState> emit,
  ) async {
    emit(const AvailableRoomListLoadInProgress());
    final result = await _usecase(
      GetAvailableRoomsParams(minRent: event.minRent, maxRent: event.maxRent),
    );
    result.fold(
      (failure) => emit(AvailableRoomListLoadFailure(failure: failure)),
      (data) => emit(AvailableRoomListLoadSuccess(data: data)),
    );
  }
}
