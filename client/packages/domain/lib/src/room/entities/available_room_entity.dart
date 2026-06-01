import 'room_entity.dart';

abstract class AvailableRoomEntity {
  AvailableRoomEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.areaSqm,
    required this.monthlyRent,
    required this.depositAmount,
    required this.propertyId,
    required this.propertyName,
    required this.fullAddress,
    this.firstImageUrl,
  });

  final String id;
  final String title;
  final RoomStatus status;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final String propertyId;
  final String propertyName;
  final String fullAddress;
  final String? firstImageUrl;
}
