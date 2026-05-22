part of 'create_rental_request_bloc.dart';

sealed class CreateRentalRequestEvent {}

class CreateRentalRequestSubmitted extends CreateRentalRequestEvent {
  CreateRentalRequestSubmitted({required this.roomId, this.note});
  final String roomId;
  final String? note;
}
