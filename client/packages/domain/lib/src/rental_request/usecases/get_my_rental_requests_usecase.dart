import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetMyRentalRequestsUsecase
    implements UseCase<List<RentalRequestEntity>, NoParams> {
  GetMyRentalRequestsUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, List<RentalRequestEntity>>> call(NoParams params) {
    return _repo.getMyRentalRequests();
  }
}
