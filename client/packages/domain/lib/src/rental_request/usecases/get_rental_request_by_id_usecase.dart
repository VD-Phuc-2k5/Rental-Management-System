import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class GetRentalRequestByIdParams extends Equatable {
  const GetRentalRequestByIdParams({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class GetRentalRequestByIdUsecase
    implements UseCase<RentalRequestEntity, GetRentalRequestByIdParams> {
  GetRentalRequestByIdUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, RentalRequestEntity>> call(
    GetRentalRequestByIdParams params,
  ) {
    return _repo.getRentalRequestById(id: params.id);
  }
}
