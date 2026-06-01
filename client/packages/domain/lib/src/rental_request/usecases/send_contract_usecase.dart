import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class SendContractParams extends Equatable {
  const SendContractParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class SendContractUsecase implements UseCase<void, SendContractParams> {
  SendContractUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(SendContractParams params) {
    return _repo.sendContract(id: params.id);
  }
}
