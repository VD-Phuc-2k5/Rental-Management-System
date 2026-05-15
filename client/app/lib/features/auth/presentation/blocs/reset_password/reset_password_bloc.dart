import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required ResetPasswordUsecase resetPasswordUsecase,
    required this.email,
    required this.otp,
  }) : _resetPasswordUsecase = resetPasswordUsecase,
       super(const ResetPasswordInitial()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  final ResetPasswordUsecase _resetPasswordUsecase;
  final String email;
  final String otp;

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(const ResetPasswordLoadInProgress());

    final result = await _resetPasswordUsecase(
      ResetPasswordParams(
        email: email,
        otp: otp,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
      (failure) => emit(ResetPasswordLoadFailure(failure: failure)),
      (_) => emit(const ResetPasswordLoadSuccess(data: null)),
    );
  }
}
