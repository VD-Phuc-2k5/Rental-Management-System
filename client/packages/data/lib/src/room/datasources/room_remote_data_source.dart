import 'package:data/room.dart';

abstract interface class RoomRemoteDataSource {
  Future<List<RoomModel>> getRooms({required String propertyId, required String token});
  Future<RoomModel> getRoomById({required String id, required String token});
  Future<RoomModel> createRoom({
    required String propertyId,
    required String token,
    required String title,
    required double areaSqm,
    required double monthlyRent,
    required double depositAmount,
    required double electricityRatePerKwh,
    required double waterRatePerM3,
    required bool hasFurniture,
    String? description,
  });
  Future<RoomModel> updateRoom({
    required String id,
    required String token,
    String? title,
    String? status,
    double? areaSqm,
    double? monthlyRent,
    double? depositAmount,
    double? electricityRatePerKwh,
    double? waterRatePerM3,
    bool? hasFurniture,
    String? description,
  });
  Future<void> deleteRoom({required String id, required String token});
}
