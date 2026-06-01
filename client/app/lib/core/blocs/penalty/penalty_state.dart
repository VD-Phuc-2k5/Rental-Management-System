import 'package:equatable/equatable.dart';

abstract class PenaltyState extends Equatable {
  const PenaltyState();
  @override
  List<Object> get props => [];
}

class PenaltyInitial extends PenaltyState {}

class PenaltyLoading extends PenaltyState {}

class PenaltySuccess extends PenaltyState {}

class PenaltyFailure extends PenaltyState {
  const PenaltyFailure(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
