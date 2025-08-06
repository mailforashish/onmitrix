class MonthlyData {
  final double income;
  final double expenses;
  final double investments;
  final String month;

  const MonthlyData({
    required this.income,
    required this.expenses,
    required this.investments,
    required this.month,
  });

  // Factory constructor for creating dummy data
  static List<MonthlyData> getDummyData() {
    final months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
    return List.generate(
      months.length,
      (index) => MonthlyData(
        month: months[index],
        income: 0,
        expenses: 0,
        investments: 0,
      ),
    );
  }

  // Format value to INR string
  static String formatValue(double value) {
    return 'INR ${value.toStringAsFixed(2)}';
  }
}