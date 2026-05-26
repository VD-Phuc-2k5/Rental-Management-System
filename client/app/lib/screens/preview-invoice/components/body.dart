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
  });
  final List<InvoicePreview> invoices;
  final String month;

  @override
  State<PreviewInvoceBody> createState() => _PreviewInvoceBodyState();
}

class _PreviewInvoceBodyState extends State<PreviewInvoceBody> {
  late final Set<String> _selectedIds;
  bool _isSending = false;
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
      final matchesHostel = _selectedHostels.isEmpty ||
          _selectedHostels.contains(invoice.hostelName);
      if (!matchesHostel) {
        return false;
      }
      if (search.isEmpty) {
        return true;
      }
      final haystack =
          '${invoice.hostelName} ${invoice.roomNumber}'.toLowerCase();
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
                'Sua hoa don phong ${invoice.roomNumber}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue950,
                ),
              ),
              const SizedBox(height: 12),
              _buildAmountField('Tien phong', rentController),
              const SizedBox(height: 12),
              _buildAmountField(
                'Dien (${invoice.electricKwh} so)',
                electricController,
              ),
              const SizedBox(height: 12),
              _buildAmountField(
                'Nuoc (${invoice.waterM3}m3)',
                waterController,
              ),
              const SizedBox(height: 12),
              _buildAmountField('Dich vu', serviceController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Huy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final rentFee = _parseAmount(rentController.text);
                        final electricFee =
                            _parseAmount(electricController.text);
                        final waterFee = _parseAmount(waterController.text);
                        final serviceFee =
                            _parseAmount(serviceController.text);

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
                      child: const Text('Luu'),
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

    final electricUnit =
      electricQty > 0 ? (electricFee / electricQty).toDouble() : 0.0;
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
    final hostels = widget.invoices
        .map((invoice) => invoice.hostelName)
        .toSet()
        .toList()
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
                    'Loc hoa don',
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
                      hintText: 'Tim theo ten nha, so phong',
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
                      'Chon nha',
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
                          child: const Text('Xoa loc'),
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
                          child: const Text('Ap dung'),
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
        roomIds: _selectedIds.toList(),
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
      for (final invoice in createResult.invoices)
        invoice.roomId: invoice.id,
    };

    final updateUsecase = getIt<UpdateInvoiceUsecase>();
    final finalizeUsecase = getIt<FinalizeInvoiceUsecase>();

    final updateResults = await Future.wait(
      _selectedIds.map((roomId) async {
        final invoiceId = invoiceMap[roomId];
        final invoice = _invoiceMap[roomId];
        if (invoiceId == null || invoice == null) {
          return left(const UnknownFailure(message: 'Khong tim thay hoa don.'));
        }

        final items = _buildInvoiceItems(invoice);
        return updateUsecase(
          UpdateInvoiceParams(invoiceId: invoiceId, items: items),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateFailure.toString())),
      );
      return;
    }

    final finalizeResults = await Future.wait(
      _selectedIds.map((roomId) async {
        final invoiceId = invoiceMap[roomId];
        if (invoiceId == null) {
          return left(const UnknownFailure(message: 'Khong tim thay hoa don.'));
        }
        return finalizeUsecase(
          FinalizeInvoiceParams(invoiceId: invoiceId),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(finalizeFailure.toString())),
      );
      return;
    }

    setState(() => _isSending = false);

    if (mounted) {
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
