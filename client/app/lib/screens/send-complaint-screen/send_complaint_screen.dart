import 'package:data/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants.dart';
import '../../core/models/maintenance_request.dart';
import '../../core/services/maintenance_request_service.dart';
import '../../core/widgets/common_appbar.dart';
import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';

import 'components/complaint_issue_info_card.dart';
import 'components/complaint_reason_field.dart';
import 'components/complaint_images_section.dart';
import 'components/complaint_note_banner.dart';
import 'components/complaint_bottom_bar.dart';

class SendComplaintScreen extends StatefulWidget {
  const SendComplaintScreen({
    super.key,
    required this.request,
  });

  final MaintenanceRequest request;

  @override
  State<SendComplaintScreen> createState() => _SendComplaintScreenState();
}

class _SendComplaintScreenState extends State<SendComplaintScreen> {
  final _reasonController = TextEditingController();
  final _service = MaintenanceRequestService();
  final _imagePicker = ImagePicker();

  bool _isSubmitting = false;
  final List<XFile> _selectedImages = [];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String? _getAccessToken() {
    final authUser = context.read<AuthenticationBloc>().state.user;
    if (authUser is AuthModel) return authUser.token;
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= ComplaintImagesSection.maxImages) return;

    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() => _selectedImages.add(picked));
      }
    } on Exception catch (e) {
      if (mounted) _showMessage('Lỗi khi chọn ảnh: $e');
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  Future<void> _submitComplaint() async {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      _showMessage('Vui lòng nhập lý do khiếu nại');
      return;
    }

    final token = _getAccessToken();
    if (token == null || token.isEmpty) {
      _showMessage('Không lấy được token đăng nhập');
      return;
    }

    if (widget.request.status == RequestStatus.completed) {
      _showMessage('Sự cố này đã được xác nhận hoàn thành trước đó');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final updatedRequest = await _service.submitComplaint(
        token: token,
        requestId: widget.request.id,
        complaintDescription: reason,
        images: _selectedImages,
      );

      if (!mounted) return;

      _showMessage('Gửi khiếu nại thành công');
      await Future.delayed(const Duration(milliseconds: 400));

      if (mounted) Navigator.of(context).pop(updatedRequest);
    } catch (e) {
      if (mounted) {
        final message = e.toString();
        if (message.contains('xác nhận hoàn thành')) {
          _showMessage('Sự cố này đã được xác nhận hoàn thành trước đó');
        } else {
          _showMessage('Lỗi khi gửi khiếu nại: $e');
        }
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: 'Gửi khiếu nại'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComplaintIssueInfoCard(
              issueTitle: widget.request.title,
              roomName: widget.request.location.isNotEmpty
                  ? widget.request.location
                  : 'Chưa xác định',
              statusLabel: widget.request.status.label,
            ),
            const SizedBox(height: 16),
            ComplaintReasonField(controller: _reasonController),
            const SizedBox(height: 18),
            ComplaintImagesSection(
              images: _selectedImages,
              onAddImage: _pickImage,
              onRemoveImage: _removeImage,
            ),
            const SizedBox(height: 14),
            const ComplaintNoteBanner(),
          ],
        ),
      ),
      bottomNavigationBar: ComplaintBottomBar(
        isSubmitting: _isSubmitting,
        onSubmit: _submitComplaint,
      ),
    );
  }
}
