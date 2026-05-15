import 'package:intl/intl.dart';

class MealEntry {
  final String id;
  final DateTime dateTime;
  final int totalCal;
  final int protein;
  final int carbs;
  final int fat;
  final List<String> items;
  final String tip;

  MealEntry({
    required this.id,
    required this.dateTime,
    required this.totalCal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.items,
    required this.tip,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'totalCal': totalCal,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'items': items,
      'tip': tip,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      totalCal: json['totalCal'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      items: List<String>.from(json['items']),
      tip: json['tip'],
    );
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(dateTime);
  String get formattedTime => DateFormat('hh:mm a').format(dateTime);
}
