import 'package:flutter/material.dart';
import 'package:onmitrix/utils/animation_utils.dart';
import 'package:onmitrix/widgets/buttons/primary_button.dart';
import 'package:onmitrix/widgets/inputs/custom_text_input.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  int _selectedRating = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate() || _selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide both rating and feedback'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit feedback. Please try again.'),
        ),
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
        title: const Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimationUtils.fadeInTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.0, 0.3),
                ),
                child: _buildRatingSection(),
              ),
              const SizedBox(height: 32),
              AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.3, 0.6),
                ),
                direction: SlideDirection.right,
                child: _buildFeedbackSection(),
              ),
              const SizedBox(height: 32),
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

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How would you rate our app?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final rating = index + 1;
            return InkWell(
              onTap: () {
                setState(() => _selectedRating = rating);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _selectedRating == rating
                      ? Theme.of(context).primaryColor
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: _selectedRating == rating
                          ? Colors.white
                          : Colors.grey[400],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        color: _selectedRating == rating
                            ? Colors.white
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us more about your experience',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextInput(
          label: 'Feedback',
          hint: 'Write your feedback here...',
          controller: _feedbackController,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide your feedback';
            }
            if (value.length < 10) {
              return 'Feedback must be at least 10 characters long';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Your feedback helps us improve the app for everyone.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}