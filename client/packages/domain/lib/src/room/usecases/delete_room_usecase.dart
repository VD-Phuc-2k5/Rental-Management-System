import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class DeleteRoomParams extends Equatable {
  const DeleteRoomParams({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}

class DeleteRoomUsecase implements UseCase<void, DeleteRoomParams> {
  DeleteRoomUsecase({required RoomRepository roomRepository}) : _roomRepository = roomRepository;
  final RoomRepository _roomRepository;

  @override
  Future<Either<Failure, void>> call(DeleteRoomParams params) async {
    return _roomRepository.deleteRoom(id: params.id);
  }
}
