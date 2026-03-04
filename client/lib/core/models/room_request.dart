class RoomRequest {
  final String id;
  final String tenantName;
  final String phoneNumber;
  final String roomInfo;
  final String scheduledDate;
  final String? note;
  final String status;

  RoomRequest({
    required this.id,
    required this.tenantName,
    required this.phoneNumber,
    required this.roomInfo,
    required this.scheduledDate,
    this.note,
    required this.status,
  });
}