import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class FinishContractParams extends Equatable {
  const FinishContractParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class FinishContractUsecase implements UseCase<void, FinishContractParams> {
  FinishContractUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(FinishContractParams params) {
    return _repo.finishContract(id: params.id);
  }
}
