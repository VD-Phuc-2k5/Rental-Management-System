import 'package:app/screens/room-detail-screen/components/image_carousel_section.dart';
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageCarouselSection(imageUrls: imageUrls)
        ],
      ),
    );
  }
}