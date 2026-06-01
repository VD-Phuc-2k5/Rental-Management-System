// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] as String,
      landlorerId: json['landlorerId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      ward: json['ward'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      description: json['description'] as String,
      amenityCodes: (json['amenityCodes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landlorerId': instance.landlorerId,
      'name': instance.name,
      'address': instance.address,
      'ward': instance.ward,
      'district': instance.district,
      'city': instance.city,
      'description': instance.description,
      'amenityCodes': instance.amenityCodes,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
