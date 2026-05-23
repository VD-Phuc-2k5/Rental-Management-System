part of 'create_rental_request_bloc.dart';

sealed class CreateRentalRequestEvent {}

class CreateRentalRequestSubmitted extends CreateRentalRequestEvent {
  CreateRentalRequestSubmitted({
    required this.roomId,
    this.note,
    this.memberInfo = const [],
    this.parkingInfo = const [],
  });
  final String roomId;
  final String? note;
  final List<MemberInfo> memberInfo;
  final List<VehicleInfo> parkingInfo;
}
