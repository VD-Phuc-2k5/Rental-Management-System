import 'package:data/property.dart';

abstract interface class PropertyRemoteDataSource {
  Future<List<PropertyModel>> getProperties({required String token});
  Future<PropertyModel> getPropertyById({required String id, required String token});
  Future<PropertyModel> createProperty({
    required String token,
    required String name,
    required String address,
    required String ward,
    required String district,
    required String city,
    required String description,
    required List<String> amenityCodes,
  });
  Future<PropertyModel> updateProperty({
    required String id,
    required String token,
    String? name,
    String? address,
    String? ward,
    String? district,
    String? city,
    String? description,
    List<String>? amenityCodes,
  });
  Future<void> deleteProperty({required String id, required String token});
}
