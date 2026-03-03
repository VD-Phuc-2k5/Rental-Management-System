import 'package:flutter/material.dart';

import 'components/hostel_management_wrapper.dart';
import 'components/main_bottom_nav.dart';
import 'components/room_management_wrapper.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  static MainTabScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainTabScreenState>();
  }

  @override
  State<MainTabScreen> createState() => MainTabScreenState();
}

class MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HostelManagementWrapper(),
    const RoomManagementWrapper(),
    const Center(child: Text("Yêu cầu - Đang phát triển")),
    const Center(child: Text("Hóa đơn - Đang phát triển")),
    const Center(child: Text("Hồ sơ - Đang phát triển")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm này để chuyển tab từ xa
  void switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: MainBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
