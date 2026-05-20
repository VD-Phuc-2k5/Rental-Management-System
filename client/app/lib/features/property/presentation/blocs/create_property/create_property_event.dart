part of 'create_property_bloc.dart';
sealed class CreatePropertyEvent extends Equatable { const CreatePropertyEvent(); @override List<Object> get props => []; }
final class CreatePropertySubmitted extends CreatePropertyEvent {
  const CreatePropertySubmitted({
    required this.name, required this.address, required this.ward,
    required this.district, required this.city, required this.description,
    required this.amenityCodes,
  });
  final String name, address, ward, district, city, description;
  final List<String> amenityCodes;
  @override List<Object> get props => [name, address, ward, district, city, description, amenityCodes];
}
