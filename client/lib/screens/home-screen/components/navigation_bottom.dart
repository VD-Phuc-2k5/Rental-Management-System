import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class NavigationBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const NavigationBottom({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  final _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Trang chủ",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month),
      label: "Lịch hẹn",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.build_outlined),
      label: "Sự cố",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      label: "Hóa đơn",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.perm_identity),
      label: "Tài khoản",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          items: _items,
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: AppColors.blue700,
          unselectedItemColor: AppColors.gray500,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          iconSize: 28,
        ),
      ),
    );
  }
}