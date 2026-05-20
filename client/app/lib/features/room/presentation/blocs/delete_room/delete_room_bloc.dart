import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'delete_room_event.dart';
part 'delete_room_state.dart';

@injectable
class DeleteRoomBloc extends Bloc<DeleteRoomEvent, DeleteRoomState> {
  DeleteRoomBloc({required DeleteRoomUsecase deleteRoomUsecase})
      : _deleteRoomUsecase = deleteRoomUsecase,
        super(const DeleteRoomInitial()) {
    on<DeleteRoomSubmitted>(_onSubmitted);
  }

  final DeleteRoomUsecase _deleteRoomUsecase;

  Future<void> _onSubmitted(DeleteRoomSubmitted event, Emitter<DeleteRoomState> emit) async {
    emit(const DeleteRoomLoadInProgress());
    final result = await _deleteRoomUsecase(DeleteRoomParams(id: event.id));
    result.fold(
      (failure) => emit(DeleteRoomLoadFailure(failure: failure)),
      (_) => emit(const DeleteRoomLoadSuccess(data: null)),
    );
  }
}

