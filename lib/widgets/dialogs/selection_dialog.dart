import 'package:flutter/material.dart';

class SelectionDialog extends StatelessWidget {
  final String title;
  final List<SelectionItem> items;
  final Function(SelectionItem) onItemSelected;

  const SelectionDialog({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onItemSelected(item);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SelectionItem {
  final String id;
  final String title;
  final dynamic data;

  SelectionItem({
    required this.id,
    required this.title,
    this.data,
  });
}