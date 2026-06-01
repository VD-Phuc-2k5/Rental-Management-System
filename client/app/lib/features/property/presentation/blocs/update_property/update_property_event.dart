part of 'update_property_bloc.dart';

sealed class UpdatePropertyEvent extends Equatable {
  const UpdatePropertyEvent();
  @override
  List<Object?> get props => [];
}

final class UpdatePropertySubmitted extends UpdatePropertyEvent {
  const UpdatePropertySubmitted({
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
  final String? name, address, ward, district, city, description;
  final List<String>? amenityCodes;
  @override
  List<Object?> get props => [
    id,
    name,
    address,
    ward,
    district,
    city,
    description,
    amenityCodes,
  ];
}
