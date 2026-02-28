import 'package:app/core/constants.dart';
import 'package:app/core/format_currency.dart';
import 'package:flutter/material.dart';

class RoomInfoSection extends StatelessWidget {
  final double electricPrice;
  final double waterPrice;
  final String address;
  final double area;
  final int bedrooms;
  final bool hasFurniture;

  const RoomInfoSection({
    super.key,
    required this.electricPrice,
    required this.waterPrice,
    required this.address,
    required this.area,
    required this.bedrooms,
    this.hasFurniture = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 152),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt_outlined,
                size: 20,
                color: AppColors.blue700,
              ),
              const SizedBox(width: 8),
              Text(
                'Điện: ${formatVND(electricPrice.toInt())}/kWh',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 24),
              Icon(
                Icons.water_drop_outlined,
                size: 20,
                color: AppColors.blue700,
              ),
              const SizedBox(width: 8),
              Text(
                'Nước: ${formatVND(waterPrice.toInt())}/m3',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.slate100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: AppColors.blue700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.slate500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildFeature(
                Icons.square_foot_outlined,
                '${area.toInt()}m²',
              ),
              _buildFeature(
                Icons.bed_outlined,
                '$bedrooms phòng ngủ',
              ),
              if (hasFurniture)
                _buildFeature(
                  Icons.weekend_outlined,
                  'Có nội thất',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.blue700,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.blue700,
            ),
          ),
        ],
      ),
    );
  }
}
