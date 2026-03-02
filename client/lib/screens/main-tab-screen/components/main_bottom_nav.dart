import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class MainBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MainBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.slate200, width: 1.0)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.blue700,
        unselectedItemColor: AppColors.slate500,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Noto Sans',
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Nhà trọ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_front_door_outlined),
            label: "Phòng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: "Yêu cầu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Hóa đơn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Hồ sơ",
          ),
        ],
      ),
    );
  }
}
