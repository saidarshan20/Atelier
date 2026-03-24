import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/projects_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/add_task_sheet.dart';

final _selectedDayProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final _focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class CalendarScreen extends ConsumerWidget {
  CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(_selectedDayProvider);
    final focusedDay = ref.watch(_focusedDayProvider);
    final tasksAsync = ref.watch(tasksByDateProvider(selectedDay));
    final allTasksAsync = ref.watch(allTasksProvider);
    final projects = ref.watch(projectsProvider).value ?? [];

    // Build event map for dot markers.
    final Map<DateTime, List<Task>> eventMap = {};
    for (final task in allTasksAsync.value ?? []) {
      if (task.dueDate != null) {
        final key = DateTime(
            task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
        eventMap.putIfAbsent(key, () => []).add(task);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Calendar',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: Column(
        children: [
          // TableCalendar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TableCalendar<Task>(
              firstDay: DateTime(2020),
              lastDay: DateTime(2040),
              focusedDay: focusedDay,
              selectedDayPredicate: (d) => isSameDay(d, selectedDay),
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return eventMap[key] ?? [];
              },
              onDaySelected: (sel, foc) {
                ref.read(_selectedDayProvider.notifier).state =
                    DateTime(sel.year, sel.month, sel.day);
                ref.read(_focusedDayProvider.notifier).state = foc;
              },
              onPageChanged: (foc) =>
                  ref.read(_focusedDayProvider.notifier).state = foc,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
                defaultTextStyle: TextStyle(
                    fontFamily: 'Inter', color: Theme.of(context).colorScheme.onSurface),
                weekendTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                outsideTextStyle: TextStyle(
                    fontFamily: 'Inter', color: Theme.of(context).colorScheme.surfaceContainerHigh),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markerSize: 5,
              ),
              headerStyle: HeaderStyle(
                titleCentered: false,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -0.5,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: Theme.of(context).colorScheme.primary),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                weekendStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ),

          // Selected day tasks
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.15),
                ),
              ),
              child: Column(
                children: [
                  // Day header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE').format(selectedDay),
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM d').format(selectedDay).toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Task list
                  Expanded(
                    child: tasksAsync.when(
                      loading: () => Center(
                          child: CircularProgressIndicator()),
                      error: (_, __) => SizedBox.shrink(),
                      data: (tasks) {
                        if (tasks.isEmpty) {
                          return Center(
                            child: Text(
                              'Nothing here yet —\nenjoy the space.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                height: 1.7,
                              ),
                            ),
                          );
                        }
                        
                        final pending = tasks.where((t) => !t.done).toList();
                        final completed = tasks.where((t) => t.done).toList();
                        
                        final itemCount = pending.length + (completed.isNotEmpty ? completed.length + 1 : 0);
                        
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          itemCount: itemCount,
                          itemBuilder: (_, i) {
                            Task task;
                            if (i < pending.length) {
                              task = pending[i];
                            } else if (i == pending.length && completed.isNotEmpty) {
                              return SectionHeader(title: 'Completed');
                            } else {
                              task = completed[i - pending.length - 1];
                            }
                            final project = projects
                                .where((p) => p.id == task.projectId)
                                .firstOrNull;
                            return TaskCard(
                              task: task,
                              projectName: project?.name,
                              onTap: () =>
                                  showTaskDetailSheet(context, ref, task),
                              onToggle: (done) => ref
                                  .read(databaseProvider)
                                  .toggleTaskDone(
                                      task.id, done ?? false),
                              onEdit: () =>
                                  showTaskDetailSheet(context, ref, task),
                              onDelete: () => ref
                                  .read(databaseProvider)
                                  .deleteTask(task.id),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GlassFab(
          onPressed: () => showAddTaskSheet(context, ref,
              prefilledDate: selectedDay),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
