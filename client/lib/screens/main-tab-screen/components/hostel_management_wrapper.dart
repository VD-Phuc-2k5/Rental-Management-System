import 'package:app/screens/empty-hostel-screen/empty_hostel_screen.dart';
import 'package:app/screens/hostel-list-screen/hostel_list_screen.dart';
import 'package:flutter/material.dart';

class HostelManagementWrapper extends StatefulWidget {
  const HostelManagementWrapper({super.key});

  static HostelManagementWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<HostelManagementWrapperState>();
  }

  @override
  State<HostelManagementWrapper> createState() =>
      HostelManagementWrapperState();
}

class HostelManagementWrapperState extends State<HostelManagementWrapper> {
  bool isEmpty = true;

  void updateState(bool emptyStatus) {
    setState(() {
      isEmpty = emptyStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const EmptyHostelScreen();
    } else {
      return const HostelListScreen();
    }
  }
}
