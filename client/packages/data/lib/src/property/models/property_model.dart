import 'package:domain/property.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel extends PropertyEntity {
  factory PropertyModel.fromJson(Map<String, dynamic> json) => _$PropertyModelFromJson(json);

  PropertyModel({
    required super.id,
    required super.landlorerId,
    required super.name,
    required super.address,
    required super.ward,
    required super.district,
    required super.city,
    required super.description,
    required super.amenityCodes,
    required super.createdAt,
    required super.updatedAt,
  });
}
