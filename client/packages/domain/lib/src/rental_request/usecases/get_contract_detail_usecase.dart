import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetContractDetailParams extends Equatable {
  const GetContractDetailParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class GetContractDetailUsecase
    implements UseCase<ContractEntity, GetContractDetailParams> {
  GetContractDetailUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, ContractEntity>> call(
    GetContractDetailParams params,
  ) {
    return _repo.getContractDetail(id: params.id);
  }
}
