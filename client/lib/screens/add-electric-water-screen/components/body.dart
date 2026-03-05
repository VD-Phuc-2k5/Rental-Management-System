import 'package:app/core/models/invoice_preview.dart';
import 'package:app/screens/preview-invoice/preview_invoice_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/add-electric-water-screen/components/bottom_action_bar.dart';
import 'package:app/screens/add-electric-water-screen/components/data_preview_table.dart';
import 'package:app/screens/add-electric-water-screen/components/upload_section.dart';
import 'package:app/screens/add-electric-water-screen/models/electric_water_entry.dart';

class AddElectricWaterBody extends StatefulWidget {
  const AddElectricWaterBody({super.key});

  @override
  State<AddElectricWaterBody> createState() => _AddElectricWaterBodyState();
}

class _AddElectricWaterBodyState extends State<AddElectricWaterBody> {
  String? _selectedFileName;
  bool _isUploading = false;
  bool _isSubmitting = false;

  List<ElectricWaterEntry> _entries = [];

  bool get _hasErrors => _entries.any((e) => e.hasError);
  bool get _hasData => _entries.isNotEmpty;

  Future<void> _onFilePicked(String? _) async {
    setState(() => _isUploading = true);

    await Future.delayed(const Duration(seconds: 1));

    final mockEntries = [
      const ElectricWaterEntry(
        hostelName: 'Nhà A',
        roomNumber: '101',
        oldElectric: 1240,
        newElectric: 1350,
        oldWater: 450,
        newWater: 465,
      ),
      const ElectricWaterEntry(
        hostelName: 'Nhà A',
        roomNumber: '102',
        oldElectric: 2100,
        newElectric: 2215,
        oldWater: 890,
        newWater: 902,
      ),
      const ElectricWaterEntry(
        hostelName: 'Nhà B',
        roomNumber: '103',
        oldElectric: 1850,
        newElectric: 1800, // lỗi: mới < cũ
        oldWater: 510,
        newWater: 530,
      ),
      const ElectricWaterEntry(
        hostelName: 'Nhà B',
        roomNumber: '201',
        oldElectric: 3400,
        newElectric: 3520,
        oldWater: 120,
        newWater: 135,
      ),
    ];

    setState(() {
      _selectedFileName = 'chiso_thang_02_2026.xlsx';
      _entries = mockEntries;
      _isUploading = false;
    });
  }

  final List<InvoicePreview> _mockInvoices = const [
    InvoicePreview(
      id: '1',
      hostelName: 'Nhà A',
      roomNumber: '101',
      rentFee: 3000000,
      electricKwh: 110,
      electricFee: 220000,
      waterM3: 15,
      waterFee: 75000,
      serviceFee: 50000,
    ),
    InvoicePreview(
      id: '2',
      hostelName: 'Nhà A',
      roomNumber: '102',
      rentFee: 3200000,
      electricKwh: 115,
      electricFee: 230000,
      waterM3: 12,
      waterFee: 60000,
      serviceFee: 50000,
    ),
    InvoicePreview(
      id: '3',
      hostelName: 'Nhà B',
      roomNumber: '103',
      rentFee: 2800000,
      electricKwh: 50, // lỗi
      electricFee: 100000,
      waterM3: 20,
      waterFee: 100000,
      serviceFee: 50000,
    ),
    InvoicePreview(
      id: '4',
      hostelName: 'Nhà B',
      roomNumber: '201',
      rentFee: 3500000,
      electricKwh: 120,
      electricFee: 240000,
      waterM3: 15,
      waterFee: 75000,
      serviceFee: 50000,
    ),
  ];

  // ─── Submit (thay bằng API call thực tế) ─────────────────────────────────────
  Future<void> _onNext() async {
    setState(() => _isSubmitting = true);

    // TODO: Gọi API lưu chỉ số điện nước
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSubmitting = false);

    if (mounted) {
      Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (_) => 
            PreviewInvoiceScreen(
              monthLabel: "Tháng 02/2026", 
              invoices: _mockInvoices
            )
        )
      );
    }
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
                if (_hasData) ...[
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
          hasErrors: false,
        ),
      ],
    );
  }
}
