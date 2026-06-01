import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/room.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'browse_room_detail_event.dart';
part 'browse_room_detail_state.dart';

@injectable
class BrowseRoomDetailBloc
    extends Bloc<BrowseRoomDetailEvent, BrowseRoomDetailState> {
  BrowseRoomDetailBloc(
      {required GetBrowseRoomDetailUsecase getBrowseRoomDetailUsecase})
      : _usecase = getBrowseRoomDetailUsecase,
        super(const BrowseRoomDetailInitial()) {
    on<BrowseRoomDetailFetched>(_onFetched);
  }

  final GetBrowseRoomDetailUsecase _usecase;

  Future<void> _onFetched(
    BrowseRoomDetailFetched event,
    Emitter<BrowseRoomDetailState> emit,
  ) async {
    emit(const BrowseRoomDetailLoadInProgress());
    final result = await _usecase(
      GetBrowseRoomDetailParams(id: event.roomId),
    );
    result.fold(
      (failure) => emit(BrowseRoomDetailLoadFailure(failure: failure)),
      (data) => emit(BrowseRoomDetailLoadSuccess(data: data)),
    );
  }
}
