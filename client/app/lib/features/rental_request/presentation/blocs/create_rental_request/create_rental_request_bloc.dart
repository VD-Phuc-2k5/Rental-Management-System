import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/rental_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/utils/sealed_class_state.dart';

part 'create_rental_request_event.dart';
part 'create_rental_request_state.dart';

@injectable
class CreateRentalRequestBloc
    extends Bloc<CreateRentalRequestEvent, CreateRentalRequestState> {
  CreateRentalRequestBloc(
      {required CreateRentalRequestUsecase createRentalRequestUsecase})
      : _usecase = createRentalRequestUsecase,
        super(const CreateRentalRequestInitial()) {
    on<CreateRentalRequestSubmitted>(_onSubmitted);
  }

  final CreateRentalRequestUsecase _usecase;

  Future<void> _onSubmitted(
    CreateRentalRequestSubmitted event,
    Emitter<CreateRentalRequestState> emit,
  ) async {
    emit(const CreateRentalRequestLoadInProgress());
    final result = await _usecase(
      CreateRentalRequestParams(roomId: event.roomId, note: event.note),
    );
    result.fold(
      (failure) => emit(CreateRentalRequestLoadFailure(failure: failure)),
      (data) => emit(CreateRentalRequestLoadSuccess(data: data)),
    );
  }
}
