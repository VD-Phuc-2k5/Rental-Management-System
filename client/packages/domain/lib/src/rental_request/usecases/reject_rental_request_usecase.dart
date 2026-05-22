import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class RejectRentalRequestParams extends Equatable {
  const RejectRentalRequestParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class RejectRentalRequestUsecase
    implements UseCase<void, RejectRentalRequestParams> {
  RejectRentalRequestUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(RejectRentalRequestParams params) {
    return _repo.rejectRentalRequest(id: params.id);
  }
}
