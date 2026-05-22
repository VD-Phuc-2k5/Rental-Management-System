import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

class GetBrowseRoomDetailParams extends Equatable {
  const GetBrowseRoomDetailParams({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}

class GetBrowseRoomDetailUsecase
    implements UseCase<BrowseRoomDetailEntity, GetBrowseRoomDetailParams> {
  GetBrowseRoomDetailUsecase(
      {required BrowseRoomRepository browseRoomRepository})
      : _repo = browseRoomRepository;

  final BrowseRoomRepository _repo;

  @override
  Future<Either<Failure, BrowseRoomDetailEntity>> call(
    GetBrowseRoomDetailParams params,
  ) =>
      _repo.getRoomDetail(id: params.id);
}
