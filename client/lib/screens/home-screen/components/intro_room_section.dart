import 'package:app/screens/home-screen/components/intro_room_card.dart';
import 'package:flutter/material.dart';

class IntroRoomSection extends StatelessWidget {
  const IntroRoomSection({super.key});

  static final List<Map<String, String>> _rooms = const [
    {
      "title": "Phòng trọ 1",
      "address": "123 Đường A, Quận B",
      "price": "3.000.000 VND/tháng",
      "imageUrl": "https://file4.batdongsan.com.vn/2025/12/23/20251223125240-cf4d_wm.jpg"
    },
    {
      "title": "Phòng trọ 2",
      "address": "456 Đường C, Quận D",
      "price": "4.500.000 VND/tháng",
      "imageUrl": "https://file4.batdongsan.com.vn/2025/12/23/20251223125240-cf4d_wm.jpg"
    },
    {
      "title": "Phòng trọ 3",
      "address": "789 Đường E, Quận F",
      "price": "5.000.000 VND/tháng",
      "imageUrl": "https://file4.batdongsan.com.vn/2025/12/23/20251223125240-cf4d_wm.jpg"
    },
    {
      "title": "Phòng trọ 4",
      "address": "101 Đường G, Quận H",
      "price": "6.000.000 VND/tháng",
      "imageUrl": "https://file4.batdongsan.com.vn/2025/12/23/20251223125240-cf4d_wm.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var room in _rooms)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IntroRoomCard(
              title: room["title"] ?? "Phòng trọ",
              address: room["address"] ?? "Địa chỉ không xác định",
              price: room["price"] ?? "Giá không xác định",
              imageUrl: room["imageUrl"],
              onTap: () {
                // TODO: Navigate đến màn hình chi tiết phòng
                
              },
            ),
          ),
      ],
    );
  }
}