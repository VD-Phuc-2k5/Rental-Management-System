class RoomAddonAmenity {
  const RoomAddonAmenity({required this.code, required this.monthlyPrice});

  final String code;
  final double monthlyPrice;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomAddonAmenity &&
          other.code == code &&
          other.monthlyPrice == monthlyPrice;

  @override
  int get hashCode => Object.hash(code, monthlyPrice);
}
