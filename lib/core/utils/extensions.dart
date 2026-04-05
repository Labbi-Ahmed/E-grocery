import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  String get capitalizeWords =>
      split(' ').map((w) => w.capitalize).join(' ');
}

extension DoubleExtension on double {
  String get toCurrency => NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);

  String get toPrice => NumberFormat('#,##0.00').format(this);
}

extension DateTimeExtension on DateTime {
  String get toFormattedDate => DateFormat('MMM dd, yyyy').format(this);

  String get toFormattedDateTime => DateFormat('MMM dd, yyyy HH:mm').format(this);

  String get toOrderDate => DateFormat('dd MMM yyyy').format(this);

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
