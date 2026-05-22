import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class GetAvailableRoomsParams extends Equatable {
  const GetAvailableRoomsParams({this.minRent, this.maxRent});
  final double? minRent;
  final double? maxRent;
  @override
  List<Object?> get props => [minRent, maxRent];
}

class GetAvailableRoomsUsecase
    implements UseCase<List<AvailableRoomEntity>, GetAvailableRoomsParams> {
  GetAvailableRoomsUsecase({required BrowseRoomRepository browseRoomRepository})
      : _repo = browseRoomRepository;

  final BrowseRoomRepository _repo;

  @override
  Future<Either<Failure, List<AvailableRoomEntity>>> call(
    GetAvailableRoomsParams params,
  ) =>
      _repo.getAvailableRooms(minRent: params.minRent, maxRent: params.maxRent);
}
