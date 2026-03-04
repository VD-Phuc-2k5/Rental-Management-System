import "package:app/screens/landlord-requests-screen/components/maintenance/process_requests_list.dart";
import "package:app/screens/landlord-requests-screen/components/tab_header.dart";
import "package:app/screens/landlord-requests-screen/components/view-room/view_room_list.dart";
import "package:flutter/material.dart";

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selectedTabIndex = 0;
  int _viewRoomCount = 0;
  int _processCount = 0;

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
          counts: [_viewRoomCount, _processCount],
        ),
        Expanded(
          child: _selectedTabIndex == 0
              ? ViewRoomList(
                  onCountChanged: (count) {
                    setState(() => _viewRoomCount = count);
                  },
                )
              : ProcessRequestsList(
                  onCountChanged: (count) {
                    setState(() => _processCount = count);
                  },
                ),
        ),
      ],
    );
  }
}
