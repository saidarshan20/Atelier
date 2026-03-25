import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/database_provider.dart';

// ── All tasks (non-done) ──────────────────────────────────────────────────────

final allTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(databaseProvider).watchAllTasks();
});

// ── Today ─────────────────────────────────────────────────────────────────────

final todayTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(databaseProvider).watchTodayTasks();
});

// ── Upcoming (after today, with a date) ───────────────────────────────────────

final upcomingTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(databaseProvider).watchUpcomingTasks();
});

// ── Inbox (no due date) ───────────────────────────────────────────────────────

final inboxTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(databaseProvider).watchInboxTasks();
});

// ── Overdue (past due date, not done) ─────────────────────────────────────────

final overdueTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(databaseProvider).watchOverdueTasks();
});

// ── Tasks by a specific date (Calendar) ───────────────────────────────────────

final tasksByDateProvider =
    StreamProvider.family<List<Task>, DateTime>((ref, date) {
  return ref.watch(databaseProvider).watchTasksByDate(date);
});

// ── Tasks by project ──────────────────────────────────────────────────────────

final tasksByProjectProvider =
    StreamProvider.family<List<Task>, String>((ref, projectId) {
  return ref.watch(databaseProvider).watchTasksByProject(projectId);
});

// ── Subtasks for a task ───────────────────────────────────────────────────────

final subtasksProvider =
    StreamProvider.family<List<Subtask>, String>((ref, taskId) {
  return ref.watch(databaseProvider).watchSubtasks(taskId);
});

// ── Time logs for a task ──────────────────────────────────────────────────────

final timeLogsProvider =
    StreamProvider.family<List<TimeLog>, String>((ref, taskId) {
  return ref.watch(databaseProvider).watchTimeLogsForTask(taskId);
});

// ── Currently active timer (taskId or null) ───────────────────────────────────

final activeTimerTaskIdProvider = StateProvider<String?>((ref) => null);

// ── Recurrence for a task ───────────────────────────────────────────────────────

final recurrenceProvider =
    StreamProvider.family<Recurrence?, String>((ref, taskId) {
  return ref.watch(databaseProvider).watchRecurrenceForTask(taskId);
});
