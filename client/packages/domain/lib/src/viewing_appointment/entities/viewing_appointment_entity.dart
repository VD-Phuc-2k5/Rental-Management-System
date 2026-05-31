enum ViewingAppointmentStatus { pending, approved, rejected, cancelled }

abstract class ViewingAppointmentEntity {
  ViewingAppointmentEntity({
    required this.id,
    required this.tenantId,
    required this.roomId,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.roomTitle,
    this.roomAddress,
    this.roomMonthlyRent,
    this.hasRentalRequest = false,
  });

  final String id;
  final String tenantId;
  final String roomId;
  final String scheduledAt;
  final ViewingAppointmentStatus status;
  final String? note;
  final String createdAt;
  final String updatedAt;
  final String? roomTitle;
  final String? roomAddress;
  final String? roomMonthlyRent;
  final bool hasRentalRequest;
}
