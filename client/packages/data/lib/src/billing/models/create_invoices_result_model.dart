import 'package:domain/billing.dart';

import 'created_invoice_model.dart';

class CreateInvoicesResultModel extends CreateInvoicesResultEntity {
  const CreateInvoicesResultModel({
    required super.created,
    required super.invoices,
  });

  factory CreateInvoicesResultModel.fromJson(Map<String, dynamic> json) {
    final invoicesJson = json['invoices'] as List? ?? [];
    return CreateInvoicesResultModel(
      created: (json['created'] as num?)?.toInt() ?? 0,
      invoices:
          invoicesJson
              .map(
                (item) => CreatedInvoiceModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}
