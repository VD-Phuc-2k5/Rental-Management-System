import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/primary_button.dart';
import 'package:app/screens/booking-room-screen/components/body.dart';
import 'package:flutter/material.dart';

class BookingRoomScreen extends StatefulWidget {
  const BookingRoomScreen({super.key});

  @override
  State<BookingRoomScreen> createState() => _BookingRoomScreenState();
}

class _BookingRoomScreenState extends State<BookingRoomScreen> {
  DateTime _selectedDate = DateTime.now();
  late String _selectedHour;
  final List<String> _hours = ["08:00", "09:00", "10:00", "14:00"];
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

  void _handleConfirm() {
    // TODO: Implement booking confirmation logic
    // _selectedDate, _selectedHour, _noteController.text
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: "Đặt lịch xem phòng"),
      body: BookingRoomBody(
        hours: _hours,
        selectedDate: _selectedDate,
        selectedHour: _selectedHour,
        noteController: _noteController,
        onDateSelected: (date) => setState(() => _selectedDate = date),
        onHourSelected: (hour) => setState(() => _selectedHour = hour),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: PrimaryButton(
          label: "Xác nhận đặt phòng",
          onPressed: _handleConfirm,
        )
      ),
    );
  }
}