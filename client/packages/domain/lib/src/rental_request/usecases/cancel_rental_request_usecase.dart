import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class CancelRentalRequestParams extends Equatable {
  const CancelRentalRequestParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class CancelRentalRequestUsecase
    implements UseCase<void, CancelRentalRequestParams> {
  CancelRentalRequestUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(CancelRentalRequestParams params) {
    return _repo.cancelRentalRequest(id: params.id);
  }
}
