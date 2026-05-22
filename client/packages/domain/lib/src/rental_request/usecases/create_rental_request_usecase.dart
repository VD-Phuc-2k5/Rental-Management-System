import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class CreateRentalRequestParams extends Equatable {
  const CreateRentalRequestParams({required this.roomId, this.note});

  final String roomId;
  final String? note;

  @override
  List<Object?> get props => [roomId, note];
}

class CreateRentalRequestUsecase
    implements UseCase<RentalRequestEntity, CreateRentalRequestParams> {
  CreateRentalRequestUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, RentalRequestEntity>> call(
    CreateRentalRequestParams params,
  ) {
    return _repo.createRentalRequest(
      roomId: params.roomId,
      note: params.note,
    );
  }
}
