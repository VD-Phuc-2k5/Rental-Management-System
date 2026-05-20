import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:domain/property.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/sealed_class_state.dart';

part 'delete_property_event.dart';
part 'delete_property_state.dart';

@injectable
class DeletePropertyBloc extends Bloc<DeletePropertyEvent, DeletePropertyState> {
  DeletePropertyBloc({required DeletePropertyUsecase deletePropertyUsecase})
      : _deletePropertyUsecase = deletePropertyUsecase,
        super(const DeletePropertyInitial()) {
    on<DeletePropertySubmitted>(_onSubmitted);
  }

  final DeletePropertyUsecase _deletePropertyUsecase;

  Future<void> _onSubmitted(DeletePropertySubmitted event, Emitter<DeletePropertyState> emit) async {
    emit(const DeletePropertyLoadInProgress());
    final result = await _deletePropertyUsecase(DeletePropertyParams(id: event.id));
    result.fold(
      (failure) => emit(DeletePropertyLoadFailure(failure: failure)),
      (_) => emit(const DeletePropertyLoadSuccess(data: null)),
    );
  }
}
