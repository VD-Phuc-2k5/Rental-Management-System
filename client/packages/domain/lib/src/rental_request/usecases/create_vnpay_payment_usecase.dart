import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

class CreateVnpayPaymentParams extends Equatable {
  const CreateVnpayPaymentParams({required this.contractId});

  final String contractId;

  @override
  List<Object> get props => [contractId];
}

class CreateVnpayPaymentUsecase
    implements UseCase<VnpayPaymentEntity, CreateVnpayPaymentParams> {
  CreateVnpayPaymentUsecase({
    required RentalRequestRepository rentalRequestRepository,
  }) : _repo = rentalRequestRepository;

  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, VnpayPaymentEntity>> call(
    CreateVnpayPaymentParams params,
  ) {
    return _repo.createVnpayDepositPayment(contractId: params.contractId);
  }
}
