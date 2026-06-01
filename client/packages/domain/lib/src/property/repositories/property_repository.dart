import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../../../property.dart';

abstract interface class PropertyRepository {
  Future<Either<Failure, List<PropertyEntity>>> getProperties();
  Future<Either<Failure, PropertyEntity>> getPropertyById({required String id});
  Future<Either<Failure, PropertyEntity>> createProperty({
    required String name,
    required String address,
    required String ward,
    required String district,
    required String city,
    required String description,
    required List<String> amenityCodes,
  });
  Future<Either<Failure, PropertyEntity>> updateProperty({
    required String id,
    String? name,
    String? address,
    String? ward,
    String? district,
    String? city,
    String? description,
    List<String>? amenityCodes,
  });
  Future<Either<Failure, void>> deleteProperty({required String id});
}
