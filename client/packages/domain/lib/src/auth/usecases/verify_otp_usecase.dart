import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../auth.dart';

class VerifyOtpUsecasePrams extends Equatable {
  const VerifyOtpUsecasePrams({required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  List<Object> get props => [email, otp];
}

class VerifyOtpUsecase implements UseCase<void, VerifyOtpUsecasePrams> {
  VerifyOtpUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(VerifyOtpUsecasePrams params) async {
    return await _authRepository.verifyOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}
