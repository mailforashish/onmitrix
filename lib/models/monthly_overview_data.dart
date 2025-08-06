class MonthlyData {
  final String month;
  final double income;
  final double expenses;
  final double investments;

  MonthlyData({
    required this.month,
    required this.income,
    required this.expenses,
    required this.investments,
  });

  static String formatValue(double value) {
    if (value >= 1000000) {
      return 'INR ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'INR ${(value / 1000).toStringAsFixed(1)}K';
    }
    return 'INR ${value.toStringAsFixed(1)}';
  }
}