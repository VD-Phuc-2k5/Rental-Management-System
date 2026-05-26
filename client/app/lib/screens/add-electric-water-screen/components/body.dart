import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:domain/billing.dart';

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
  });

  final String month;
  final String monthLabel;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  State<AddElectricWaterBody> createState() => _AddElectricWaterBodyState();
}

class _AddElectricWaterBodyState extends State<AddElectricWaterBody> {
  String? _selectedFileName;
  bool _isUploading = false;
  bool _isSubmitting = false;
  int _importedCount = 0;
  String? _errorMessage;

  List<ElectricWaterEntry> _entries = [];

  bool get _hasErrors => _entries.any((e) => e.hasError);
  bool get _hasData => _entries.isNotEmpty || _importedCount > 0;

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
    final filePath = picked.path;
    if (filePath == null) {
      setState(() {
        _isUploading = false;
        _errorMessage = 'Không tìm thấy đường dẫn file.';
      });
      return;
    }

    final usecase = getIt<ImportMeterReadingsUsecase>();
    final response = await usecase(
      ImportMeterReadingsParams(
        filePath: filePath,
        month: widget.month,
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
      PreviewInvoicesParams(month: widget.month),
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

    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PreviewInvoiceScreen(
            month: widget.month,
            monthLabel: widget.monthLabel,
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
      helpText: 'Chon thang',
      fieldLabelText: 'Thang/nam',
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
}
