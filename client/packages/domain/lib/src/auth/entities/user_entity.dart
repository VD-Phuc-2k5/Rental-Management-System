abstract class UserEntity {
  UserEntity({
    required this.id,
    this.email,
    required this.role,
    this.phone,
    this.fullName,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    this.acceptedTerms,
  });

  final String id;
  final String? email;
  final dynamic role;
  final String? phone;
  final String? fullName;
  final String? avatarUrl;
  final String? createdAt;
  final String? updatedAt;
  final bool? acceptedTerms;
}
