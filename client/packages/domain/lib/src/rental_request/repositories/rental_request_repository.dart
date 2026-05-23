import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../rental_request.dart';

abstract interface class RentalRequestRepository {
  Future<Either<Failure, RentalRequestEntity>> createRentalRequest({
    required String roomId,
    String? note,
    List<MemberInfo> memberInfo,
    List<VehicleInfo> parkingInfo,
  });

  Future<Either<Failure, List<RentalRequestEntity>>> getMyRentalRequests();

  Future<Either<Failure, List<RentalRequestEntity>>> getIncomingRequests();

  Future<Either<Failure, void>> cancelRentalRequest({required String id});

  Future<Either<Failure, void>> rejectRentalRequest({required String id});

  Future<Either<Failure, List<ContractEntity>>> getMyContracts();

  Future<Either<Failure, List<ContractEntity>>> getLandlordContracts();

  Future<Either<Failure, ContractEntity>> getContractDetail({required String id});

  Future<Either<Failure, ContractEntity>> updateContract({
    required String id,
    String? startDate,
    String? endDate,
    double? monthlyRent,
    double? deposit,
    String? terms,
  });

  Future<Either<Failure, void>> sendContract({required String id});

  Future<Either<Failure, void>> signContract({required String id});

  Future<Either<Failure, void>> cancelContract({required String id});

  Future<Either<Failure, void>> finishContract({required String id});

  Future<Either<Failure, List<ContractMemberEntity>>> getContractMembers({
    required String contractId,
  });

  Future<Either<Failure, void>> removeContractMember({
    required String contractId,
    required String memberId,
  });
}
