enum ContractStatus { draft, sent, signed, cancelled, finished }

abstract class ContractEntity {
  ContractEntity({
    required this.id,
    required this.roomId,
    required this.tenantId,
    required this.landlordId,
    required this.startDate,
    required this.endDate,
    required this.monthlyRent,
    required this.deposit,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.rentalRequestId,
    this.terms,
    this.momoNumber,
    this.sentAt,
    this.signedAt,
    this.cancelledAt,
    this.finishedAt,
  });

  final String id;
  final String? rentalRequestId;
  final String roomId;
  final String tenantId;
  final String landlordId;
  final String startDate;
  final String endDate;
  final double monthlyRent;
  final double deposit;
  final ContractStatus status;
  final String? terms;
  final String? momoNumber;
  final String? sentAt;
  final String? signedAt;
  final String? cancelledAt;
  final String? finishedAt;
  final String createdAt;
  final String updatedAt;
}
