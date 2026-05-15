import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../auth.dart';

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [email, otp, newPassword, confirmPassword];
}

class ResetPasswordUsecase implements UseCase<void, ResetPasswordParams> {
  ResetPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await _authRepository.resetPassword(
      email: params.email,
      otp: params.otp,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}
