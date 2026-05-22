class RoomImageEntity {
  const RoomImageEntity({
    required this.id,
    required this.url,
    required this.sortOrder,
  });

  final String id;
  final String url;
  final int sortOrder;
}
