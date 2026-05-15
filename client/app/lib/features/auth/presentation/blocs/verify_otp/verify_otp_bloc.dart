import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

@injectable
class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc({
    required VerifyOtpUsecase verifyOtpUsecase,
    required ForgotPasswordUsecase forgotPasswordUsecase,
  })
    : _verifyOtpUsecase = verifyOtpUsecase,
      _forgotPasswordUsecase = forgotPasswordUsecase,
      super(const VerifyOtpInitial()) {
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<AddEmail>((event, emit) {
      email = event.email;
    });
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  final VerifyOtpUsecase _verifyOtpUsecase;
  final ForgotPasswordUsecase _forgotPasswordUsecase;
  String email = '';

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoadInProgress());

    final result = await _verifyOtpUsecase(
      VerifyOtpUsecasePrams(email: email, otp: event.otp),
    );

    result.fold(
      (failure) => emit(VerifyOtpLoadFailure(failure: failure)),
      (_) => emit(const VerifyOtpLoadSuccess(data: null)),
    );
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoadInProgress());

    final result = await _forgotPasswordUsecase(
      ForgotPasswordParams(email: email),
    );

    result.fold(
      (failure) => emit(VerifyOtpLoadFailure(failure: failure)),
      (_) => emit(const VerifyOtpInitial()),
    );
  }
}
