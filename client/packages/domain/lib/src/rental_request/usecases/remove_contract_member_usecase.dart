import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class RemoveContractMemberParams extends Equatable {
  const RemoveContractMemberParams({
    required this.contractId,
    required this.memberId,
  });

  final String contractId;
  final String memberId;

  @override
  List<Object?> get props => [contractId, memberId];
}

class RemoveContractMemberUsecase
    implements UseCase<void, RemoveContractMemberParams> {
  RemoveContractMemberUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, void>> call(RemoveContractMemberParams params) {
    return _repo.removeContractMember(
      contractId: params.contractId,
      memberId: params.memberId,
    );
  }
}
