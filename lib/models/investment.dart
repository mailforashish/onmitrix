import 'package:json_annotation/json_annotation.dart';

part 'investment.g.dart';

@JsonSerializable()
class Investment {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String date;
  final bool isActive;
  final String? category;
  final String? notes;

  Investment({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.isActive,
    this.category,
    this.notes,
  });

  factory Investment.fromJson(Map<String, dynamic> json) =>
      _$InvestmentFromJson(json);

  Map<String, dynamic> toJson() => _$InvestmentToJson(this);
}