import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../property.dart';

class DeletePropertyParams extends Equatable {
  const DeletePropertyParams({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}

class DeletePropertyUsecase implements UseCase<void, DeletePropertyParams> {
  DeletePropertyUsecase({required PropertyRepository propertyRepository})
      : _propertyRepository = propertyRepository;

  final PropertyRepository _propertyRepository;

  @override
  Future<Either<Failure, void>> call(DeletePropertyParams params) async {
    return _propertyRepository.deleteProperty(id: params.id);
  }
}
