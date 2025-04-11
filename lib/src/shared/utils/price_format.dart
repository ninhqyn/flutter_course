import 'package:intl/intl.dart';
extension CurrencyFormatExtension on num {
  String toCurrencyVND() {
    final hasFraction = this % 1 != 0;
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: hasFraction ? 2 : 0,
    );
    return formatter.format(this);
  }
}
