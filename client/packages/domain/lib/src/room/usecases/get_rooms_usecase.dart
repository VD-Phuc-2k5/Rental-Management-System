import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class GetRoomsParams extends Equatable {
  const GetRoomsParams({required this.propertyId});
  final String propertyId;
  @override
  List<Object> get props => [propertyId];
}

class GetRoomsUsecase implements UseCase<List<RoomEntity>, GetRoomsParams> {
  GetRoomsUsecase({required RoomRepository roomRepository}) : _roomRepository = roomRepository;
  final RoomRepository _roomRepository;

  @override
  Future<Either<Failure, List<RoomEntity>>> call(GetRoomsParams params) async {
    return _roomRepository.getRooms(propertyId: params.propertyId);
  }
}
