import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../room.dart';

abstract interface class BrowseRoomRepository {
  Future<Either<Failure, List<AvailableRoomEntity>>> getAvailableRooms({
    double? minRent,
    double? maxRent,
  });

  Future<Either<Failure, BrowseRoomDetailEntity>> getRoomDetail({
    required String id,
  });
}
