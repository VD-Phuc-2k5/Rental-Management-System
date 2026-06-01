class RoomMember {

  const RoomMember({
    required this.id,
    required this.name,
    this.role = 'Thành viên',
    this.avatarUrl,
  });
  final String id;
  final String name;
  final String role;
  final String? avatarUrl;
}
