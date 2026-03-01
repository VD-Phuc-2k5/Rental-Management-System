import 'package:app/core/constants.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/hostel_filter_tabs.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/month_selector.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/room_meter_card.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/utility_meter_examples.dart';
import 'package:app/screens/landlord-utility-meter-screens/components/utility_meter_models.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final UtilityMeterUpdateData? initialData;

  const Body({super.key, this.initialData});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late UtilityMeterUpdateData _data;
  String? _selectedHostel;
  late Map<String, RoomMeterData> _roomsMap;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData ?? UtilityMeterExamples.february2026;
    _roomsMap = {for (var room in _data.rooms) room.id: room};
  }

  void _handleHostelSelected(String? hostel) {
    setState(() {
      _selectedHostel = hostel;
    });
  }

  void _handleElectricityReadingChanged(String roomId, int newReading) {
    setState(() {
      final room = _roomsMap[roomId];
      if (room != null) {
        _roomsMap[roomId] = room.copyWith(
          electricity: room.electricity.copyWith(newReading: newReading),
        );
      }
    });
  }

  void _handleWaterReadingChanged(String roomId, int newReading) {
    setState(() {
      final room = _roomsMap[roomId];
      if (room != null) {
        _roomsMap[roomId] = room.copyWith(
          water: room.water.copyWith(newReading: newReading),
        );
      }
    });
  }

  void _handlePreviewAndCalculate() {
    // TODO: Navigate to preview/summary screen or show dialog
    final updatedRooms = _roomsMap.values.toList();
    final rentedRooms = updatedRooms.where(
      (r) => r.status == RoomStatus.rented,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã cập nhật ${rentedRooms.length} phòng đang cho thuê'),
        backgroundColor: AppColors.green600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRooms = _data.getRoomsByHostel(_selectedHostel);
    final displayRooms = filteredRooms
        .map((room) => _roomsMap[room.id]!)
        .toList();

    return Column(
      children: [
        MonthSelector(currentMonth: _data.month),
        HostelFilterTabs(
          hostels: _data.hostelNames,
          selectedHostel: _selectedHostel,
          onHostelSelected: _handleHostelSelected,
        ),
        Expanded(
          child: displayRooms.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  itemCount: displayRooms.length,
                  itemBuilder: (context, index) {
                    final room = displayRooms[index];
                    return RoomMeterCard(
                      room: room,
                      onElectricityNewReadingChanged: (value) =>
                          _handleElectricityReadingChanged(room.id, value),
                      onWaterNewReadingChanged: (value) =>
                          _handleWaterReadingChanged(room.id, value),
                    );
                  },
                ),
        ),
        _buildBottomAction(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.slate300),
          const SizedBox(height: 16.0),
          Text(
            "Không có phòng nào",
            style: TextStyle(
              color: AppColors.slate500,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handlePreviewAndCalculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue700,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                Icon(Icons.receipt_long, color: AppColors.white, size: 20),
                Text(
                  "Xem trước & Tính toán",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
