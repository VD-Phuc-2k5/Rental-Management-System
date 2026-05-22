import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class UpdateContractParams extends Equatable {
  const UpdateContractParams({
    required this.id,
    this.startDate,
    this.endDate,
    this.monthlyRent,
    this.deposit,
    this.terms,
  });

  final String id;
  final String? startDate;
  final String? endDate;
  final double? monthlyRent;
  final double? deposit;
  final String? terms;

  @override
  List<Object?> get props => [id, startDate, endDate, monthlyRent, deposit, terms];
}

class UpdateContractUsecase
    implements UseCase<ContractEntity, UpdateContractParams> {
  UpdateContractUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, ContractEntity>> call(UpdateContractParams params) {
    return _repo.updateContract(
      id: params.id,
      startDate: params.startDate,
      endDate: params.endDate,
      monthlyRent: params.monthlyRent,
      deposit: params.deposit,
      terms: params.terms,
    );
  }
}
