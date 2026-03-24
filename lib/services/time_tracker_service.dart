import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/tasks_provider.dart';

final timeTrackerServiceProvider = Provider<TimeTrackerService>((ref) {
  return TimeTrackerService(ref);
});

class TimeTrackerService {
  final Ref _ref;
  TimeTrackerService(this._ref);

  AppDatabase get _db => _ref.read(databaseProvider);

  /// Start a timer for [taskId]. Stops any currently active timer first.
  Future<void> start(String taskId) async {
    final activeId = _ref.read(activeTimerTaskIdProvider);
    if (activeId != null && activeId != taskId) {
      await stop(activeId);
    }
    if (activeId == taskId) return; // Already running.

    final existing = await _db.getActiveLog(taskId);
    if (existing != null) return; // Guard against duplicates.

    await _db.insertTimeLog(
      TimeLogsCompanion.insert(
        id: Uuid().v4(),
        taskId: taskId,
        startedAt: DateTime.now(),
      ),
    );
    _ref.read(activeTimerTaskIdProvider.notifier).state = taskId;
  }

  /// Stop the active timer for [taskId] and compute [durationMins].
  Future<void> stop(String taskId) async {
    final log = await _db.getActiveLog(taskId);
    if (log == null) return;

    final endedAt = DateTime.now();
    final durationMins =
        endedAt.difference(log.startedAt).inMinutes;

    await _db.updateTimeLog(
      TimeLogsCompanion(
        id: Value(log.id),
        endedAt: Value(endedAt),
        durationMins: Value(durationMins),
      ),
    );
    _ref.read(activeTimerTaskIdProvider.notifier).state = null;
  }

  bool isActive(String taskId) =>
      _ref.read(activeTimerTaskIdProvider) == taskId;
}
