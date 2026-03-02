import 'package:app/screens/booking-room-screen/components/calendar_picker.dart';
import 'package:app/screens/booking-room-screen/components/card_title.dart';
import 'package:app/screens/booking-room-screen/components/hour_picker.dart';
import 'package:app/screens/booking-room-screen/components/note_section.dart';
import 'package:flutter/material.dart';

class BookingRoomBody extends StatefulWidget {
  const BookingRoomBody({super.key});

  @override
  State<BookingRoomBody> createState() => _BookingRoomBodyState();
}

class _BookingRoomBodyState extends State<BookingRoomBody> {
  final List<String> _hours = ["08:00", "09:00", "10:00", "14:00"];
  late String _selectedHour;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedHour = _hours.first;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle(
            title: "Phòng trọ cao cấp Q1", 
            imageUrl: "https://file4.batdongsan.com.vn/2025/12/23/20251223125240-cf4d_wm.jpg", 
            address: "123 Đường Nguyễn Huệ, Quận 1, TP.HCM", 
            price: 2800000
          ),
          const SizedBox(height: 16),
          CustomCalendarPicker(
            initialDate: DateTime.now(),
            onDateSelected: (value) {
              // TODO: Handle date selection
            },
          ),
          const SizedBox(height: 16),
          HourPicker(
            hours: _hours,
            selectedHour: _selectedHour,
            onHourSelected: (value) {
              setState(() => _selectedHour = value);
            },
          ),
          const SizedBox(height: 24),
          NoteSection(controller: _noteController),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}