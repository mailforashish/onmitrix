class SelectionItem {
  final String id;
  final String title;
  final dynamic value;

  SelectionItem({
    required this.id,
    required this.title,
    this.value,
  });

  factory SelectionItem.fromString(String value) {
    return SelectionItem(
      id: value,
      title: value,
      value: value,
    );
  }
}