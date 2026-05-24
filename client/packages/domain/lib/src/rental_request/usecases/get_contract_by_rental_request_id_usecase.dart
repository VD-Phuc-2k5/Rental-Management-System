import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetContractByRentalRequestIdParams extends Equatable {
  const GetContractByRentalRequestIdParams({required this.rentalRequestId});

  final String rentalRequestId;

  @override
  List<Object> get props => [rentalRequestId];
}

class GetContractByRentalRequestIdUsecase
    implements UseCase<ContractEntity, GetContractByRentalRequestIdParams> {
  GetContractByRentalRequestIdUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, ContractEntity>> call(
    GetContractByRentalRequestIdParams params,
  ) {
    return _repo.getContractByRentalRequestId(
      rentalRequestId: params.rentalRequestId,
    );
  }
}
