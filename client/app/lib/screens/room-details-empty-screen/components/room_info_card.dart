import 'package:flutter/material.dart';
import 'package:domain/room.dart';

// Import theo đúng cây thư mục hiện tại của bạn
import '../../../core/constants.dart';
import '../../../core/format_currency.dart';

class RoomInfoCard extends StatelessWidget {
  const RoomInfoCard({
    super.key,
    required this.room,
    required this.propertyName,
  });

  final RoomEntity room;
  final String propertyName;

  @override
  Widget build(BuildContext context) {
    final imageUrl = room.images.isNotEmpty ? room.images.first.url : null;

    // TỰ ĐỘNG NỘI SUY: Kiểm tra xem mảng tiện ích có chứa các món đồ cơ bản không
    final hasFurniture = room.includedAmenityCodes.any(
            (code) => ['BED', 'WARDROBE', 'TABLE_CHAIR', 'FRIDGE', 'AC', 'AIR_CONDITIONER'].contains(code)
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0), // Chỉnh lại bo góc đều 4 cạnh cho đẹp
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(25),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              width: double.infinity,
              height: 192,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
            )
                : _buildPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phòng ${room.title} - $propertyName",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.blue950,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, color: AppColors.blue700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "${formatCurrency(room.monthlyRent)} / Tháng",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.blue700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.straighten, color: AppColors.slate500, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Diện tích: ${room.areaSqm} m²",
                      style: const TextStyle(color: AppColors.slate700, fontSize: 14),
                    ),
                    const SizedBox(width: 24),
                    const Icon(Icons.weekend_outlined, color: AppColors.slate500, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      hasFurniture ? "Có nội thất" : "Phòng trống",
                      style: const TextStyle(color: AppColors.slate700, fontSize: 14),
                    ),
                  ],
                ),
                if (room.includedAmenityCodes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "Tiện ích đi kèm:",
                    style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.slate900),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.includedAmenityCodes.map((code) => _buildAmenityBadge(code)).toList(),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 192,
      color: AppColors.slate200,
      width: double.infinity,
      child: const Icon(Icons.image_outlined, color: AppColors.slate400, size: 48),
    );
  }

  Widget _buildAmenityBadge(String code) {
    String label = code;
    switch (code) {
      case 'WIFI': label = 'Wi-Fi'; break;
      case 'AC': case 'AIR_CONDITIONER': label = 'Điều hòa'; break;
      case 'WATER_HEATER': label = 'Nóng lạnh'; break;
      case 'BED': label = 'Giường'; break;
      case 'FRIDGE': label = 'Tủ lạnh'; break;
      case 'PRIVATE_BATHROOM': label = 'WC riêng'; break;
      case 'PARKING': label = 'Chỗ để xe'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.blue200),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.blue700, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}