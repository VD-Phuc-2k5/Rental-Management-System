part of 'update_room_bloc.dart';

sealed class UpdateRoomEvent {}

class UpdateRoomSubmitted extends UpdateRoomEvent {
  UpdateRoomSubmitted({
    required this.id,
    this.title,
    this.status,
    this.areaSqm,
    this.monthlyRent,
    this.depositAmount,
    this.electricityRatePerKwh,
    this.waterRatePerM3,
    this.hasFurniture,
    this.description,
  });
  final String id;
  final String? title;
  final RoomStatus? status;
  final double? areaSqm;
  final double? monthlyRent;
  final double? depositAmount;
  final double? electricityRatePerKwh;
  final double? waterRatePerM3;
  final bool? hasFurniture;
  final String? description;
}
