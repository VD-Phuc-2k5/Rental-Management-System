import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetMyContractsUsecase
    implements UseCase<List<ContractEntity>, NoParams> {
  GetMyContractsUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, List<ContractEntity>>> call(NoParams params) {
    return _repo.getMyContracts();
  }
}
