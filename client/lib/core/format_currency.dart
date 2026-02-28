import 'package:intl/intl.dart';

String formatVND(int price) {
  return NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  ).format(price);
}

String formatCurrency(double price) {
  if (price >= 1000000000) {
    return '${(price / 1000000000).toStringAsFixed(1)} tỷ';
  } else if (price >= 1000000) {
    return '${(price / 1000000).toStringAsFixed(1)}tr';
  } else if (price >= 1000) {
    return '${(price / 1000).toStringAsFixed(1)} nghìn';
  } else {
    return price.toString();
  }
}