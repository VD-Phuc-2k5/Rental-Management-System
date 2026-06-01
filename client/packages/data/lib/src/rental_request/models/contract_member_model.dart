import 'package:domain/rental_request.dart';

class ContractMemberModel extends ContractMemberEntity {
  ContractMemberModel({
    required super.id,
    required super.contractId,
    required super.fullName,
    required super.isRoomLeader,
    required super.createdAt,
    required super.updatedAt,
    super.phone,
    super.identityNumber,
    super.email,
    super.address,
    super.leftAt,
  });

  factory ContractMemberModel.fromJson(Map<String, dynamic> json) =>
      ContractMemberModel(
        id: json['id'] as String,
        contractId: json['contractId'] as String,
        fullName: json['fullName'] as String,
        isRoomLeader: json['isRoomLeader'] as bool? ?? false,
        phone: json['phone'] as String?,
        identityNumber: json['identityNumber'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        leftAt: json['leftAt'] as String?,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
      );
}
