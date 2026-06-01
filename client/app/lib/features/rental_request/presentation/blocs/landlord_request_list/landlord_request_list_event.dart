part of 'landlord_request_list_bloc.dart';

sealed class LandlordRequestListEvent {}

class LandlordRequestListFetched extends LandlordRequestListEvent {}

class LandlordRequestListRejected extends LandlordRequestListEvent {
  LandlordRequestListRejected({required this.id});
  final String id;
}
