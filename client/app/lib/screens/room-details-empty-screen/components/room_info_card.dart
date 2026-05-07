import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class RoomInfoCard extends StatelessWidget {
  final String roomNumber;

  const RoomInfoCard({super.key, required this.roomNumber});

  Widget _buildUtilityItem(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.slate500),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
                child: Image.asset(
                  'assets/images/room-details-empty-screen/room_img1.png',
                  width: double.infinity,
                  height: 192,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 192,
                    color: AppColors.slate200,
                    child: const Icon(Icons.image, color: AppColors.slate400),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(153),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.white,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "5 ảnh",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phòng $roomNumber",
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.slate900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Tầng 3 - Tòa nhà Landmark",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          "3.500.000đ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.blue700,
                          ),
                        ),
                        Text(
                          "/tháng",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: const [
                    Icon(Icons.bolt, size: 16, color: AppColors.blue700),
                    SizedBox(width: 4),
                    Text(
                      "Điện: 3.500đ/kWh",
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 15,
                        color: AppColors.slate900,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.water_drop_outlined,
                      size: 16,
                      color: AppColors.blue700,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Nước: 25.000đ/m3",
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 15,
                        color: AppColors.slate900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildUtilityItem(Icons.square_foot, "25 m²"),
                    const SizedBox(width: 8),
                    _buildUtilityItem(Icons.bed_outlined, "Gác xép"),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildUtilityItem(Icons.ac_unit, "Điều hòa"),
                    const SizedBox(width: 8),
                    _buildUtilityItem(Icons.water_damage_outlined, "Nóng lạnh"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
