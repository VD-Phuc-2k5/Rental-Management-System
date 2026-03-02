import "dart:io";
import "package:app/core/constants.dart";
import "package:app/screens/tenant-maintenance-request-screen/components/image_upload_section.dart";
import "package:app/screens/tenant-maintenance-request-screen/components/labeled_text_field.dart";
import "package:app/screens/tenant-maintenance-request-screen/components/priority_selector.dart";
import "package:app/screens/tenant-maintenance-request-screen/components/tab_header.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  int _selectedTabIndex = 0;
  Priority _selectedPriority = Priority.low;
  List<File> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) {
      _showMessage("Bạn chỉ có thể tải lên tối đa 5 ảnh");
      return;
    }

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showMessage("Lỗi khi chọn ảnh: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập tiêu đề sự cố";
    }
    if (value.trim().length < 5) {
      return "Tiêu đề phải có ít nhất 5 ký tự";
    }
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      _showMessage("Vui lòng kiểm tra lại thông tin");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement API call to submit maintenance request
      // Example:
      // await maintenanceService.createRequest(
      //   title: _titleController.text.trim(),
      //   description: _descriptionController.text.trim(),
      //   priority: _selectedPriority,
      //   images: _selectedImages,
      // );

      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (mounted) {
        _showMessage("Gửi yêu cầu thành công");
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        _showMessage("Lỗi khi gửi yêu cầu: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedPriority = Priority.low;
      _selectedImages = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabHeader(
          selectedIndex: _selectedTabIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          tabs: const ["Yêu cầu sửa chữa", "Lịch sử yêu cầu"],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 34.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: AppColors.black.withAlpha(13),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20.0,
                  children: [
                    LabeledTextField(
                      label: "Tiêu đề sự cố",
                      isRequired: true,
                      hintText: "ex: sự cố gặp phải",
                      maxLines: 2,
                      maxLength: 255,
                      controller: _titleController,
                      validator: _validateTitle,
                    ),
                    PrioritySelector(
                      selectedPriority: _selectedPriority,
                      onPrioritySelected: (priority) {
                        setState(() {
                          _selectedPriority = priority;
                        });
                      },
                    ),
                    LabeledTextField(
                      label: "Mô tả chi tiết",
                      hintText: "Mô tả chi tiết về vấn đề bạn đang gặp phải...",
                      maxLines: 5,
                      maxLength: 500,
                      controller: _descriptionController,
                    ),
                    ImageUploadSection(
                      selectedImages: _selectedImages,
                      onAddImage: _pickImage,
                      onRemoveImage: _removeImage,
                      maxImages: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          backgroundColor: _isSubmitting
                              ? AppColors.slate400
                              : AppColors.blue700,
                        ),
                        onPressed: _isSubmitting ? null : _submitRequest,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Gửi yêu cầu",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
