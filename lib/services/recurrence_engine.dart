import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import '../data/database.dart';

/// Pure-Dart recurrence engine. No packages.
///
/// When a recurring task is completed, call [onTaskCompleted] instead of
/// simply setting done=true. It will reset the task and advance [nextDue].
class RecurrenceEngine {
  /// Compute the next due date for a recurrence after [completedAt].
  DateTime computeNextDue(Recurrence r, DateTime completedAt) {
    switch (r.type) {
      case 'daily':
        return _nextDaily(r, completedAt);
      case 'weekly':
        return _nextWeekly(r, completedAt);
      case 'monthly':
        return _nextMonthly(r, completedAt);
      default:
        return completedAt.add(Duration(days: 1));
    }
  }

  DateTime _nextDaily(Recurrence r, DateTime from) {
    return from.add(Duration(days: r.interval));
  }

  DateTime _nextWeekly(Recurrence r, DateTime from) {
    final weekdays = _parseWeekdays(r.weekdays);
    if (weekdays.isEmpty) {
      return from.add(Duration(days: 7 * r.interval));
    }
    // Find the next weekday after [from] that is in the weekdays list.
    DateTime candidate = from.add(Duration(days: 1));
    for (int i = 0; i < 7 * r.interval; i++) {
      if (weekdays.contains(candidate.weekday)) return candidate;
      candidate = candidate.add(Duration(days: 1));
    }
    return candidate;
  }

  DateTime _nextMonthly(Recurrence r, DateTime from) {
    int month = from.month + r.interval;
    int year = from.year + (month - 1) ~/ 12;
    month = ((month - 1) % 12) + 1;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final day = from.day.clamp(1, daysInMonth);
    return DateTime(year, month, day);
  }

  List<int> _parseWeekdays(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      final decoded = jsonDecode(json) as List;
      return decoded.cast<int>();
    } catch (_) {
      return [];
    }
  }

  /// Returns updated companions to apply when a recurring task is completed.
  /// Caller is responsible for writing these to the DB.
  ({
    TasksCompanion task,
    RecurrencesCompanion recurrence,
  }) onTaskCompleted({
    required Task task,
    required Recurrence recurrence,
    required DateTime completedAt,
  }) {
    final nextDue = computeNextDue(recurrence, completedAt);

    // Reset the task: not done, new due date.
    final updatedTask = TasksCompanion(
      id: Value(task.id),
      done: Value(false),
      dueDate: Value(nextDue),
      updatedAt: Value(DateTime.now()),
    );

    // Advance nextDue in recurrence row.
    final updatedRecurrence = RecurrencesCompanion(
      id: Value(recurrence.id),
      nextDue: Value(nextDue),
    );

    return (task: updatedTask, recurrence: updatedRecurrence);
  }
}
