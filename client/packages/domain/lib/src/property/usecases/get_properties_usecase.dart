import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../property.dart';

class GetPropertiesUsecase implements UseCase<List<PropertyEntity>, NoParams> {
  GetPropertiesUsecase({required PropertyRepository propertyRepository})
      : _propertyRepository = propertyRepository;

  final PropertyRepository _propertyRepository;

  @override
  Future<Either<Failure, List<PropertyEntity>>> call(NoParams params) async {
    return _propertyRepository.getProperties();
  }
}
