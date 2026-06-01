import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../property.dart';

class CreatePropertyParams extends Equatable {
  const CreatePropertyParams({
    required this.name,
    required this.address,
    required this.ward,
    required this.district,
    required this.city,
    required this.description,
    required this.amenityCodes,
  });

  final String name;
  final String address;
  final String ward;
  final String district;
  final String city;
  final String description;
  final List<String> amenityCodes;

  @override
  List<Object> get props => [name, address, ward, district, city, description, amenityCodes];
}

class CreatePropertyUsecase implements UseCase<PropertyEntity, CreatePropertyParams> {
  CreatePropertyUsecase({required PropertyRepository propertyRepository})
      : _propertyRepository = propertyRepository;

  final PropertyRepository _propertyRepository;

  @override
  Future<Either<Failure, PropertyEntity>> call(CreatePropertyParams params) async {
    return _propertyRepository.createProperty(
      name: params.name,
      address: params.address,
      ward: params.ward,
      district: params.district,
      city: params.city,
      description: params.description,
      amenityCodes: params.amenityCodes,
    );
  }
}
