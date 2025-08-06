// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Investment _$InvestmentFromJson(Map<String, dynamic> json) => Investment(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      isActive: json['isActive'] as bool,
      category: json['category'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$InvestmentToJson(Investment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'amount': instance.amount,
      'date': instance.date,
      'isActive': instance.isActive,
      'category': instance.category,
      'notes': instance.notes,
    };
