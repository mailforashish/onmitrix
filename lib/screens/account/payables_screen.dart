import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onmitrix/utils/animation_utils.dart';
import 'package:onmitrix/widgets/list_items/base_list_item.dart';

class PayablesScreen extends StatefulWidget {
  const PayablesScreen({Key? key}) : super(key: key);

  @override
  State<PayablesScreen> createState() => _PayablesScreenState();
}

class _PayablesScreenState extends State<PayablesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final List<Payable> _payables = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _loadPayables();
  }

  Future<void> _loadPayables() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _payables.addAll([
        Payable(
          id: '1',
          name: 'Electricity Bill',
          amount: 2500,
          dueDate: DateTime.now().add(const Duration(days: 5)),
          description: 'Monthly electricity bill',
          category: 'Utilities',
          status: PayableStatus.upcoming,
          priority: PayablePriority.high,
        ),
        Payable(
          id: '2',
          name: 'Internet Bill',
          amount: 1500,
          dueDate: DateTime.now().add(const Duration(days: 10)),
          description: 'Monthly internet subscription',
          category: 'Utilities',
          status: PayableStatus.upcoming,
          priority: PayablePriority.medium,
        ),
        Payable(
          id: '3',
          name: 'Credit Card Bill',
          amount: 15000,
          dueDate: DateTime.now().subtract(const Duration(days: 2)),
          description: 'Credit card payment',
          category: 'Bills',
          status: PayableStatus.overdue,
          priority: PayablePriority.high,
        ),
      ]);
      
      _animationController.forward();
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {

            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPayables,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: _buildSummaryCard(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final payable = _payables[index];
                          return AnimationUtils.slideTransition(
                            animation: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                (index / _payables.length) * 0.5,
                                min(((index + 1) / _payables.length) * 0.5 + 0.5, 1.0),
                                curve: Curves.easeOut,
                              ),
                            ),
                            direction: SlideDirection.right,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildPayableItem(payable),
                            ),
                          );
                        },
                        childCount: _payables.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalPayable = _payables.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    final overdueAmount = _payables
        .where((p) => p.status == PayableStatus.overdue)
        .fold<double>(0, (sum, item) => sum + item.amount);

    final upcomingAmount = _payables
        .where((p) => p.status == PayableStatus.upcoming)
        .fold<double>(0, (sum, item) => sum + item.amount);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAmountCard(
                    'Total Payable',
                    totalPayable,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAmountCard(
                    'Overdue',
                    overdueAmount,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAmountCard(
                    'Upcoming',
                    upcomingAmount,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPayableItem(Payable payable) {
    return BaseListItem(
      onTap: () {

      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payable.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payable.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              _buildPriorityChip(payable.priority),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${payable.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      payable.category,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusChip(payable.status),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${_formatDate(payable.dueDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(PayableStatus status) {
    Color color;
    String text;

    switch (status) {
      case PayableStatus.paid:
        color = Colors.green;
        text = 'Paid';
        break;
      case PayableStatus.upcoming:
        color = Colors.orange;
        text = 'Upcoming';
        break;
      case PayableStatus.overdue:
        color = Colors.red;
        text = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(PayablePriority priority) {
    Color color;
    String text;

    switch (priority) {
      case PayablePriority.high:
        color = Colors.red;
        text = 'High';
        break;
      case PayablePriority.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case PayablePriority.low:
        color = Colors.green;
        text = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

enum PayableStatus {
  paid,
  upcoming,
  overdue,
}

enum PayablePriority {
  high,
  medium,
  low,
}

class Payable {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final String description;
  final String category;
  final PayableStatus status;
  final PayablePriority priority;

  Payable({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
  });
}