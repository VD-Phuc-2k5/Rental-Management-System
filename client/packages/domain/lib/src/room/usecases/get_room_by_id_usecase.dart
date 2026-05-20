import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class GetRoomByIdParams extends Equatable {
  const GetRoomByIdParams({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}

class GetRoomByIdUsecase implements UseCase<RoomEntity, GetRoomByIdParams> {
  GetRoomByIdUsecase({required RoomRepository roomRepository}) : _roomRepository = roomRepository;
  final RoomRepository _roomRepository;

  @override
  Future<Either<Failure, RoomEntity>> call(GetRoomByIdParams params) async {
    return _roomRepository.getRoomById(id: params.id);
  }
}
