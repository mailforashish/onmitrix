import 'package:flutter/material.dart';
import 'package:onmitrix/models/selection_item.dart';

class SelectionListItem extends StatelessWidget {
  final SelectionItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionListItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}