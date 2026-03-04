import "package:app/screens/landlord-requests-screen/components/maintenance/process_requests_list.dart";
import "package:app/screens/landlord-requests-screen/components/tab_header.dart";
import "package:app/screens/landlord-requests-screen/components/view-rooom/view_room_list.dart";
import "package:flutter/material.dart";

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabHeader(
          selectedIndex: _selectedTabIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          tabs: const ["Xem phòng", "Xử lý sự cố"],
        ),
        Expanded(
          child: _selectedTabIndex == 0
              ? const ViewRoomList()
              : const ProcessRequestsList(),
        ),
      ],
    );
  }
}
