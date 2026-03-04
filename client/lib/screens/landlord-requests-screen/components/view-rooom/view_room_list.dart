import 'package:app/core/constants.dart';
import 'package:app/core/models/room_request.dart';
import 'package:app/screens/landlord-requests-screen/components/view-rooom/view_room_card.dart';
import 'package:flutter/material.dart';

class ViewRoomList extends StatefulWidget {
  final ValueChanged<int>? onCountChanged;

  const ViewRoomList({super.key, this.onCountChanged});

  @override
  State<ViewRoomList> createState() => _ViewRoomListState();
}

class _ViewRoomListState extends State<ViewRoomList> {
  bool _isLoading = false;
  List<RoomRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TO DO: Implement API call to fetch room requests
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final mockRequests = [
        RoomRequest(
          id: "1",
          tenantName: "Nguyễn Văn A",
          phoneNumber: "0123456789",
          roomInfo: "Phòng 101 - Tòa A",
          scheduledDate: "2024-06-15 14:00",
          note: "Em muốn kiểm tra phòng vào buổi sáng vì chiều bận đi học.",
          status: "Chờ xử lý",
        ),
        RoomRequest(
          id: "2",
          tenantName: "Trần Thị B",
          phoneNumber: "0987654321",
          roomInfo: "Phòng 204 - Tòa B",
          scheduledDate: "2024-06-16 10:00",
          note: null,
          status: "Đã xác nhận",
        ),
        RoomRequest(
          id: "3",
          tenantName: "Lê Văn C",
          phoneNumber: "0112233445",
          roomInfo: "Phòng 305 - Tòa C",
          scheduledDate: "2024-06-17 16:00",
          note: "Yêu cầu kiểm tra hệ thống nước nóng",
          status: "Đã huỷ",
        ),
      ];

      if (mounted) {
        setState(() {
          _requests = mockRequests;
          _isLoading = false;
        });
        widget.onCountChanged?.call(mockRequests.length);
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _requests.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.blue700));
    }

    if (_requests.isEmpty) {
      return const Center(child: Text("Không có yêu cầu nào."));
    }
    
    return RefreshIndicator(
      onRefresh: _loadRequests,
      color: AppColors.blue700,
      child: ListView.builder(
        itemCount: _requests.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final request = _requests[index];
          return ViewRoomCard(
            tenantName: request.tenantName,
            phoneNumber: request.phoneNumber,
            roomInfo: request.roomInfo,
            scheduledDate: request.scheduledDate,
            note: request.note,
            status: request.status,
          );
        },
      ),
    );
  }
}