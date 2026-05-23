import '../../../room.dart';
import 'package:domain/room.dart';

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
    required List<String> includedAmenityCodes,
    required List<RoomAddonAmenity> addonAmenities,
    String? description,
    List<({String url, int sortOrder})>? images,
    RoomParkingFees? parkingFees,
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
    List<String>? includedAmenityCodes,
    List<RoomAddonAmenity>? addonAmenities,
    String? description,
    List<({String url, int sortOrder})>? images,
    RoomParkingFees? parkingFees,
  });
  Future<void> deleteRoom({required String id, required String token});
}
