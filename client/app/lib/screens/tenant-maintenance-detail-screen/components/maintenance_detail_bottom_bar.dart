import 'package:data/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/models/maintenance_request.dart';
import '../../../core/services/maintenance_request_service.dart';
import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../../send-complaint-screen/send_complaint_screen.dart';

class MaintenanceDetailBottomBar extends StatefulWidget {
  const MaintenanceDetailBottomBar({
    super.key,
    required this.request,
    required this.onRequestChanged,
  });

  final MaintenanceRequest request;
  final ValueChanged<MaintenanceRequest> onRequestChanged;

  @override
  State<MaintenanceDetailBottomBar> createState() =>
      _MaintenanceDetailBottomBarState();
}

class _MaintenanceDetailBottomBarState
    extends State<MaintenanceDetailBottomBar> {
  final _service = MaintenanceRequestService();

  bool _isSubmitting = false;

  String? _getAccessToken() {
    final authUser = context.read<AuthenticationBloc>().state.user;

    if (authUser is AuthModel) {
      return authUser.token;
    }

    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _goToComplaintScreen() async {
    try {
      final freshRequest = await _getFreshRequestOrNotify();

      if (freshRequest == null) return;

      if (!mounted) return;

      final updatedRequest = await Navigator.of(context)
          .push<MaintenanceRequest>(
            MaterialPageRoute(
              builder: (_) => SendComplaintScreen(
                request: freshRequest,
              ),
            ),
          );

      if (updatedRequest != null) {
        widget.onRequestChanged(updatedRequest);
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Không thể kiểm tra trạng thái sự cố: $e');
      }
    }
  }

  Future<void> _confirmCompleted() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final freshRequest = await _getFreshRequestOrNotify();

      if (freshRequest == null) return;

      final token = _getAccessToken();

      if (token == null || token.isEmpty) {
        _showMessage('Không lấy được token đăng nhập');
        return;
      }

      final completedRequest = await _service.completeRequest(
        token: token,
        requestId: freshRequest.id,
      );

      if (!mounted) return;

      widget.onRequestChanged(completedRequest);

      _showMessage('Xác nhận hoàn thành thành công');
    } catch (e) {
      if (mounted) {
        final message = e.toString();

        if (message.contains('xác nhận hoàn thành')) {
          _showMessage('Sự cố này đã được xác nhận hoàn thành trước đó');
        } else {
          _showMessage('Lỗi khi xác nhận hoàn thành: $e');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
    // if (_isCompleted) {
    //   _showMessage('Sự cố này đã được xác nhận hoàn thành');
    //   return;
    // }

    // final token = _getAccessToken();

    // if (token == null || token.isEmpty) {
    //   _showMessage('Không lấy được token đăng nhập');
    //   return;
    // }

    // setState(() {
    //   _isSubmitting = true;
    // });

    // try {
    //   await _service.completeRequest(
    //     token: token,
    //     requestId: widget.request.id,
    //   );

    //   if (!mounted) return;

    //   _showMessage('Xác nhận hoàn thành thành công');

    //   await Future.delayed(const Duration(milliseconds: 500));

    //   if (mounted) {
    //     Navigator.of(context).pop(true);
    //   }
    // } catch (e) {
    //   if (mounted) {
    //     _showMessage('Lỗi khi xác nhận hoàn thành: $e');
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isSubmitting = false;
    //     });
    //   }
    // }
  }

  Future<MaintenanceRequest?> _getFreshRequestOrNotify() async {
    final token = _getAccessToken();

    if (token == null || token.isEmpty) {
      _showMessage('Không lấy được token đăng nhập');
      return null;
    }

    final freshRequest = await _service.fetchRequestDetail(
      token: token,
      requestId: widget.request.id,
    );

    widget.onRequestChanged(freshRequest);

    if (freshRequest.status == RequestStatus.completed) {
      _showMessage('Sự cố này đã được xác nhận hoàn thành trước đó');
      return null;
    }

    return freshRequest;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: OutlinedButton.icon(
                onPressed: _isSubmitting ? null : _goToComplaintScreen,
                icon: const Icon(
                  Icons.report_gmailerrorred_outlined,
                  color: AppColors.red500,
                ),
                label: const Text(
                  'Gửi khiếu nại',
                  style: TextStyle(
                    color: AppColors.red500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColors.red500,
                    width: 1,
                  ),
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 11,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _confirmCompleted,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.white,
                      ),
                label: Text(
                  _isSubmitting ? 'Đang xử lý...' : 'Xác nhận hoàn thành',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../../../core/constants.dart';

// import 'package:data/auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../core/models/maintenance_request.dart';
// import '../../../core/services/maintenance_request_service.dart';
// import '../../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
// import '../../send-complaint-screen/send_complaint_screen.dart';
// class MaintenanceDetailBottomBar extends StatelessWidget {
//   const MaintenanceDetailBottomBar({
//     super.key,
//     required this.request,});
//   final MaintenanceRequest request;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.white,
//       child: SafeArea(
//         top: false,
//         minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 9,
//               child: OutlinedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.report_gmailerrorred_outlined, color: AppColors.red500),
//                 label: const Text(
//                   'Gửi khiếu nại',
//                   style: TextStyle(color: AppColors.red500, fontWeight: FontWeight.w600),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: AppColors.red500, width: 1),
//                   backgroundColor: AppColors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   minimumSize: const Size.fromHeight(52),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 11,
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
//                 label: const Text(
//                   'Xác nhận hoàn thành',
//                   style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.green400,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   elevation: 0,
//                   minimumSize: const Size.fromHeight(52),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }