import 'package:flutter/material.dart';
import 'package:onmitrix/models/selection_item.dart';
import 'package:onmitrix/widgets/list_items/selection_list_item.dart';

class SelectionDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onSelect;
  final String? selectedItem;

  const SelectionDialog({
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
    this.selectedItem,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelect,
    String? selectedItem,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => SelectionDialog(
        title: title,
        items: items,
        onSelect: onSelect,
        selectedItem: selectedItem,
      ),
    );
  }

  @override
  State<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final selectionItem = SelectionItem(
                    id: item,
                    title: item,
                    value: item,
                  );
                  
                  return SelectionListItem(
                    item: selectionItem,
                    isSelected: _selectedItem == item,
                    onTap: () {
                      setState(() {
                        _selectedItem = item;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _selectedItem == null
                      ? null
                      : () {
                          widget.onSelect(_selectedItem!);
                          Navigator.of(context).pop();
                        },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}