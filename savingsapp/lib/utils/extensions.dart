import 'package:intl/intl.dart';

/// Extension on `double` to provide custom amount formatting
extension AmountFormatting on double {
  /// Formats the double value as a currency amount
  /// using Indian locale (en_IN) without a currency symbol.
  /// 
  /// Example:
  /// ```dart
  /// double amount = 1234567.89;
  /// String formatted = amount.formatAmount();
  /// print(formatted); // Output: 12,34,567.89
  /// ```
  String formatAmount() {
    // Create a NumberFormat object for Indian currency style
    final formatCurrency = NumberFormat.currency(
      locale: 'en_IN',  // Indian locale for lakh/crore formatting
      symbol: '',       // No currency symbol (e.g., ₹) is used
    );
    // Format the double value and return it as a String
    return formatCurrency.format(this);
  }
}
