enum RentalRequestStatus { pending, accepted, rejected, contracted }

class MemberInfo {
  const MemberInfo({
    required this.fullName,
    required this.isRoomLeader,
    this.phone,
    this.identityNumber,
    this.identityImageUrl,
    this.email,
    this.address,
    this.dateOfBirth,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) => MemberInfo(
        fullName: json['fullName'] as String,
        isRoomLeader: json['isRoomLeader'] as bool? ?? false,
        phone: json['phone'] as String?,
        identityNumber: json['identityNumber'] as String?,
        identityImageUrl: json['identityImageUrl'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        dateOfBirth: json['dateOfBirth'] as String?,
      );

  final String fullName;
  final bool isRoomLeader;
  final String? phone;
  final String? identityNumber;
  final String? identityImageUrl;
  final String? email;
  final String? address;
  final String? dateOfBirth;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'isRoomLeader': isRoomLeader,
        if (phone != null) 'phone': phone,
        if (identityNumber != null) 'identityNumber': identityNumber,
        if (identityImageUrl != null) 'identityImageUrl': identityImageUrl,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      };
}

class VehicleInfo {
  const VehicleInfo({
    required this.type,
    required this.plate,
    required this.quantity,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => VehicleInfo(
        type: json['type'] as String,
        plate: json['plate'] as String,
        quantity: json['quantity'] as int? ?? 1,
      );

  final String type;
  final String plate;
  final int quantity;

  Map<String, dynamic> toJson() => {
        'type': type,
        'plate': plate,
        'quantity': quantity,
      };
}

abstract class RentalRequestEntity {
  RentalRequestEntity({
    required this.id,
    required this.tenantId,
    required this.roomId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.memberInfo = const [],
    this.parkingInfo = const [],
  });

  final String id;
  final String tenantId;
  final String roomId;
  final String? note;
  final List<MemberInfo> memberInfo;
  final List<VehicleInfo> parkingInfo;
  final RentalRequestStatus status;
  final String createdAt;
  final String updatedAt;
}
