abstract class ProfileEntity {
  ProfileEntity({
    required this.fullName,
    required this.phone,
    this.avatarUrl,
  });

  final String fullName;
  final String phone;
  final String? avatarUrl;
}
