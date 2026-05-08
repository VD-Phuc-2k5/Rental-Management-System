import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required ForgotPasswordUsecase forgotPasswordUsecase})
    : _forgotPasswordUsecase = forgotPasswordUsecase,
      super(const ForgotPasswordInitial()) {
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  final ForgotPasswordUsecase _forgotPasswordUsecase;

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordLoadInProgress());

    final result = await _forgotPasswordUsecase(
      ForgotPasswordParams(
        email: event.email,
      ),
    );

    result.fold(
      (failure) => emit(ForgotPasswordLoadFailure(failure: failure)),
      (_) => emit(const ForgotPasswordLoadSuccess(data: null)),
    );
  }
}
