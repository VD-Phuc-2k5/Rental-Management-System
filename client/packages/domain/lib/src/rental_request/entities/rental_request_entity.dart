enum RentalRequestStatus { pending, accepted, rejected, contracted }

abstract class RentalRequestEntity {
  RentalRequestEntity({
    required this.id,
    required this.tenantId,
    required this.roomId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });

  final String id;
  final String tenantId;
  final String roomId;
  final String? note;
  final RentalRequestStatus status;
  final String createdAt;
  final String updatedAt;
}
