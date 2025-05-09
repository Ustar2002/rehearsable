// lib/models/schedule.dart
import 'package:flutter/material.dart';
class Reservation {
  final String title;
  final String location;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  Reservation({
    required this.title,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
  int get daysRemaining {
    final today = DateTime.now();
    final diff = DateTime(date.year, date.month, date.day)
        .difference(DateTime(today.year, today.month, today.day));
    return diff.inDays;
  }
}
