class InvoicePreview {
  final String id;
  final String hostelName;
  final String roomNumber;
  final int rentFee;
  final int electricKwh;
  final int electricFee;
  final int waterM3;
  final int waterFee;
  final int serviceFee;

  const InvoicePreview({
    required this.id,
    required this.hostelName,
    required this.roomNumber,
    required this.rentFee,
    required this.electricKwh,
    required this.electricFee,
    required this.waterM3,
    required this.waterFee,
    required this.serviceFee,
  });

  int get total => rentFee + electricFee + waterFee + serviceFee;

  factory InvoicePreview.fromJson(Map<String, dynamic> json) {
    return InvoicePreview(
      id: json['id'] as String,
      hostelName: json['hostelName'] as String,
      roomNumber: json['roomNumber'] as String,
      rentFee: json['rentFee'] as int,
      electricKwh: json['electricKwh'] as int,
      electricFee: json['electricFee'] as int,
      waterM3: json['waterM3'] as int,
      waterFee: json['waterFee'] as int,
      serviceFee: json['serviceFee'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostelName': hostelName,
    'roomNumber': roomNumber,
    'rentFee': rentFee,
    'electricKwh': electricKwh,
    'electricFee': electricFee,
    'waterM3': waterM3,
    'waterFee': waterFee,
    'serviceFee': serviceFee,
  };
}
