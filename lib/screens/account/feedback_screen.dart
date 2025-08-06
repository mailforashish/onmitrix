import 'package:flutter/material.dart';
import 'package:onmitrix/utils/animation_utils.dart';
import 'package:onmitrix/widgets/buttons/primary_button.dart';
import 'package:onmitrix/widgets/inputs/custom_text_input.dart';
import 'package:onmitrix/widgets/dialogs/selection_dialog.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _selectedType = 'General';
  String _selectedPriority = 'Medium';
  bool _isLoading = false;

  final List<String> _types = ['General', 'Bug Report', 'Feature Request', 'Other'];
  final List<String> _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  void _showTypeSelection() async {
    await SelectionDialog.show(
      context: context,
      title: 'Select Type',
      items: _types,
      selectedItem: _selectedType,
      onSelect: (type) {
        setState(() => _selectedType = type);
      },
    );
  }

  void _showPrioritySelection() async {
    await SelectionDialog.show(
      context: context,
      title: 'Select Priority',
      items: _priorities,
      selectedItem: _selectedPriority,
      onSelect: (priority) {
        setState(() => _selectedPriority = priority);
      },
    );
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit feedback')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/my_feedback');
            },
            child: const Text(
              'My Feedback',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.0, 0.3),
                ),
                direction: SlideDirection.right,
                child: CustomTextInput(
                  label: 'Title',
                  hint: 'Title',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Message Input
              AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.1, 0.4),
                ),
                direction: SlideDirection.right,
                child: CustomTextInput(
                  label: 'Message',
                  hint: 'Message',
                  controller: _messageController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Type Selection
              AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.2, 0.5),
                ),
                direction: SlideDirection.right,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showTypeSelection,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedType),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Priority Selection
              AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.3, 0.6),
                ),
                direction: SlideDirection.right,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showPrioritySelection,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedPriority),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.6, 0.9),
                ),
                direction: SlideDirection.up,
                child: PrimaryButton(
                  text: 'Submit Feedback',
                  onPressed: _submitFeedback,
                  isLoading: _isLoading,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}