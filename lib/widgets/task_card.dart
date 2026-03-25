import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/database.dart';
import '../theme/app_theme.dart';
import '../providers/tasks_provider.dart';

/// Reusable task row used across Inbox, Calendar, and Project Detail screens.
class TaskCard extends ConsumerWidget {
  final Task task;
  final String? projectName;
  final String? projectColor;
  final VoidCallback onTap;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  TaskCard({
    super.key,
    required this.task,
    this.projectName,
    this.projectColor,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = task.done;
    final recurrenceAsync = ref.watch(recurrenceProvider(task.id));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: done
              ? Theme.of(context).colorScheme.surfaceContainerLow
              : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: done 
              ? Theme.of(context).colorScheme.outlineVariant.withOpacity(0.2) 
              : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.8),
            width: 1,
          ),
          boxShadow: done
              ? []
              : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => onToggle(!done),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 2),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: done ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: done
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  child: done
                      ? Icon(Icons.check,
                          size: 14, color: Theme.of(context).colorScheme.onPrimary)
                      : null,
                ),
              ),
              SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: done
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onSurface,
                        decoration:
                            done ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      child: Text(task.title),
                    ),
                    SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Priority chip
                        _PriorityChip(priority: task.priority),
                        // Project tag
                        if (projectName != null)
                          _TagChip(label: '#$projectName'),
                        // Due date
                        if (task.dueDate != null)
                          _DateChip(date: task.dueDate!),
                        // Recurrence chip
                        recurrenceAsync.when(
                          data: (rec) {
                            if (rec == null) return const SizedBox.shrink();
                            return _RecurrenceChip(recurrence: rec, task: task);
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Three-dot menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit task'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecurrenceChip extends StatelessWidget {
  final Recurrence recurrence;
  final Task task;
  const _RecurrenceChip({required this.recurrence, required this.task});

  String _formatLabel() {
    final Map<String, String> labels = {
      'daily': 'D',
      'weekly': 'W',
      'monthly': 'M',
    };
    String base = labels[recurrence.type] ?? 'R';
    String startStr = DateFormat('MMM d').format(task.createdAt);

    if (recurrence.endDate != null) {
      String endStr = DateFormat('MMM d').format(recurrence.endDate!);
      return '$base · $startStr - $endStr';
    }
    return '$base · Since $startStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.repeat, size: 10, color: Theme.of(context).colorScheme.onTertiaryContainer),
          SizedBox(width: 3),
          Text(
            _formatLabel(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final int priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = AtelierTheme.forPriority(Theme.of(context).colorScheme, priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'P$priority',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  const _DateChip({required this.date});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.add(Duration(days: 1))) return 'Tomorrow';
    return DateFormat('MMM d').format(date);
  }

  bool get _isOverdue {
    final now = DateTime.now();
    return date.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final overdue = _isOverdue;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 11,
          color: overdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 3),
        Text(
          _label(),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: overdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// Section divider used in Inbox groupings.
class SectionHeader extends StatelessWidget {
  final String title;
  SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}

/// Glass FAB — matches DESIGN.md "Glass & Signature Texture" rule.
class GlassFab extends StatelessWidget {
  final VoidCallback onPressed;
  GlassFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest.withOpacity(0.85),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.15),
          ),
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
      ),
    );
  }
}
