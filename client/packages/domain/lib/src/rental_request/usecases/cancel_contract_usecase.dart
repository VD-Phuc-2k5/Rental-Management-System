import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class CancelContractParams extends Equatable {
  const CancelContractParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class CancelContractUsecase implements UseCase<void, CancelContractParams> {
  CancelContractUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(CancelContractParams params) {
    return _repo.cancelContract(id: params.id);
  }
}
