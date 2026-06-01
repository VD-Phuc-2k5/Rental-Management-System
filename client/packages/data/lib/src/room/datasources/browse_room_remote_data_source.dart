import '../models/available_room_model.dart';
import '../models/browse_room_detail_model.dart';

abstract interface class BrowseRoomRemoteDataSource {
  Future<List<AvailableRoomModel>> getAvailableRooms({
    required String token,
    double? minRent,
    double? maxRent,
  });

  Future<BrowseRoomDetailModel> getRoomDetail({
    required String id,
    required String token,
  });
}
