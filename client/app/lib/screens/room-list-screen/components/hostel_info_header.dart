import 'package:app/core/constants.dart';
import 'package:app/screens/add-electric-water-screen/add_electric_water_screen.dart';
import 'package:flutter/material.dart';

class HostelInfoHeader extends StatelessWidget {
  const HostelInfoHeader({super.key});

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.blue700),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: AppColors.blue700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.blue700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const Text(
                  "123 Nguyễn Trãi, Phường 2, Quận 5, TP. Hồ Chí Minh",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.slate500,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Khu trọ cao cấp, giờ giấc tự do, an ninh đảm bảo 24/7 với camera giám sát và khóa vân tay hiện đại...",
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.slate500,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildAmenityChip(Icons.wifi, "Wifi miễn phí"),
              _buildAmenityChip(Icons.motorcycle_outlined, "Giữ xe"),
              _buildAmenityChip(Icons.security, "An ninh 24/7"),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue700,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddElectricWaterScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.upload_file_outlined,
                color: AppColors.white,
                size: 16,
              ),
              label: const Text(
                "Nhập chỉ số điện – nước",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
