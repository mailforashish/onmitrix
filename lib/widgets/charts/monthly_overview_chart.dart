import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/monthly_overview_data.dart';

class MonthlyOverviewChart extends StatefulWidget {
  final List<MonthlyData>? data;

  const MonthlyOverviewChart({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<MonthlyOverviewChart> createState() => _MonthlyOverviewChartState();
}

class _MonthlyOverviewChartState extends State<MonthlyOverviewChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String formatCurrency(double value) {
    if (value >= 1000000) {
      return 'INR ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'INR ${(value / 1000).toStringAsFixed(1)}K';
    }
    return 'INR ${value.toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data ?? [];
    final maxX = (data.length - 1).toDouble();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLegendItem('Income', Colors.green),
              const SizedBox(width: 16),
              _buildLegendItem('Expenses', Colors.red),
              const SizedBox(width: 16),
              _buildLegendItem('Investments', Colors.blue),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      interval: 0.2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          formatCurrency(value),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Text(
                            data[index].month,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: maxX,
                lineBarsData: [
                  // Income Line
                  LineChartBarData(
                    spots: (widget.data ?? []).asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.income * _animation.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.green,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                  // Expenses Line
                  LineChartBarData(
                    spots: (widget.data ?? []).asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.expenses * _animation.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.1),
                    ),
                  ),
                  // Investments Line
                  LineChartBarData(
                    spots: (widget.data ?? []).asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.investments * _animation.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final monthData = widget.data?[spot.x.toInt()];
                        final type = spot.barIndex == 0
                            ? 'Income'
                            : spot.barIndex == 1
                            ? 'Expenses'
                            : 'Investments';
                        final value = spot.barIndex == 0
                            ? monthData?.income
                            : spot.barIndex == 1
                            ? monthData?.expenses
                            : monthData?.investments;
                        return LineTooltipItem(
                          '${monthData?.month}\n$type: INR ${value?.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}