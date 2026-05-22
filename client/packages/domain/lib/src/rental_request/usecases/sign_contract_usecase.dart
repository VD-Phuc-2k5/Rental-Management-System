import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class SignContractParams extends Equatable {
  const SignContractParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class SignContractUsecase implements UseCase<void, SignContractParams> {
  SignContractUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(SignContractParams params) {
    return _repo.signContract(id: params.id);
  }
}
