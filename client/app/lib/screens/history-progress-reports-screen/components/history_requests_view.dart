import 'package:flutter/material.dart';

import 'package:data/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../../tenant-maintenance-detail-screen/maintenance_detail_screen.dart';
import '../../../core/models/maintenance_request.dart';
import '../../../core/services/maintenance_request_service.dart';
import '../../../core/widgets/maintenance_request_card.dart';

class HistoryRequestsView extends StatefulWidget {
  const HistoryRequestsView({super.key});

  @override
  State<HistoryRequestsView> createState() => _HistoryRequestsViewState();
}

class _HistoryRequestsViewState extends State<HistoryRequestsView> {
  final _service = MaintenanceRequestService();

  String _getCurrentTenantId() {
  final authUser = context.read<AuthenticationBloc>().state.user;

  if (authUser is AuthModel) {
    return authUser.user.id;
  }

  throw Exception("Không lấy được thông tin người dùng đăng nhập");
}

  String _getAccessToken() {
  final authUser = context.read<AuthenticationBloc>().state.user;

  if (authUser is AuthModel) {
    return authUser.token;
  }

  throw Exception("Không lấy được token đăng nhập");
}
  late Future<List<MaintenanceRequest>> _futureRequests;

  @override
  void initState() {
    super.initState();
    final token = _getAccessToken();

  _futureRequests = _service.fetchMyRequests(
    token: token,
  );
  }

  Future<void> _reload() async {
    final token = _getAccessToken();

  setState(() {
    _futureRequests = _service.fetchMyRequests(
      token: token,
    );
  });


    await _futureRequests;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MaintenanceRequest>>(
      future: _futureRequests,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Không thể tải lịch sử yêu cầu:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final historyRequests = snapshot.data ?? [];

        if (historyRequests.isEmpty) {
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: const [
                SizedBox(height: 120),
                Icon(
                  Icons.assignment_outlined,
                  size: 56,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'Chưa có yêu cầu sửa chữa nào',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
            itemCount: historyRequests.length,
            itemBuilder: (context, i) => MaintenanceRequestCard(
              request: historyRequests[i],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TenantMaintenanceDetailScreen(
                      request: historyRequests[i],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}