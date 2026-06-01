import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../property.dart';

class GetPropertyByIdParams extends Equatable {
  const GetPropertyByIdParams({required this.id});
  final String id;
  @override
  List<Object> get props => [id];
}

class GetPropertyByIdUsecase implements UseCase<PropertyEntity, GetPropertyByIdParams> {
  GetPropertyByIdUsecase({required PropertyRepository propertyRepository})
      : _propertyRepository = propertyRepository;

  final PropertyRepository _propertyRepository;

  @override
  Future<Either<Failure, PropertyEntity>> call(GetPropertyByIdParams params) async {
    return _propertyRepository.getPropertyById(id: params.id);
  }
}
