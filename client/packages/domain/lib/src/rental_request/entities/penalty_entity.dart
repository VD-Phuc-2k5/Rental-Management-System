abstract class PenaltyEntity {
  PenaltyEntity({
    required this.id,
    required this.contractId,
    required this.tenantId,
    required this.roomId,
    required this.amount,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String contractId;
  final String tenantId;
  final String roomId;
  final double amount;
  final String reason;
  final String status;
  final String createdAt;
}