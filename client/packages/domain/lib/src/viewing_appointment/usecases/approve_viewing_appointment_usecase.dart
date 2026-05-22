import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../viewing_appointment.dart';

class ApproveViewingAppointmentParams extends Equatable {
  const ApproveViewingAppointmentParams({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

class ApproveViewingAppointmentUsecase
    implements UseCase<ViewingAppointmentEntity, ApproveViewingAppointmentParams> {
  ApproveViewingAppointmentUsecase({required ViewingAppointmentRepository repo})
      : _repo = repo;

  final ViewingAppointmentRepository _repo;

  @override
  Future<Either<Failure, ViewingAppointmentEntity>> call(
    ApproveViewingAppointmentParams params,
  ) {
    return _repo.approveViewingAppointment(id: params.id);
  }
}
