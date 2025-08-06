import 'package:flutter/material.dart';
import 'package:onmitrix/utils/animation_utils.dart';
import 'package:onmitrix/widgets/buttons/primary_button.dart';
import 'package:onmitrix/widgets/inputs/custom_text_input.dart';

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({Key? key}) : super(key: key);

  @override
  State<ReceivablesScreen> createState() => _ReceivablesScreenState();
}

class _ReceivablesScreenState extends State<ReceivablesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final List<Receivable> _receivables = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _loadReceivables();
    _animationController.forward();
  }

  Future<void> _loadReceivables() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Sample data
      _receivables.addAll([
        Receivable(
          id: '1',
          amount: 1000,
          description: 'Loan to John',
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: ReceivableStatus.pending,
        ),
        Receivable(
          id: '2',
          amount: 500,
          description: 'Project payment',
          dueDate: DateTime.now().add(const Duration(days: 15)),
          status: ReceivableStatus.overdue,
        ),
      ]);
      
      setState(() {});
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAddReceivableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Receivable'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: 'Amount',
                hint: 'Enter amount',
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value!);
                  if (amount == null || amount <= 0) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                label: 'Description',
                hint: 'Enter description',
                controller: _descriptionController,
                maxLines: 2,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                label: 'Due Date',
                hint: 'Select due date',
                controller: _dueDateController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    _dueDateController.text = date.toString().split(' ')[0];
                  }
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please select due date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Add receivable logic here
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receivables'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _receivables.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No receivables yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'Add Receivable',
                        onPressed: _showAddReceivableDialog,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _receivables.length,
                  itemBuilder: (context, index) {
                    final receivable = _receivables[index];
                    return AnimationUtils.slideTransition(
                      animation: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          index * 0.1,
                          (index + 1) * 0.1,
                        ),
                      ),
                      direction: SlideDirection.right,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildReceivableItem(receivable),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReceivableDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReceivableItem(Receivable receivable) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: receivable.status.color.withOpacity(0.1),
          child: Icon(
            receivable.status.icon,
            color: receivable.status.color,
          ),
        ),
        title: Text(
          receivable.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Due: ${receivable.dueDate.toString().split(' ')[0]}',
          style: TextStyle(
            color: receivable.status == ReceivableStatus.overdue
                ? Colors.red
                : Colors.grey[600],
          ),
        ),
        trailing: Text(
          '₹${receivable.amount}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Show receivable details
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }
}

class Receivable {
  final String id;
  final double amount;
  final String description;
  final DateTime dueDate;
  final ReceivableStatus status;

  const Receivable({
    required this.id,
    required this.amount,
    required this.description,
    required this.dueDate,
    required this.status,
  });
}

enum ReceivableStatus {
  pending(
    icon: Icons.pending_outlined,
    color: Colors.orange,
  ),
  paid(
    icon: Icons.check_circle_outline,
    color: Colors.green,
  ),
  overdue(
    icon: Icons.warning_outlined,
    color: Colors.red,
  );

  final IconData icon;
  final Color color;

  const ReceivableStatus({
    required this.icon,
    required this.color,
  });
}