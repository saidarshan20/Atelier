import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/projects_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

/// Lightweight Add Task bottom sheet.
Future<void> showAddTaskSheet(
  BuildContext context,
  WidgetRef ref, {
  DateTime? prefilledDate,
  String? prefilledProjectId,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddTaskSheet(
      ref: ref,
      prefilledDate: prefilledDate,
      prefilledProjectId: prefilledProjectId,
    ),
  );
}

class AddTaskSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final DateTime? prefilledDate;
  final String? prefilledProjectId;

  AddTaskSheet({
    super.key,
    required this.ref,
    this.prefilledDate,
    this.prefilledProjectId,
  });

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleCtrl = TextEditingController();
  int _priority = 2;
  DateTime? _dueDate;
  int? _reminderMinutes;
  String? _projectId;

  static const _reminderLabels = {
    null: 'No reminder',
    0: 'On time',
    15: '15 min',
    30: '30 min',
    60: '1 hour',
    1440: '1 day',
  };

  static const _recurrenceLabels = {
    null: 'No repeat',
    'daily': 'Daily',
    'weekly': 'Weekly',
    'monthly': 'Monthly',
  };
  String? _recurrenceType;

  @override
  void initState() {
    super.initState();
    _dueDate = widget.prefilledDate;
    _projectId = widget.prefilledProjectId;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final task = TasksCompanion.insert(
      id: Uuid().v4(),
      title: title,
      priority: Value(_priority),
      dueDate: Value(_dueDate),
      reminderMinutes: Value(_reminderMinutes),
      projectId: Value(_projectId),
      done: Value(false),
      sortOrder: Value(0),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(databaseProvider).insertTask(task);

    if (_recurrenceType != null) {
      final nextDue = _dueDate ?? DateTime.now();
      await ref.read(databaseProvider).upsertRecurrence(
        RecurrencesCompanion.insert(
          id: Uuid().v4(),
          taskId: task.id.value,
          type: _recurrenceType!,
          nextDue: nextDue,
        ),
      );
    }

    // Schedule notification (due date, and reminder if any).
    if (_dueDate != null) {
      final db = ref.read(databaseProvider);
      final saved = await db.getTaskById(task.id.value);
      if (saved != null) await NotificationService.scheduleReminder(saved);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider).value ?? [];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Title input
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'What needs to be done?',
              hintStyle: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Priority chips
          Row(
            children: [1, 2, 3, 4].map((p) {
              final isSelected = p == _priority;
              final color = AtelierTheme.forPriority(Theme.of(context).colorScheme, p);
              return GestureDetector(
                onTap: () => setState(() => _priority = p),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.12)
                        : Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? color
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    'P$p',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? color
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),

          // Date + Reminder row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickButton(
                  icon: Icons.event_outlined,
                  label: _dueDate != null
                      ? DateFormat('d/M HH:mm').format(_dueDate!)
                      : 'Date',
                  onTap: _pickDate,
                ),
                SizedBox(width: 8),
                _QuickButton(
                  icon: Icons.notifications_outlined,
                  label: _reminderLabels[_reminderMinutes] ?? 'Reminder',
                  onTap: _pickReminder,
                ),
                SizedBox(width: 8),
                _QuickButton(
                  icon: Icons.repeat,
                  label: _recurrenceType != null 
                      ? _recurrenceLabels[_recurrenceType]! 
                      : 'Repeat',
                  onTap: _pickRecurrence,
                ),
                SizedBox(width: 8),
                if (projects.isNotEmpty)
                  _QuickButton(
                    icon: Icons.folder_outlined,
                    label: projects
                            .where((p) => p.id == _projectId)
                            .firstOrNull
                            ?.name ??
                        'Project',
                    onTap: () => _pickProject(projects),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
              SizedBox(width: 8),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: Text('Add task',
                    style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final nextWeek = today.add(Duration(days: 7));

    final choice = await showModalBottomSheet<DateTime?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.today, color: Colors.green),
              title: Text('Today', style: TextStyle(fontFamily: 'Inter')),
              subtitle: Text(
                '${today.day}/${today.month}',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant),
              ),
              onTap: () => Navigator.pop(ctx, today),
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny_outlined, color: Colors.orange),
              title: Text('Tomorrow', style: TextStyle(fontFamily: 'Inter')),
              subtitle: Text(
                '${tomorrow.day}/${tomorrow.month}',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant),
              ),
              onTap: () => Navigator.pop(ctx, tomorrow),
            ),
            ListTile(
              leading: Icon(Icons.date_range, color: Theme.of(ctx).colorScheme.primary),
              title: Text('Next Week', style: TextStyle(fontFamily: 'Inter')),
              subtitle: Text(
                '${nextWeek.day}/${nextWeek.month}',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant),
              ),
              onTap: () => Navigator.pop(ctx, nextWeek),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_month_outlined,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant),
              title: Text('Pick a date...', style: TextStyle(fontFamily: 'Inter')),
              onTap: () async {
                Navigator.pop(ctx); // close the sheet
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2040),
                );
                if (picked != null && mounted) {
                  final timeChoice = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  setState(() {
                    if (timeChoice != null) {
                      _dueDate = DateTime(
                        picked.year, picked.month, picked.day,
                        timeChoice.hour, timeChoice.minute,
                      );
                    } else {
                      _dueDate = DateTime(picked.year, picked.month, picked.day);
                    }
                  });
                }
              },
            ),
            if (_dueDate != null) ...[
              Divider(),
              ListTile(
                leading: Icon(Icons.close, color: Theme.of(ctx).colorScheme.error),
                title: Text('Remove date', style: TextStyle(
                    fontFamily: 'Inter',
                    color: Theme.of(ctx).colorScheme.error)),
                onTap: () => Navigator.pop(ctx, DateTime(1970)),
              ),
            ],
          ],
        ),
      ),
    );
    if (choice != null && mounted) {
      if (choice.year == 1970) {
        setState(() => _dueDate = null);
      } else {
        final timeChoice = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        setState(() {
          if (timeChoice != null) {
            _dueDate = DateTime(
              choice.year, choice.month, choice.day,
              timeChoice.hour, timeChoice.minute,
            );
          } else {
            _dueDate = DateTime(choice.year, choice.month, choice.day);
          }
        });
      }
    }
  }

  Future<void> _pickReminder() async {
    final choice = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _reminderLabels.entries
            .map((e) => ListTile(
                  title: Text(e.value,
                      style: TextStyle(fontFamily: 'Inter')),
                  trailing: _reminderMinutes == e.key
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(ctx, e.key),
                ))
            .toList(),
      ),
    );
    if (mounted) setState(() => _reminderMinutes = choice);
  }

  Future<void> _pickRecurrence() async {
    final choice = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _recurrenceLabels.entries
            .map((e) => ListTile(
                  title: Text(e.value,
                      style: TextStyle(fontFamily: 'Inter')),
                  trailing: _recurrenceType == e.key
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(ctx, e.key),
                ))
            .toList(),
      ),
    );
    if (mounted) setState(() => _recurrenceType = choice);
  }

  Future<void> _pickProject(List<Project> projects) async {
    final chosen = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
            title: Text('Create new project', style: TextStyle(fontFamily: 'Inter', color: Theme.of(context).colorScheme.primary)),
            onTap: () {
              Navigator.pop(ctx, 'CREATE_NEW');
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox_outlined),
            title: Text('No project',
                style: TextStyle(fontFamily: 'Inter')),
            onTap: () => Navigator.pop(ctx, ''),
          ),
          ...projects.map((p) => ListTile(
                leading: Icon(Icons.folder_outlined,
                    color: Theme.of(context).colorScheme.primary),
                title:
                    Text(p.name, style: TextStyle(fontFamily: 'Inter')),
                onTap: () => Navigator.pop(ctx, p.id),
              )),
        ],
      ),
    );
    if (chosen != null && mounted) {
      if (chosen == 'CREATE_NEW') {
        _createNewProject();
      } else {
        setState(() => _projectId = chosen.isEmpty ? null : chosen);
      }
    }
  }

  Future<void> _createNewProject() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('New Project', style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Project name...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text('Create'),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      final newId = Uuid().v4();
      await ref.read(databaseProvider).insertProject(
        ProjectsCompanion(
          id: Value(newId),
          name: Value(name.trim()),
        ),
      );
      if (mounted) setState(() => _projectId = newId);
    }
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
