enum RoomStatus { available, occupied, maintenance }

abstract class RoomEntity {
  RoomEntity({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.status,
    required this.areaSqm,
    required this.monthlyRent,
    required this.depositAmount,
    required this.electricityRatePerKwh,
    required this.waterRatePerM3,
    required this.hasFurniture,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String propertyId;
  final String title;
  final RoomStatus status;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final double electricityRatePerKwh;
  final double waterRatePerM3;
  final bool hasFurniture;
  final String? description;
  final String createdAt;
  final String updatedAt;
}
