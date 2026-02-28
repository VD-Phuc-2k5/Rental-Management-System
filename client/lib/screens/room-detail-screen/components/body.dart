import 'package:app/screens/room-detail-screen/components/image_carousel_section.dart';
import 'package:app/screens/room-detail-screen/components/room_heading_detail.dart';
import 'package:app/screens/room-detail-screen/components/room_info_section.dart';
import 'package:flutter/material.dart';

List<String> imageUrls = [
  'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80',
  'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80',
  'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80',
];

class RoomDetailBody extends StatelessWidget {
  const RoomDetailBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageCarouselSection(imageUrls: imageUrls),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const RoomHeadingDetail(
                title: "Phòng trọ cao cấp 25m² - Full nội thất",
                price: 2800000,
              ),
              const SizedBox(height: 10),
              const RoomInfoSection(
                electricPrice: 3500,
                waterPrice: 25000,
                address: "123 Đường Nguyễn Văn Linh, Phường Tán Thuận Tây, Quận 7, TP.HCM",
                area: 25,
                bedrooms: 1,
                hasFurniture: true,
              ),                
            ],
          ),
        ),
      ],
    );
  }
}