part of 'delete_property_bloc.dart';

sealed class DeletePropertyEvent extends Equatable {
  const DeletePropertyEvent();
  @override
  List<Object> get props => [];
}

final class DeletePropertySubmitted extends DeletePropertyEvent {
  const DeletePropertySubmitted({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}
