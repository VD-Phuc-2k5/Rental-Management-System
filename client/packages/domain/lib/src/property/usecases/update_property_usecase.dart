import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../property.dart';

class UpdatePropertyParams extends Equatable {
  const UpdatePropertyParams({
    required this.id,
    this.name,
    this.address,
    this.ward,
    this.district,
    this.city,
    this.description,
    this.amenityCodes,
  });

  final String id;
  final String? name;
  final String? address;
  final String? ward;
  final String? district;
  final String? city;
  final String? description;
  final List<String>? amenityCodes;

  @override
  List<Object?> get props => [id, name, address, ward, district, city, description, amenityCodes];
}

class UpdatePropertyUsecase implements UseCase<PropertyEntity, UpdatePropertyParams> {
  UpdatePropertyUsecase({required PropertyRepository propertyRepository})
      : _propertyRepository = propertyRepository;

  final PropertyRepository _propertyRepository;

  @override
  Future<Either<Failure, PropertyEntity>> call(UpdatePropertyParams params) async {
    return _propertyRepository.updateProperty(
      id: params.id,
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
