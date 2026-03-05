import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

import 'section_header.dart';

class AmenitiesSection extends StatefulWidget {
  final Set<String> initialSelectedAmenities;

  const AmenitiesSection({
    super.key,
    this.initialSelectedAmenities = const {},
  });

  @override
  State<AmenitiesSection> createState() => _AmenitiesSectionState();
}

class _AmenitiesSectionState extends State<AmenitiesSection> {
  late final Set<String> _selectedAmenities;

  final List<Map<String, dynamic>> _amenitiesList = [
    {"label": "Wifi", "icon": Icons.wifi},
    {"label": "Điều hòa", "icon": Icons.ac_unit},
    {"label": "Bãi đỗ xe", "icon": Icons.local_parking},
    {"label": "Bình nóng lạnh", "icon": Icons.water_drop_outlined},
    {"label": "Giờ giấc tự do", "icon": Icons.access_time},
    {"label": "Không chung chủ", "icon": Icons.key_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _selectedAmenities = Set.from(widget.initialSelectedAmenities);
  }

  Widget _buildAmenityChip(String label, IconData icon) {
    final isSelected = _selectedAmenities.contains(label);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAmenities.remove(label);
          } else {
            _selectedAmenities.add(label);
          }
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue700 : AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.blue700 : AppColors.slate200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.white : AppColors.slate600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: "Noto Sans",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isSelected ? AppColors.white : AppColors.slate600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Tiện ích", icon: Icons.info_outline),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _amenitiesList
              .map(
                (amenity) =>
                    _buildAmenityChip(amenity["label"], amenity["icon"]),
              )
              .toList(),
        ),
      ],
    );
  }
}
