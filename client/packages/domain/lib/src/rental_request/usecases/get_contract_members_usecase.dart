import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetContractMembersParams extends Equatable {
  const GetContractMembersParams({required this.contractId});

  final String contractId;

  @override
  List<Object?> get props => [contractId];
}

class GetContractMembersUsecase
    implements UseCase<List<ContractMemberEntity>, GetContractMembersParams> {
  GetContractMembersUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, List<ContractMemberEntity>>> call(
    GetContractMembersParams params,
  ) {
    return _repo.getContractMembers(contractId: params.contractId);
  }
}
