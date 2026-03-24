import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/projects_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/add_task_sheet.dart';
import 'settings_screen.dart';

class InboxScreen extends ConsumerWidget {
  InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdueAsync = ref.watch(overdueTasksProvider);
    final todayAsync = ref.watch(todayTasksProvider);
    final upcomingAsync = ref.watch(upcomingTasksProvider);
    final inboxAsync = ref.watch(inboxTasksProvider);
    final projects = ref.watch(projectsProvider).value ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text('Atelier',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: -0.5)),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SettingsScreen())),
              ),
            ],
          ),
          // ── Hero Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LOCAL-FIRST block removed as requested
                  SizedBox(height: 10),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Capture your thoughts, refine your day.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Tasks ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Overdue section (red tint)
                _TaskGroup(
                  title: 'Overdue',
                  asyncTasks: overdueAsync,
                  projects: projects,
                  ref: ref,
                  emptyText: null,
                  isOverdue: true,
                ),
                _TaskGroup(
                  title: "Today's Focus",
                  asyncTasks: todayAsync,
                  projects: projects,
                  ref: ref,
                  emptyText: 'No tasks due today.',
                ),
                _TaskGroup(
                  title: 'Coming Up',
                  asyncTasks: upcomingAsync,
                  projects: projects,
                  ref: ref,
                  emptyText: null,
                ),
                _TaskGroup(
                  title: 'Inbox',
                  asyncTasks: inboxAsync,
                  projects: projects,
                  ref: ref,
                  emptyText: 'All clear — Your day is yours.',
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GlassFab(
          onPressed: () => showAddTaskSheet(context, ref),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _TaskGroup extends StatelessWidget {
  final String title;
  final AsyncValue<List<Task>> asyncTasks;
  final List<Project> projects;
  final WidgetRef ref;
  final String? emptyText;
  final bool isOverdue;

  const _TaskGroup({
    required this.title,
    required this.asyncTasks,
    required this.projects,
    required this.ref,
    this.emptyText,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    return asyncTasks.when(
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
      data: (tasks) {
        if (tasks.isEmpty && emptyText == null) return SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with overdue styling
            isOverdue
                ? _OverdueSectionHeader(title: title, count: tasks.length)
                : SectionHeader(title: title),
            if (tasks.isEmpty && emptyText != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    emptyText!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...tasks.map((task) {
                final project = projects
                    .where((p) => p.id == task.projectId)
                    .firstOrNull;
                return _SwipeableTaskCard(
                  task: task,
                  project: project,
                  ref: ref,
                  isOverdue: isOverdue,
                );
              }),
          ],
        );
      },
    );
  }
}

/// Task card wrapped in Dismissible for swipe-to-complete / swipe-to-postpone
class _SwipeableTaskCard extends StatelessWidget {
  final Task task;
  final Project? project;
  final WidgetRef ref;
  final bool isOverdue;

  const _SwipeableTaskCard({
    required this.task,
    this.project,
    required this.ref,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(task.id),
      // Swipe right → complete
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text('Complete', style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: Colors.green,
            )),
          ],
        ),
      ),
      // Swipe left → postpone to tomorrow
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tomorrow', style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            )),
            SizedBox(width: 8),
            Icon(Icons.schedule, color: colorScheme.primary, size: 24),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Complete with undo
          await ref.read(databaseProvider).toggleTaskDone(task.id, true);
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('\"${task.title}\" completed'),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    ref.read(databaseProvider).toggleTaskDone(task.id, false);
                  },
                ),
                duration: Duration(seconds: 4),
              ),
            );
          }
          return false; // Don't remove from list — the stream handles it
        } else {
          // Postpone to tomorrow
          final tomorrow = DateTime.now().add(Duration(days: 1));
          final newDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
          await ref.read(databaseProvider).updateTask(
            TasksCompanion(
              id: Value(task.id),
              dueDate: Value(newDate),
            ),
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('\"${task.title}\" postponed to tomorrow'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return false;
        }
      },
      child: Container(
        decoration: isOverdue
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: colorScheme.error.withOpacity(0.6),
                    width: 3,
                  ),
                ),
              )
            : null,
        child: TaskCard(
          task: task,
          projectName: project?.name,
          onTap: () => showTaskDetailSheet(context, ref, task),
          onToggle: (done) {
            ref.read(databaseProvider).toggleTaskDone(task.id, done ?? false);
            if (done == true && context.mounted) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('\"${task.title}\" completed'),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      ref.read(databaseProvider).toggleTaskDone(task.id, false);
                    },
                  ),
                  duration: Duration(seconds: 4),
                ),
              );
            }
          },
          onEdit: () => showTaskDetailSheet(context, ref, task),
          onDelete: () =>
              ref.read(databaseProvider).deleteTask(task.id),
        ),
      ),
    );
  }
}

class _OverdueSectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _OverdueSectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: errorColor),
          SizedBox(width: 6),
          Text(
            '${title.toUpperCase()} ($count)',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: errorColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: errorColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
