import 'package:flutter/material.dart';
import '../../../models/more_menu_item.dart';
import '../../../widgets/cards/more_menu_card.dart';
import '../../../utils/animation_utils.dart';
import '../../../utils/hide_status.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({Key? key}) : super(key: key);

  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
      void initState() {
      super.initState();
      StatusBarConfig.setLightStatusBar();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MoreMenuItem> menuItems = [
      const MoreMenuItem(
        title: 'My Account',
        icon: 'assets/images/person.svg',
        route: '/my-account',
      ),
      const MoreMenuItem(
        title: 'Categories',
        icon: 'assets/images/category.svg',
        route: '/categories',
      ),
      const MoreMenuItem(
        title: 'Payables',
        icon: 'assets/images/money_bag_small.svg',
        route: '/payables',
      ),
      const MoreMenuItem(
        title: 'Receivables',
        icon: 'assets/images/money_bag.svg',
        route: '/receivables',
      ),
      const MoreMenuItem(
        title: 'Feedback',
        icon: 'assets/images/feedback.svg',
        route: '/feedback',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'More',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return AnimationUtils.slideTransition(
              animation: CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  index * 0.1,
                  1.0,
                  curve: Curves.easeOut,
                ),
              ),
              direction: SlideDirection.right,
              child: MoreMenuCard(
                item: item,
                index: index,
                onTap: () {
                  // Navigate to the respective screen
                  Navigator.pushNamed(context, item.route);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
