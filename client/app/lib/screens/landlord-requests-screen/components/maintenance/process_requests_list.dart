import 'package:data/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/maintenance_request_service.dart';
import '../../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';

import "../../../../core/constants.dart";
import "../../../../core/models/maintenance_request.dart";
import "../../../../core/widgets/maintenance_request_card.dart";
import "../../../landlord-maintenance-schedule-screen/landlord_maintenance_schedule_screen.dart";
import "package:flutter/material.dart";

class ProcessRequestsList extends StatefulWidget {
  const ProcessRequestsList({super.key, this.onCountChanged});
  final ValueChanged<int>? onCountChanged;

  @override
  State<ProcessRequestsList> createState() => _ProcessRequestsListState();
}

class _ProcessRequestsListState extends State<ProcessRequestsList> {
  bool _isLoading = false;
  List<MaintenanceRequest> _requests = [];
  final _maintenanceService = MaintenanceRequestService();

  String _getAccessToken() {
    final authUser = context.read<AuthenticationBloc>().state.user;

    if (authUser is AuthModel) {
      return authUser.token;
    }

    throw Exception("Không lấy được token đăng nhập");
  }

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
      final token = _getAccessToken();

      final requests = await _maintenanceService.fetchLandlordRequests(
        token: token,
      );

      if (!mounted) return;

      setState(() {
        _requests = requests;
        _isLoading = false;
      });

      widget.onCountChanged?.call(requests.length);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không thể tải yêu cầu sự cố: $e"),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    await _loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _requests.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue700),
      );
    }

    if (_requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: AppColors.slate300),
            SizedBox(height: 16),
            Text(
              "Không có yêu cầu cần xử lý",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.slate500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.blue700,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          return MaintenanceRequestCard(
            request: request,
            onTap: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) =>
                      LandlordMaintenanceScheduleScreen(request: request),
                ),
              );

              if (result == true) {
                await _loadRequests();
              }
            },
            actionButton: _buildActionButton(request),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(MaintenanceRequest request) {
    if (request.status == RequestStatus.pending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.orange100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "Chờ xử lý",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.orange600,
          ),
        ),
      );
    } else if (request.status == RequestStatus.processing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "Chờ xác nhận",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.blue700,
          ),
        ),
      );
    } else if (request.status == RequestStatus.complaint) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.red100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "Khiếu nại",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.red500,
          ),
        ),
      );
    } else if (request.status == RequestStatus.completed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.green100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "Hoàn thành",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.green700,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
