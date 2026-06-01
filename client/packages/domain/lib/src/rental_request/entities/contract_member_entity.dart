abstract class ContractMemberEntity {
  ContractMemberEntity({
    required this.id,
    required this.contractId,
    required this.fullName,
    required this.isRoomLeader,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.identityNumber,
    this.email,
    this.address,
    this.leftAt,
  });

  final String id;
  final String contractId;
  final String fullName;
  final bool isRoomLeader;
  final String? phone;
  final String? identityNumber;
  final String? email;
  final String? address;
  final String? leftAt;
  final String createdAt;
  final String updatedAt;
}
