part of 'new_invoice_cubit.dart';

class NewInvoiceState extends Equatable {
  const NewInvoiceState(this.count, {this.latestInvoiceId});

  final int count;
  final String? latestInvoiceId;

  @override
  List<Object?> get props => [count, latestInvoiceId];
}
