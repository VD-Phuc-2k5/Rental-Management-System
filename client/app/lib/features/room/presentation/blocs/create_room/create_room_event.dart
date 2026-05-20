part of 'create_room_bloc.dart';
sealed class CreateRoomEvent {}
class CreateRoomSubmitted extends CreateRoomEvent {
  CreateRoomSubmitted({
    required this.propertyId,
    required this.title,
    required this.areaSqm,
    required this.monthlyRent,
    required this.depositAmount,
    required this.electricityRatePerKwh,
    required this.waterRatePerM3,
    required this.hasFurniture,
    this.description,
  });
  final String propertyId;
  final String title;
  final double areaSqm;
  final double monthlyRent;
  final double depositAmount;
  final double electricityRatePerKwh;
  final double waterRatePerM3;
  final bool hasFurniture;
  final String? description;
}
