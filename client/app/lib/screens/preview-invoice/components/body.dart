import 'package:flutter/material.dart';
import 'package:domain/billing.dart';
import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart' hide State;

import '../../../core/constants.dart';
import '../../../core/di/di.dart';
import '../../../core/models/invoice_preview.dart';
import 'info_banner.dart';
import 'invoice_bottom_bar.dart';
import 'invoice_card.dart';

class PreviewInvoceBody extends StatefulWidget {
  const PreviewInvoceBody({
    super.key,
    required this.invoices,
    required this.month,
    required this.monthLabel,
    this.propertyId,
  });
  final List<InvoicePreview> invoices;
  final String month;
  final String monthLabel;
  final String? propertyId;

  @override
  State<PreviewInvoceBody> createState() => _PreviewInvoceBodyState();
}

class _PreviewInvoceBodyState extends State<PreviewInvoceBody> {
  late final Set<String> _selectedIds;
  bool _isSending = false;
  bool _isDraft = false;
  String? _dueDate;
  String _searchText = '';
  Set<String> _selectedHostels = {};
  final Map<String, _InvoiceEdits> _editedInvoices = {};

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.invoices.map((e) => e.id).toSet();
  }

  Map<String, InvoicePreview> get _invoiceMap {
    return {
      for (final invoice in widget.invoices) invoice.id: _applyEdits(invoice),
    };
  }

  List<InvoicePreview> get _visibleInvoices {
    final search = _searchText.trim().toLowerCase();
    return _invoiceMap.values.where((invoice) {
      final matchesHostel =
          _selectedHostels.isEmpty ||
          _selectedHostels.contains(invoice.hostelName);
      if (!matchesHostel) {
        return false;
      }
      if (search.isEmpty) {
        return true;
      }
      final haystack = '${invoice.hostelName} ${invoice.roomNumber}'
          .toLowerCase();
      return haystack.contains(search);
    }).toList();
  }

  Set<String> get _visibleIds =>
      _visibleInvoices.map((invoice) => invoice.id).toSet();

  bool get _allSelected =>
      _visibleIds.isNotEmpty && _visibleIds.every(_selectedIds.contains);

  int get _totalAmount => _invoiceMap.values
      .where((invoice) => _selectedIds.contains(invoice.id))
      .fold(0, (sum, invoice) => sum + invoice.total);

  String get _dueDateLabel {
    final dueDate = _dueDate;
    if (dueDate == null || dueDate.isEmpty) return 'Chọn hạn thanh toán';
    final parts = dueDate.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return dueDate;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Chọn hạn thanh toán',
    );
    if (picked == null) return;
    setState(() {
      final month = picked.month.toString().padLeft(2, '0');
      final day = picked.day.toString().padLeft(2, '0');
      _dueDate = '${picked.year}-$month-$day';
    });
  }

  void _toggleAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedIds.addAll(_visibleIds);
      } else {
        _selectedIds.removeAll(_visibleIds);
      }
    });
  }

  void _toggleOne(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  InvoicePreview _applyEdits(InvoicePreview invoice) {
    final edits = _editedInvoices[invoice.id];
    if (edits == null) {
      return invoice;
    }
    return InvoicePreview(
      id: invoice.id,
      hostelName: invoice.hostelName,
      roomNumber: invoice.roomNumber,
      rentFee: edits.rentFee ?? invoice.rentFee,
      electricKwh: invoice.electricKwh,
      electricFee: edits.electricFee ?? invoice.electricFee,
      waterM3: invoice.waterM3,
      waterFee: edits.waterFee ?? invoice.waterFee,
      serviceFee: edits.serviceFee ?? invoice.serviceFee,
    );
  }

  void _openEditSheet(InvoicePreview invoice) {
    final edits = _editedInvoices[invoice.id];
    final rentController = TextEditingController(
      text: (edits?.rentFee ?? invoice.rentFee).toString(),
    );
    final electricController = TextEditingController(
      text: (edits?.electricFee ?? invoice.electricFee).toString(),
    );
    final waterController = TextEditingController(
      text: (edits?.waterFee ?? invoice.waterFee).toString(),
    );
    final serviceController = TextEditingController(
      text: (edits?.serviceFee ?? invoice.serviceFee).toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sửa hóa đơn phòng ${invoice.roomNumber}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue950,
                ),
              ),
              const SizedBox(height: 12),
              _buildAmountField('Tiền phòng', rentController),
              const SizedBox(height: 12),
              _buildAmountField(
                'Điện (${invoice.electricKwh} số)',
                electricController,
              ),
              const SizedBox(height: 12),
              _buildAmountField(
                'Nước (${invoice.waterM3}m3)',
                waterController,
              ),
              const SizedBox(height: 12),
              _buildAmountField('Dịch vụ', serviceController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final rentFee = _parseAmount(rentController.text);
                        final electricFee = _parseAmount(
                          electricController.text,
                        );
                        final waterFee = _parseAmount(waterController.text);
                        final serviceFee = _parseAmount(serviceController.text);

                        setState(() {
                          _editedInvoices[invoice.id] = _InvoiceEdits(
                            rentFee: rentFee,
                            electricFee: electricFee,
                            waterFee: waterFee,
                            serviceFee: serviceFee,
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Lưu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  int _parseAmount(String value) {
    final raw = value.replaceAll(',', '').trim();
    return int.tryParse(raw) ?? 0;
  }

  List<InvoiceItemInputEntity> _buildInvoiceItems(InvoicePreview invoice) {
    final rentFee = invoice.rentFee.toDouble();
    final electricFee = invoice.electricFee.toDouble();
    final waterFee = invoice.waterFee.toDouble();
    final serviceFee = invoice.serviceFee.toDouble();

    final electricQty = invoice.electricKwh.toDouble();
    final waterQty = invoice.waterM3.toDouble();

    final electricUnit = electricQty > 0
        ? (electricFee / electricQty).toDouble()
        : 0.0;
    final waterUnit = waterQty > 0 ? (waterFee / waterQty).toDouble() : 0.0;

    return [
      InvoiceItemInputEntity(
        type: 'rent',
        quantity: 1,
        unitPrice: rentFee,
        amount: rentFee,
      ),
      InvoiceItemInputEntity(
        type: 'electric',
        quantity: electricQty,
        unitPrice: electricUnit,
        amount: electricFee,
      ),
      InvoiceItemInputEntity(
        type: 'water',
        quantity: waterQty,
        unitPrice: waterUnit,
        amount: waterFee,
      ),
      InvoiceItemInputEntity(
        type: 'service',
        quantity: 1,
        unitPrice: serviceFee,
        amount: serviceFee,
      ),
    ];
  }

  Widget _buildAmountField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _openFilterSheet() {
    final hostels =
        widget.invoices.map((invoice) => invoice.hostelName).toSet().toList()
          ..sort();
    var tempSearch = _searchText;
    final tempSelected = {..._selectedHostels};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lọc hóa đơn',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue950,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên nhà, số phòng',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.slate200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.slate200),
                      ),
                    ),
                    onChanged: (value) {
                      setSheetState(() => tempSearch = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (hostels.isNotEmpty) ...[
                    const Text(
                      'Chọn nhà',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...hostels.map(
                      (name) => CheckboxListTile(
                        value: tempSelected.contains(name),
                        onChanged: (value) {
                          setSheetState(() {
                            if (value == true) {
                              tempSelected.add(name);
                            } else {
                              tempSelected.remove(name);
                            }
                          });
                        },
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setSheetState(() {
                              tempSearch = '';
                              tempSelected.clear();
                            });
                          },
                          child: const Text('Xóa lọc'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _searchText = tempSearch;
                              _selectedHostels = tempSelected;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Áp dụng'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSend() async {
    setState(() => _isSending = true);

    final usecase = getIt<CreateInvoicesUsecase>();
    final response = await usecase(
      CreateInvoicesParams(
        month: widget.month,
        propertyId: widget.propertyId,
        roomIds: _selectedIds.toList(),
        dueDate: _dueDate,
        isDraft: true,
      ),
    );

    if (!mounted) {
      return;
    }

    final createResult = response.fold<CreateInvoicesResultEntity?>(
      (failure) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.toString())),
        );
        return null;
      },
      (data) => data,
    );

    if (createResult == null) {
      return;
    }

    final invoiceMap = {
      for (final invoice in createResult.invoices) invoice.roomId: invoice.id,
    };

    final updateUsecase = getIt<UpdateInvoiceUsecase>();
    final finalizeUsecase = getIt<FinalizeInvoiceUsecase>();

    final updateResults = await Future.wait(
      _selectedIds.map((roomId) async {
        final invoiceId = invoiceMap[roomId];
        final invoice = _invoiceMap[roomId];
        if (invoiceId == null || invoice == null) {
          return left(const UnknownFailure(message: 'Không tìm thấy hóa đơn.'));
        }

        final items = _buildInvoiceItems(invoice);
        return updateUsecase(
          UpdateInvoiceParams(
            invoiceId: invoiceId,
            items: items,
            dueDate: _dueDate,
          ),
        );
      }),
    );

    Failure? updateFailure;
    for (final result in updateResults) {
      result.fold((failure) => updateFailure = failure, (_) => null);
      if (updateFailure != null) {
        break;
      }
    }

    if (updateFailure != null) {
      setState(() => _isSending = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateFailure.toString())),
      );
      return;
    }

    if (!_isDraft) {
      final finalizeResults = await Future.wait(
        _selectedIds.map((roomId) async {
          final invoiceId = invoiceMap[roomId];
          if (invoiceId == null) {
            return left(
              const UnknownFailure(message: 'Không tìm thấy hóa đơn.'),
            );
          }
          return finalizeUsecase(
            FinalizeInvoiceParams(invoiceId: invoiceId, dueDate: _dueDate),
          );
        }),
      );

      Failure? finalizeFailure;
      for (final result in finalizeResults) {
        result.fold((failure) => finalizeFailure = failure, (_) => null);
        if (finalizeFailure != null) {
          break;
        }
      }

      if (finalizeFailure != null) {
        setState(() => _isSending = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(finalizeFailure.toString())),
        );
        return;
      }
    }

    setState(() => _isSending = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isDraft ? 'Đã lưu hóa đơn nháp.' : 'Đã tạo và chốt hóa đơn.',
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoBanner(),
                const SizedBox(height: 16),
                _buildCreateOptions(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleAll(!_allSelected),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _allSelected
                                  ? AppColors.blue700
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _allSelected
                                    ? AppColors.blue700
                                    : AppColors.slate400,
                                width: 1.5,
                              ),
                            ),
                            child: _allSelected
                                ? const Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Chọn tất cả (${widget.invoices.length})',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue950,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _openFilterSheet,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.blue700,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 32),
                      ),
                      child: const Text(
                        'Lọc',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_visibleInvoices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Không có hóa đơn nào trong kết quả xem trước.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.slate500,
                        ),
                      ),
                    ),
                  )
                else
                  ..._visibleInvoices.map(
                    (invoice) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InvoiceCard(
                        invoice: invoice,
                        isSelected: _selectedIds.contains(invoice.id),
                        onToggleSelect: (val) => _toggleOne(invoice.id, val),
                        onEdit: () {
                          _openEditSheet(invoice);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        InvoiceBottomBar(
          selectedCount: _selectedIds.length,
          totalAmount: _totalAmount,
          onSend: _onSend,
          isLoading: _isSending,
        ),
      ],
    );
  }

  Widget _buildCreateOptions() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: AppColors.blue700),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Kỳ hóa đơn: ${widget.monthLabel}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue950,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDueDate,
            child: Row(
              children: [
                const Icon(Icons.event_available, color: AppColors.slate500),
                const SizedBox(width: 10),
                Expanded(child: Text(_dueDateLabel)),
                const Icon(Icons.chevron_right, color: AppColors.slate400),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isDraft,
              onChanged: (value) => setState(() => _isDraft = value),
              title: const Text('Lưu nháp, chưa gửi cho người thuê'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceEdits {
  const _InvoiceEdits({
    this.rentFee,
    this.electricFee,
    this.waterFee,
    this.serviceFee,
  });

  final int? rentFee;
  final int? electricFee;
  final int? waterFee;
  final int? serviceFee;
}
