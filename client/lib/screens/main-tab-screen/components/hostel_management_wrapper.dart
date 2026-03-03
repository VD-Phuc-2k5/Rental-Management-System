import 'package:app/screens/empty-hostel-screen/empty_hostel_screen.dart';
import 'package:app/screens/hostel-list-screen/hostel_list_screen.dart';
import 'package:flutter/material.dart';

class HostelManagementWrapper extends StatefulWidget {
  const HostelManagementWrapper({super.key});

  static _HostelManagementWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<_HostelManagementWrapperState>();
  }

  @override
  State<HostelManagementWrapper> createState() =>
      _HostelManagementWrapperState();
}

class _HostelManagementWrapperState extends State<HostelManagementWrapper> {
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
