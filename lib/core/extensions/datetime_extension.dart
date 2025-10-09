import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Returns the date in dd/MM/yyyy format
  String toFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Returns date and time in dd/MM/yyyy HH:mm format
  String toFormattedDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }
}
