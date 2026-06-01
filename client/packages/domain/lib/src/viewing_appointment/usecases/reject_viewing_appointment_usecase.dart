import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../viewing_appointment.dart';

class RejectViewingAppointmentParams extends Equatable {
  const RejectViewingAppointmentParams({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

class RejectViewingAppointmentUsecase
    implements UseCase<ViewingAppointmentEntity, RejectViewingAppointmentParams> {
  RejectViewingAppointmentUsecase({required ViewingAppointmentRepository repo})
      : _repo = repo;

  final ViewingAppointmentRepository _repo;

  @override
  Future<Either<Failure, ViewingAppointmentEntity>> call(
    RejectViewingAppointmentParams params,
  ) {
    return _repo.rejectViewingAppointment(id: params.id);
  }
}
