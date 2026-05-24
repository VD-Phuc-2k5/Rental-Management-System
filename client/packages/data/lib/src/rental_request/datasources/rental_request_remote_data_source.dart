import 'package:domain/rental_request.dart';

import '../models/contract_member_model.dart';
import '../models/contract_model.dart';
import '../models/vnpay_payment_model.dart';
import '../models/rental_request_model.dart';

abstract interface class RentalRequestRemoteDataSource {
  Future<RentalRequestModel> createRentalRequest({
    required String token,
    required String roomId,
    String? note,
    List<MemberInfo> memberInfo,
    List<VehicleInfo> parkingInfo,
  });

  Future<List<RentalRequestModel>> getMyRentalRequests({required String token});

  Future<void> cancelRentalRequest({required String token, required String id});

  Future<List<RentalRequestModel>> getIncomingRequests({required String token});

  Future<void> rejectRentalRequest({required String token, required String id});

  Future<List<ContractModel>> getMyContracts({required String token});

  Future<List<ContractModel>> getLandlordContracts({required String token});

  Future<ContractModel> getContractDetail({
    required String token,
    required String id,
  });

  Future<ContractModel> updateContract({
    required String token,
    required String id,
    String? startDate,
    String? endDate,
    double? monthlyRent,
    double? deposit,
    String? terms,
  });

  Future<void> sendContract({required String token, required String id});

  Future<void> signContract({required String token, required String id});

  Future<void> cancelContract({required String token, required String id});

  Future<void> finishContract({required String token, required String id});

  Future<List<ContractMemberModel>> getContractMembers({
    required String token,
    required String contractId,
  });

  Future<void> removeContractMember({
    required String token,
    required String contractId,
    required String memberId,
  });

  Future<VnpayPaymentModel> createVnpayDepositPayment({
    required String token,
    required String contractId,
  });

  Future<List<ContractModel>> getRoomContracts({
    required String token,
    required String roomId,
  });

  Future<RentalRequestModel> getRentalRequestById({
    required String token,
    required String id,
  });

  Future<ContractModel> getContractByRentalRequestId({
    required String token,
    required String rentalRequestId,
  });
}
