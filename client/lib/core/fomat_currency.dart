import 'package:intl/intl.dart';

String formatVND(int price) {
  return NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  ).format(price);
}
