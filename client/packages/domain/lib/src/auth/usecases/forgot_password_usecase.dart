import 'package:core/src/errors/failures.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import '../../../auth.dart';

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class ForgotPasswordUsecase implements UseCase<void, ForgotPasswordParams> {
  ForgotPasswordUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await _authRepository.forgotPassword(email: params.email);
  }
}
