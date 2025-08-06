import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onmitrix/utils/animation_utils.dart';
import 'package:onmitrix/widgets/list_items/base_list_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TabController _tabController;
  final List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _tabController = TabController(length: 3, vsync: this);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _categories.addAll([
        Category(
          id: '1',
          name: 'Utilities',
          type: CategoryType.expense,
          icon: Icons.lightbulb_outline,
          color: Colors.orange,
          transactionCount: 15,
        ),
        Category(
          id: '2',
          name: 'Salary',
          type: CategoryType.income,
          icon: Icons.work_outline,
          color: Colors.green,
          transactionCount: 12,
        ),
        Category(
          id: '3',
          name: 'Stocks',
          type: CategoryType.investment,
          icon: Icons.show_chart,
          color: Colors.blue,
          transactionCount: 8,
        ),
      ]);
      
      _animationController.forward();
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Category> _getFilteredCategories(CategoryType type) {
    return _categories.where((c) => c.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
            Tab(text: 'Investment'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryList(CategoryType.income),
                _buildCategoryList(CategoryType.expense),
                _buildCategoryList(CategoryType.investment),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryList(CategoryType type) {
    final categories = _getFilteredCategories(type);
    
    return categories.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${type.name} categories yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return AnimationUtils.slideTransition(
                animation: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (index / categories.length) * 0.6,
                    min(((index + 1) / categories.length) * 0.6 + 0.4, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
                direction: SlideDirection.right,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryItem(category),
                ),
              );
            },
          );
  }

  Widget _buildCategoryItem(Category category) {
    return BaseListItem(
      onTap: () {
        // TODO: Show category details or edit
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.transactionCount} transactions',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: Edit category
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showDeleteConfirmation(category);
            },
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CategoryType>(
              value: CategoryType.expense,
              decoration: const InputDecoration(
                labelText: 'Category Type',
              ),
              items: CategoryType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) {
                // Handle type change
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Save category
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete category
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

enum CategoryType {
  income,
  expense,
  investment,
}

class Category {
  final String id;
  final String name;
  final CategoryType type;
  final IconData icon;
  final Color color;
  final int transactionCount;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.transactionCount,
  });
}