import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ─── Tables ───────────────────────────────────────────────────────────────────

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get projectId => text().nullable()();

  /// Priority: 1 = P1 (highest) … 4 = P4 (lowest)
  IntColumn get priority => integer().withDefault(Constant(2))();

  DateTimeColumn get dueDate => dateTime().nullable()();

  /// Reminder offset in minutes (e.g. 15, 30, 60, 1440). Null = no reminder.
  IntColumn get reminderMinutes => integer().nullable()();

  BoolColumn get done => boolean().withDefault(Constant(false))();
  IntColumn get sortOrder => integer().withDefault(Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().withDefault(Constant('folder'))();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().withDefault(Constant('#545a94'))();
  IntColumn get sortOrder => integer().withDefault(Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get title => text().named('text')();
  BoolColumn get done => boolean().withDefault(Constant(false))();
  IntColumn get sortOrder => integer().withDefault(Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Recurrences extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();

  /// 'daily' | 'weekly' | 'monthly'
  TextColumn get type => text()();
  IntColumn get interval => integer().withDefault(Constant(1))();

  /// JSON list of weekday ints e.g. "[1,3,5]" (Mon=1 … Sun=7)
  TextColumn get weekdays => text().nullable()();

  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get nextDue => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TimeLogs extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  /// Computed and stored when the timer is stopped.
  IntColumn get durationMins => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Tasks, Projects, Subtasks, Recurrences, TimeLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Tasks ──

  Stream<List<Task>> watchAllTasks() =>
      (select(tasks)..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Stream<List<Task>> watchTodayTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    return (select(tasks)
          ..where((t) =>
              t.dueDate.isBiggerOrEqualValue(today) &
              t.dueDate.isSmallerThanValue(tomorrow) &
              t.done.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  Stream<List<Task>> watchUpcomingTasks() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return (select(tasks)
          ..where((t) =>
              t.dueDate.isBiggerOrEqualValue(tomorrow) & t.done.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDate)]))
        .watch();
  }

  Stream<List<Task>> watchInboxTasks() => (select(tasks)
        ..where((t) => t.dueDate.isNull() & t.done.equals(false))
        ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
      .watch();

  Stream<List<Task>> watchOverdueTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return (select(tasks)
          ..where((t) =>
              t.dueDate.isSmallerThanValue(today) &
              t.done.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDate)]))
        .watch();
  }

  Stream<List<Task>> watchTasksByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));
    return (select(tasks)
          ..where((t) =>
              t.dueDate.isBiggerOrEqualValue(start) &
              t.dueDate.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  Stream<List<Task>> watchTasksByProject(String projectId) =>
      (select(tasks)
            ..where((t) => t.projectId.equals(projectId))
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Future<Task?> getTaskById(String id) =>
      (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<void> updateTask(TasksCompanion task) =>
      (update(tasks)..where((t) => t.id.equals(task.id.value)))
          .write(task.copyWith(updatedAt: Value(DateTime.now())));

  Future<void> deleteTask(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  Future<void> toggleTaskDone(String id, bool done) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(
        TasksCompanion(
          done: Value(done),
          updatedAt: Value(DateTime.now()),
        ),
      );

  // ── Projects ──

  Stream<List<Project>> watchAllProjects() =>
      (select(projects)
            ..orderBy([(p) => OrderingTerm(expression: p.sortOrder)]))
          .watch();

  Future<void> insertProject(ProjectsCompanion project) =>
      into(projects).insert(project);

  Future<void> updateProject(ProjectsCompanion project) =>
      (update(projects)..where((p) => p.id.equals(project.id.value)))
          .write(project);

  Future<void> deleteProject(String id) =>
      (delete(projects)..where((p) => p.id.equals(id))).go();

  // ── Subtasks ──

  Stream<List<Subtask>> watchSubtasks(String taskId) =>
      (select(subtasks)
            ..where((s) => s.taskId.equals(taskId))
            ..orderBy([(s) => OrderingTerm(expression: s.sortOrder)]))
          .watch();

  Future<void> insertSubtask(SubtasksCompanion subtask) =>
      into(subtasks).insert(subtask);

  Future<void> toggleSubtask(String id, bool done) =>
      (update(subtasks)..where((s) => s.id.equals(id)))
          .write(SubtasksCompanion(done: Value(done)));

  Future<void> deleteSubtask(String id) =>
      (delete(subtasks)..where((s) => s.id.equals(id))).go();

  // ── Recurrences ──

  Future<Recurrence?> getRecurrenceForTask(String taskId) =>
      (select(recurrences)..where((r) => r.taskId.equals(taskId)))
          .getSingleOrNull();

  Future<void> upsertRecurrence(RecurrencesCompanion rec) =>
      into(recurrences).insertOnConflictUpdate(rec);

  Future<void> deleteRecurrenceForTask(String taskId) =>
      (delete(recurrences)..where((r) => r.taskId.equals(taskId))).go();

  // ── Time Logs ──

  Stream<List<TimeLog>> watchTimeLogsForTask(String taskId) =>
      (select(timeLogs)
            ..where((l) => l.taskId.equals(taskId))
            ..orderBy([(l) => OrderingTerm(expression: l.startedAt)]))
          .watch();

  Future<TimeLog?> getActiveLog(String taskId) =>
      (select(timeLogs)
            ..where((l) => l.taskId.equals(taskId) & l.endedAt.isNull()))
          .getSingleOrNull();

  Future<void> insertTimeLog(TimeLogsCompanion log) =>
      into(timeLogs).insert(log);

  Future<void> updateTimeLog(TimeLogsCompanion log) =>
      (update(timeLogs)..where((l) => l.id.equals(log.id.value))).write(log);

  // ── Export (all rows as maps) ──

  Future<Map<String, dynamic>> exportAll() async {
    final allTasks = await select(tasks).get();
    final allProjects = await select(projects).get();
    final allSubtasks = await select(subtasks).get();
    final allRecurrences = await select(recurrences).get();
    final allLogs = await select(timeLogs).get();
    return {
      'tasks': allTasks.map((t) => t.toJson()).toList(),
      'projects': allProjects.map((p) => p.toJson()).toList(),
      'subtasks': allSubtasks.map((s) => s.toJson()).toList(),
      'recurrences': allRecurrences.map((r) => r.toJson()).toList(),
      'time_logs': allLogs.map((l) => l.toJson()).toList(),
      'exported_at': DateTime.now().toIso8601String(),
      'version': 1,
    };
  }

  Future<void> importAll(Map<String, dynamic> data) async {
    await transaction(() async {
      // Clear existing data
      await delete(tasks).go();
      await delete(projects).go();
      await delete(subtasks).go();
      await delete(recurrences).go();
      await delete(timeLogs).go();

      // Import tasks
      if (data['tasks'] != null) {
        for (final t in data['tasks'] as List) {
          await into(tasks).insert(
            Task.fromJson(t as Map<String, dynamic>),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
      // Import projects
      if (data['projects'] != null) {
        for (final p in data['projects'] as List) {
          await into(projects).insert(
            Project.fromJson(p as Map<String, dynamic>),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
      // Import subtasks
      if (data['subtasks'] != null) {
        for (final s in data['subtasks'] as List) {
          await into(subtasks).insert(
            Subtask.fromJson(s as Map<String, dynamic>),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
      // Import recurrences
      if (data['recurrences'] != null) {
        for (final r in data['recurrences'] as List) {
          await into(recurrences).insert(
            Recurrence.fromJson(r as Map<String, dynamic>),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
      // Import time logs
      if (data['time_logs'] != null) {
        for (final l in data['time_logs'] as List) {
          await into(timeLogs).insert(
            TimeLog.fromJson(l as Map<String, dynamic>),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'atelier.db'));
    return NativeDatabase.createInBackground(file);
  });
}
