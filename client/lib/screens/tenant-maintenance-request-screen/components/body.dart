import "package:app/screens/tenant-maintenance-request-screen/components/request_form.dart";
import "package:app/screens/tenant-maintenance-request-screen/components/tab_header.dart";
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
          tabs: const ["Yêu cầu sửa chữa", "Lịch sử yêu cầu"],
        ),
        Expanded(
          child: _selectedTabIndex == 0 ? const RequestForm() : const Text(""),
        ),
      ],
    );
  }
}
