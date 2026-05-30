import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:domain/billing.dart';
import 'package:domain/property.dart';
import 'package:core/usecase.dart';

import '../../../core/constants.dart';
import '../../../core/di/di.dart';
import '../../../core/models/invoice_preview.dart';
import '../../preview-invoice/preview_invoice_screen.dart';
import 'bottom_action_bar.dart';
import 'data_preview_table.dart';
import 'upload_section.dart';
import '../models/electric_water_entry.dart';

class AddElectricWaterBody extends StatefulWidget {
  const AddElectricWaterBody({
    super.key,
    required this.month,
    required this.monthLabel,
    required this.onMonthChanged,
    this.initialPropertyId,
  });

  final String month;
  final String monthLabel;
  final ValueChanged<DateTime> onMonthChanged;
  final String? initialPropertyId;

  @override
  State<AddElectricWaterBody> createState() => _AddElectricWaterBodyState();
}

class _AddElectricWaterBodyState extends State<AddElectricWaterBody> {
  String? _selectedFileName;
  bool _isUploading = false;
  bool _isSubmitting = false;
  int _importedCount = 0;
  String? _errorMessage;
  String? _selectedPropertyId;
  List<PropertyEntity> _properties = [];

  List<ElectricWaterEntry> _entries = [];

  bool get _hasErrors => _entries.any((e) => e.hasError);
  bool get _hasData => _entries.isNotEmpty || _importedCount > 0;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final result = await getIt<GetPropertiesUsecase>().call(const NoParams());
    if (!mounted) return;
    result.fold(
      (_) {},
      (properties) => setState(() {
        _properties = properties;
        if (widget.initialPropertyId != null &&
            properties.any((p) => p.id == widget.initialPropertyId)) {
          _selectedPropertyId = widget.initialPropertyId;
        } else if (properties.length == 1) {
          _selectedPropertyId = properties.first.id;
        }
      }),
    );
  }

  Future<void> _onFilePicked(String? _) async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
      _importedCount = 0;
    });

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'json'],
    );

    if (result == null || result.files.isEmpty) {
      setState(() => _isUploading = false);
      return;
    }

    final picked = result.files.first;
    final fileBytes = picked.bytes;
    final fileName = picked.name;
    if (fileBytes == null || fileBytes.isEmpty) {
      setState(() {
        _isUploading = false;
        _errorMessage = 'Không đọc được nội dung file.';
      });
      return;
    }

    final usecase = getIt<ImportMeterReadingsUsecase>();
    final response = await usecase(
      ImportMeterReadingsParams(
        fileBytes: fileBytes,
        fileName: fileName,
        month: widget.month,
        propertyId: _selectedPropertyId,
      ),
    );

    response.fold(
      (failure) {
        setState(() {
          _errorMessage = failure.toString();
          _isUploading = false;
          _selectedFileName = picked.name;
        });
      },
      (data) {
        setState(() {
          _selectedFileName = picked.name;
          _importedCount = data.imported;
          _entries = [];
          _isUploading = false;
        });
      },
    );
  }

  Future<void> _onNext() async {
    setState(() => _isSubmitting = true);

    final usecase = getIt<PreviewInvoicesUsecase>();
    final response = await usecase(
      PreviewInvoicesParams(
        month: widget.month,
        propertyId: _selectedPropertyId,
      ),
    );

    final result = response.fold<List<InvoicePreview>?>(
      (failure) {
        setState(() {
          _errorMessage = failure.toString();
          _isSubmitting = false;
        });
        return null;
      },
      (data) {
        setState(() => _isSubmitting = false);
        return data
            .map(
              (e) => InvoicePreview(
                id: e.id,
                hostelName: e.hostelName,
                roomNumber: e.roomNumber,
                rentFee: e.rentFee,
                electricKwh: e.electricKwh,
                electricFee: e.electricFee,
                waterM3: e.waterM3,
                waterFee: e.waterFee,
                serviceFee: e.serviceFee,
              ),
            )
            .toList();
      },
    );

    if (result == null) {
      return;
    }

    if (result.isEmpty) {
      setState(() {
        _errorMessage =
            'Không có hợp đồng/phòng nào để tạo hóa đơn cho tháng này.';
      });
      return;
    }

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PreviewInvoiceScreen(
            month: widget.month,
            monthLabel: widget.monthLabel,
            propertyId: _selectedPropertyId,
            invoices: result,
          ),
        ),
      );
    }
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final initial = DateTime(
      int.parse(widget.month.substring(0, 4)),
      int.parse(widget.month.substring(5, 7)),
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: 'Chọn tháng',
      fieldLabelText: 'Tháng/năm',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked == null) {
      return;
    }

    widget.onMonthChanged(DateTime(picked.year, picked.month));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Scrollable content ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UploadSection(
                  onFilePicked: _onFilePicked,
                  selectedFileName: _selectedFileName,
                  isLoading: _isUploading,
                ),
                const SizedBox(height: 12),
                _buildPropertyPicker(),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickMonth,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.blue700,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.monthLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue950,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.slate400,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (_importedCount > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Đã nhập $_importedCount dòng chỉ số.',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (_entries.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  DataPreviewTable(entries: _entries),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ── Fixed bottom bar ─────────────────────────────────────────────────
        BottomActionBar(
          onNext: _hasData ? _onNext : null,
          isLoading: _isSubmitting,
          hasErrors: _hasErrors,
        ),
      ],
    );
  }

  Widget _buildPropertyPicker() {
    if (_properties.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String?>(
      initialValue: _selectedPropertyId,
      decoration: InputDecoration(
        labelText: 'Nhà trọ',
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
      ),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
            child: Text('Tất cả nhà trọ'),
        ),
        ..._properties.map(
          (property) => DropdownMenuItem<String?>(
            value: property.id,
            child: Text(property.name),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedPropertyId = value;
          _importedCount = 0;
          _entries = [];
          _errorMessage = null;
        });
      },
    );
  }
}
