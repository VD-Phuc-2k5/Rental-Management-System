import "maintenance/process_requests_list.dart";
import "tab_header.dart";
import "package:flutter/material.dart";
import '../../../features/viewing_appointment/presentation/pages/landlord_viewing_appointments_page.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _selectedTabIndex = 0;
  final int _viewRoomCount = 0;
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
              ? const LandlordViewingAppointmentsPage(
                  embedded: true,
                )
              // ? ViewRoomList(
              //     onCountChanged: (count) {
              //       setState(() => _viewRoomCount = count);
              //     },
              //   )
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
