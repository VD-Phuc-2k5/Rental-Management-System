import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/errors.dart'; // Đổi lại đúng đường dẫn file errors của core nếu team dùng khác

import '../../../rental_request.dart';
import 'package:core/usecase.dart'; // Đổi lại đúng đường dẫn usecase của team

class CreatePenaltyParams extends Equatable {
  const CreatePenaltyParams({
    required this.contractId,
    required this.tenantId,
    required this.roomId,
    required this.amount,
    required this.reason,
  });

  final String contractId;
  final String tenantId;
  final String roomId;
  final double amount;
  final String reason;

  @override
  List<Object> get props => [contractId, tenantId, roomId, amount, reason];
}

@lazySingleton
class CreatePenaltyUsecase
    implements UseCase<PenaltyEntity, CreatePenaltyParams> {
  CreatePenaltyUsecase({required RentalRequestRepository repository})
    : _repo = repository;
  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, PenaltyEntity>> call(CreatePenaltyParams params) {
    return _repo.createPenalty(
      contractId: params.contractId,
      tenantId: params.tenantId,
      roomId: params.roomId,
      amount: params.amount,
      reason: params.reason,
    );
  }
}

class GetPenaltiesParams extends Equatable {
  const GetPenaltiesParams({required this.contractId});
  final String contractId;

  @override
  List<Object> get props => [contractId];
}

@lazySingleton
class GetPenaltiesUsecase
    implements UseCase<List<PenaltyEntity>, GetPenaltiesParams> {
  GetPenaltiesUsecase({required RentalRequestRepository repository})
    : _repo = repository;
  final RentalRequestRepository _repo;

  @override
  Future<Either<Failure, List<PenaltyEntity>>> call(GetPenaltiesParams params) {
    return _repo.getPenalties(contractId: params.contractId);
  }
}
