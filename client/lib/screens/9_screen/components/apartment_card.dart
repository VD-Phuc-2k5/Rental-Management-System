import 'package:flutter/material.dart';

import 'overlay_chip.dart';
import 'spec_item.dart';

class ApartmentCard extends StatelessWidget {
  const ApartmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/9_screen/apartment.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: OverlayChip(text: 'Căn hộ dịch vụ'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Căn hộ Mini 301',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.location_on_outlined,
                        size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Số 18, Ngõ 86, Phố Chùa Láng, Đống Đa, Hà Nội',
                        style: TextStyle(color: Colors.grey, height: 1.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SpecItem(icon: Icons.square_foot_outlined, text: '35m²'),
                    SizedBox(width: 16),
                    SpecItem(icon: Icons.bed_outlined, text: '1 PN'),
                    SizedBox(width: 16),
                    SpecItem(icon: Icons.bathtub_outlined, text: '1 WC'),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Text('Giá thuê', style: TextStyle(color: Colors.grey)),
                    Spacer(),
                    Text(
                      '4.500.000đ',
                      style: TextStyle(
                        color: Color(0xFF1463FF),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('/tháng', style: TextStyle(color: Colors.grey)),
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