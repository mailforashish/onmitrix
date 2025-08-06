import 'package:flutter/material.dart';
import 'package:onmitrix/utils/hide_status.dart';
import 'package:onmitrix/widgets/dialogs/selection_dialog.dart';
import '../../../models/monthly_overview_data.dart';
import '../../../models/overview_card_data.dart';
import '../../../models/money_overview_data.dart';
import '../../../models/metric_card_data.dart';
import '../../../utils/animation_utils.dart';
import '../../../widgets/cards/overview_card.dart';
import '../../../widgets/cards/metric_card.dart';
import '../../../widgets/cards/money_overview_card.dart';
import '../../../widgets/charts/monthly_overview_chart.dart';
import '../../../widgets/buttons/view_selector_button.dart';
import '../../../widgets/buttons/action_button.dart';
import '../../../models/quick_action.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  final List<OverviewCardData> _overviewCards = [
    OverviewCardData(
      title: 'Total Net Worth',
      amount: '₹0.00',
      subtitle: 'As of 2025-08-06',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
      buttonText: 'Analysis',
    ),
    OverviewCardData(
      title: 'Assets',
      amount: '₹0.00',
      subtitle: '0 items',
      icon: Icons.home,
      color: Colors.green,
      buttonText: 'Add',
    ),
    OverviewCardData(
      title: 'Liabilities',
      amount: '₹0.00',
      subtitle: '0 items',
      icon: Icons.credit_card,
      color: Colors.red,
      buttonText: 'Add',
    ),
    OverviewCardData(
      title: 'Investments',
      amount: '₹0.00',
      subtitle: 'Portfolio',
      icon: Icons.trending_up,
      color: Colors.purple,
      buttonText: 'View',
    ),
    OverviewCardData(
      title: 'Liquid Savings',
      amount: '₹0.00',
      subtitle: '0 items',
      icon: Icons.library_add,
      color: Colors.purple,
      buttonText: '',
    ),
  ];

  String _selectedYear = '2025-2026';
  final List<String> _years = [
    '2023-2024',
    '2024-2025',
    '2025-2026',
    '2026-2027',
    '2027-2028'
  ];

  final List<MetricCardData> _metricCards = [
    MetricCardData(
      title: 'Income',
      amount: '₹0.00',
      color: Colors.green,
      icon: Icons.trending_up,
      buttonText: 'Manage Income',
    ),
    MetricCardData(
      title: 'Expenses',
      amount: '₹0.00',
      color: Colors.red,
      icon: Icons.trending_down,
      buttonText: 'Manage Expenses',
    ),
    MetricCardData(
      title: 'Investments',
      amount: '₹0.00',
      color: Colors.blue,
      icon: Icons.account_balance,
      buttonText: 'Manage Investments',
    ),
    MetricCardData(
      title: 'Net Savings',
      amount: '₹0.00',
      color: Colors.purple,
      icon: Icons.savings,
      buttonText: 'Income - Expenses',
      isButton: false,
    ),
  ];

  final List<MoneyOverviewData> _moneyOverviewCards = [
    MoneyOverviewData(
      title: 'Money Owed to You',
      total: '₹0.00',
      pending: '0',
      overdue: '0',
      color: Colors.green,
      buttonText: 'View Receivables',
    ),
    MoneyOverviewData(
      title: 'Money You Owe',
      total: '₹0.00',
      pending: '0',
      overdue: '0',
      color: Colors.orange,
      buttonText: 'View Payables',
    ),
  ];

  final List<MonthlyData> monthlyDataList = [
    MonthlyData(month: 'Apr', income: 0.5, expenses: 0.3, investments: 0.2),
    MonthlyData(month: 'May', income: 0.8, expenses: 0.6, investments: 0.1),
    MonthlyData(month: 'Jun', income: 1.0, expenses: 0.7, investments: 0.4),
    MonthlyData(month: 'Jul', income: 0.9, expenses: 0.5, investments: 0.3),
    MonthlyData(month: 'Aug', income: 0.6, expenses: 0.4, investments: 0.2),
    MonthlyData(month: 'Sep', income: 0.7, expenses: 0.3, investments: 0.3),
    MonthlyData(month: 'Oct', income: 1.1, expenses: 0.6, investments: 0.5),
    MonthlyData(month: 'Nov', income: 0.8, expenses: 0.4, investments: 0.2),
    MonthlyData(month: 'Dec', income: 0.9, expenses: 0.7, investments: 0.3),
    MonthlyData(month: 'Jan', income: 0.6, expenses: 0.5, investments: 0.1),
    MonthlyData(month: 'Feb', income: 0.7, expenses: 0.6, investments: 0.4),
    MonthlyData(month: 'Mar', income: 1.0, expenses: 0.8, investments: 0.3),
  ];

  final List<QuickAction> _quickActions = [
    QuickAction(
      'Upload Statement',
      Icons.upload_file,
      const Color(0xFF2B4380),
      () {
        debugPrint('Upload Statement tapped');
        // Add your upload statement logic here
      },
    ),
    QuickAction(
      'Add Income',
      Icons.add,
      Colors.green,
      () {
        debugPrint('Add Income tapped');
        // Add your income logic here
      },
    ),
    QuickAction(
      'Add Expense',
      Icons.remove,
      Colors.redAccent,
      () {
        debugPrint('Add Expense tapped');
        // Add your expense logic here
      },
    ),
    QuickAction(
      'Add Investment',
      Icons.trending_up,
      Colors.blue,
      () {
        debugPrint('Add Investment tapped');
        // Add your investment logic here
      },
    ),
    QuickAction(
      'View Transactions',
      Icons.format_list_bulleted,
      Colors.grey[700]!,
      () {
        debugPrint('View Transactions tapped');
        // Add your transactions view logic here
      },
    ),
    QuickAction(
      'View Categories',
      Icons.pie_chart,
      Colors.orange,
      () {
        debugPrint('Expense Categories tapped');
        // Add your categories logic here
      },
    ),
  ];

  late AnimationController _controller;
  bool _isFinancialYearView = true;
  int _currentOverviewIndex = 0;

  @override
  void initState() {
    super.initState();
    StatusBarConfig.setCustomStatusBar(
      statusBarColor: Color(0xFF2B4380),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  void _showYearSelector() async {
    await SelectionDialog.show(
      context: context,
      title: 'Select Financial Year',
      items: _years,
      selectedItem: _selectedYear,
      onSelect: (year) {
        setState(() {
          _selectedYear = year;
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height * 0.18;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Net Worth Overview
              AnimationUtils.fadeInTransition(
                animation: _controller,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B4380),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Net Worth Overview',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Detailed Analysis',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: (cardHeight * 1.2),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification
                                is ScrollUpdateNotification) {
                              final currentPixels =
                                  scrollNotification.metrics.pixels;
                              final viewportWidth =
                                  MediaQuery.of(context).size.width * 0.85;
                              final spacing = 12.0; // Same as separator width
                              final totalWidth = viewportWidth + spacing;
                              final newIndex =
                                  (currentPixels / totalWidth).round();
                              if (newIndex != _currentOverviewIndex) {
                                setState(
                                    () => _currentOverviewIndex = newIndex);
                              }
                            }
                            return true;
                          },
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: _overviewCards.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final cardData = _overviewCards[index];
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: OverviewCard(
                                  title: cardData.title,
                                  amount: cardData.amount,
                                  subtitle: cardData.subtitle,
                                  icon: cardData.icon,
                                  color: cardData.color,
                                  buttonText: cardData.buttonText,
                                  onButtonPressed: cardData.onButtonPressed,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _overviewCards.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentOverviewIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // View Selector
              AnimationUtils.slideTransition(
                animation: _controller,
                direction: SlideDirection.right,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ViewSelectorButton(
                            text: 'Financial Year View',
                            icon: Icons.calendar_today,
                            isSelected: _isFinancialYearView,
                            onTap: () =>
                                setState(() => _isFinancialYearView = true),
                          ),
                        ),
                        Expanded(
                          child: ViewSelectorButton(
                            text: 'Calendar Year View',
                            icon: Icons.calendar_month,
                            isSelected: !_isFinancialYearView,
                            onTap: () =>
                                setState(() => _isFinancialYearView = false),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Year Selector and Financial Summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Year: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: _showYearSelector,
                            child: Row(
                              children: [
                                Text(
                                  _selectedYear,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimationUtils.slideTransition(
                      animation: _controller,
                      direction: SlideDirection.right,
                      child: Column(
                        children: List.generate(
                          (_metricCards.length / 2).ceil(),
                          (rowIndex) => Padding(
                            padding: EdgeInsets.only(
                              bottom: rowIndex <
                                      (_metricCards.length / 2).ceil() - 1
                                  ? 12
                                  : 0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MetricCard(
                                    title: _metricCards[rowIndex * 2].title,
                                    amount: _metricCards[rowIndex * 2].amount,
                                    color: _metricCards[rowIndex * 2].color,
                                    icon: _metricCards[rowIndex * 2].icon,
                                    buttonText:
                                        _metricCards[rowIndex * 2].buttonText,
                                    isButton:
                                        _metricCards[rowIndex * 2].isButton,
                                    onPressed:
                                        _metricCards[rowIndex * 2].onPressed,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (rowIndex * 2 + 1 < _metricCards.length)
                                  Expanded(
                                    child: MetricCard(
                                      title:
                                          _metricCards[rowIndex * 2 + 1].title,
                                      amount:
                                          _metricCards[rowIndex * 2 + 1].amount,
                                      color:
                                          _metricCards[rowIndex * 2 + 1].color,
                                      icon: _metricCards[rowIndex * 2 + 1].icon,
                                      buttonText: _metricCards[rowIndex * 2 + 1]
                                          .buttonText,
                                      isButton: _metricCards[rowIndex * 2 + 1]
                                          .isButton,
                                      onPressed: _metricCards[rowIndex * 2 + 1]
                                          .onPressed,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Money Overview Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: List.generate(
                    _moneyOverviewCards.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right:
                              index < _moneyOverviewCards.length - 1 ? 12 : 0,
                        ),
                        child: MoneyOverviewCard(
                          title: _moneyOverviewCards[index].title,
                          total: _moneyOverviewCards[index].total,
                          pending: _moneyOverviewCards[index].pending,
                          overdue: _moneyOverviewCards[index].overdue,
                          color: _moneyOverviewCards[index].color,
                          buttonText: _moneyOverviewCards[index].buttonText,
                          onPressed: _moneyOverviewCards[index].onPressed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Net Impact Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Net Impact on Net Worth',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Receivables add to your net worth, while payables reduce it. This shows your true financial position including money owed.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            '₹0.00',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'Net Positive',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Monthly Overview Chart
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: MonthlyOverviewChart(data: monthlyDataList),
                        ),
                        // This transparent container prevents the chart's touch events from affecting other widgets
                        Positioned.fill(
                          child: IgnorePointer(
                            ignoring: true,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Actions Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Margin for both title and container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placed outside the decorated container
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Container with decoration
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: AnimationUtils.slideTransition(
                        animation: _controller,
                        direction: SlideDirection.right,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: List.generate(
                              (_quickActions.length / 2).ceil(),
                              (rowIndex) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: rowIndex <
                                          (_quickActions.length / 2).ceil() - 1
                                      ? 12
                                      : 0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ActionButton(
                                        text: _quickActions[rowIndex * 2].text,
                                        icon: _quickActions[rowIndex * 2].icon,
                                        color:
                                            _quickActions[rowIndex * 2].color,
                                        onPressed: _quickActions[rowIndex * 2]
                                            .onPressed,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    if (rowIndex * 2 + 1 < _quickActions.length)
                                      Expanded(
                                        child: ActionButton(
                                          text: _quickActions[rowIndex * 2 + 1]
                                              .text,
                                          icon: _quickActions[rowIndex * 2 + 1]
                                              .icon,
                                          color: _quickActions[rowIndex * 2 + 1]
                                              .color,
                                          onPressed:
                                              _quickActions[rowIndex * 2 + 1]
                                                  .onPressed,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
