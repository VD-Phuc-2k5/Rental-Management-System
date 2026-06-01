import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetLandlordContractsUsecase
    implements UseCase<List<ContractEntity>, NoParams> {
  GetLandlordContractsUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, List<ContractEntity>>> call(NoParams params) {
    return _repo.getLandlordContracts();
  }
}
