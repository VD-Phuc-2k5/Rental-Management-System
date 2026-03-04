import 'package:app/screens/booking-room-screen/components/booking-room/calendar_picker.dart';
import 'package:app/screens/booking-room-screen/components/booking-room/card_title.dart';
import 'package:app/screens/booking-room-screen/components/booking-room/hour_picker.dart';
import 'package:app/screens/booking-room-screen/components/booking-room/note_section.dart';
import 'package:flutter/material.dart';

class BookingRoomBody extends StatelessWidget {
  final List<String> hours;
  final DateTime selectedDate;
  final String selectedHour;
  final TextEditingController noteController;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onHourSelected;

  const BookingRoomBody({
    super.key,
    required this.hours,
    required this.selectedDate,
    required this.selectedHour,
    required this.noteController,
    required this.onDateSelected,
    required this.onHourSelected,
  });

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
            initialDate: selectedDate,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 16),
          HourPicker(
            hours: hours,
            selectedHour: selectedHour,
            onHourSelected: onHourSelected,
          ),
          const SizedBox(height: 24),
          NoteSection(controller: noteController),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}