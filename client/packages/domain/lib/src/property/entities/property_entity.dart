abstract class PropertyEntity {
  PropertyEntity({
    required this.id,
    required this.landlorerId,
    required this.name,
    required this.address,
    required this.ward,
    required this.district,
    required this.city,
    required this.description,
    required this.amenityCodes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String landlorerId;
  final String name;
  final String address;
  final String ward;
  final String district;
  final String city;
  final String description;
  final List<String> amenityCodes;
  final String createdAt;
  final String updatedAt;
}
