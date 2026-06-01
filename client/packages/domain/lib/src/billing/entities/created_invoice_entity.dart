import 'package:equatable/equatable.dart';

class CreatedInvoiceEntity extends Equatable {
  const CreatedInvoiceEntity({
    required this.id,
    required this.roomId,
  });

  final String id;
  final String roomId;

  @override
  List<Object?> get props => [id, roomId];
}
