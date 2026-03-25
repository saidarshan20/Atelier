import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/projects_provider.dart';
import '../services/notification_service.dart';
import '../services/time_tracker_service.dart';
import '../theme/app_theme.dart';

/// Opens a DraggableScrollableSheet showing full task details.
/// minChildSize: 0.5, initial: 0.7, max: 0.95
Future<void> showTaskDetailSheet(
  BuildContext context,
  WidgetRef ref,
  Task task,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TaskDetailSheet(task: task, ref: ref),
  ).then((_) {
    // We already save in dispose(), but for good measure, we can refresh 
    // nothing here since riverpod watch streams will auto-update.
  });
}

class TaskDetailSheet extends ConsumerStatefulWidget {
  final Task task;
  final WidgetRef ref;

  TaskDetailSheet({super.key, required this.task, required this.ref});

  @override
  ConsumerState<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends ConsumerState<TaskDetailSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _notesCtrl;
  late FocusNode _notesFocusNode;
  late int _priority;
  late DateTime? _dueDate;
  late int? _reminderMinutes;
  String? _projectId;
  String? _imagePath;
  bool _dirty = false;


  static const _reminderOptions = {
    null: 'None',
    0: 'On time',
    15: '15 min before',
    30: '30 min before',
    60: '1 hour before',
    1440: '1 day before',
  };

  static const _recurrenceLabels = {
    null: 'No repeat',
    'daily': 'Daily',
    'weekly': 'Weekly',
    'monthly': 'Monthly',
  };

  String? _recurrenceType;
  DateTime? _recurrenceEndDate;
  bool _recurrenceLoaded = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _notesCtrl = TextEditingController(text: widget.task.notes ?? '');
    _notesFocusNode = FocusNode();
    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate;
    _reminderMinutes = widget.task.reminderMinutes;
    _projectId = widget.task.projectId;
    _imagePath = widget.task.imagePath;

    _titleCtrl.addListener(() => _dirty = true);
    _notesCtrl.addListener(() => _dirty = true);
    
    // Auto-save the moment they stop typing / close keyboard explicitly
    _notesFocusNode.addListener(() {
      if (!_notesFocusNode.hasFocus) {
        _saveIfDirty();
      }
    });

    _loadRecurrence();
  }

  Future<void> _loadRecurrence() async {
    final rec = await ref.read(databaseProvider).getRecurrenceForTask(widget.task.id);
    if (mounted) {
      setState(() {
        _recurrenceType = rec?.type;
        _recurrenceEndDate = rec?.endDate;
        _recurrenceLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _saveIfDirty();
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveIfDirty() async {
    if (!_dirty) return;
    final db = ref.read(databaseProvider);
    final updated = TasksCompanion(
      id: Value(widget.task.id),
      title: Value(_titleCtrl.text.trim().isEmpty
          ? widget.task.title
          : _titleCtrl.text.trim()),
      notes: Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
      priority: Value(_priority),
      dueDate: Value(_dueDate),
      reminderMinutes: Value(_reminderMinutes),
      projectId: Value(_projectId),
      imagePath: Value(_imagePath),
      updatedAt: Value(DateTime.now()),
    );
    await db.updateTask(updated);
    // Reschedule notification.
    final saved = await db.getTaskById(widget.task.id);
    if (saved != null) {
      await NotificationService.cancelReminder(saved.id);
      await NotificationService.scheduleReminder(saved);
    }
  }

  void _markDirty() => setState(() => _dirty = true);

  Future<void> _createNewProject(BuildContext context) async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('New Project',
            style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Project name…'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: Text('Create')),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && mounted) {
      final newId = Uuid().v4();
      await ref.read(databaseProvider).insertProject(
        ProjectsCompanion.insert(
          id: newId,
          name: name,
          color: Value('#545a94'), // Default color
        )
      );
      setState(() {
        _projectId = newId;
        _dirty = true;
      });
      _saveIfDirty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtasksAsync = ref.watch(subtasksProvider(widget.task.id));
    final projectsAsync = ref.watch(projectsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: [0.5, 0.7, 0.95],
      builder: (context, scrollController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            await _saveIfDirty();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  children: [
                    // Priority + created
                    Row(
                      children: [
                        _PrioritySelector(
                          selected: _priority,
                          onChanged: (p) {
                            setState(() {
                              _priority = p;
                              _dirty = true;
                            });
                            _saveIfDirty();
                          },
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Created ${_timeAgo(widget.task.createdAt)}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Title — tap-to-edit
                    TextField(
                      controller: _titleCtrl,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Task title',
                        hintStyle:
                            TextStyle(color: Theme.of(context).colorScheme.surfaceContainerHigh),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) => _markDirty(),
                    ),
                    SizedBox(height: 16),

                    // Project
                    _ProjectRow(
                      projectId: _projectId,
                      projects: projectsAsync.value ?? [],
                      onChanged: (id) {
                        setState(() {
                          _projectId = id;
                          _dirty = true;
                        });
                        _saveIfDirty();
                      },
                      onCreateNew: () => _createNewProject(context),
                    ),
                    SizedBox(height: 24),

                    // Notes
                    _Section(
                      icon: Icons.notes_outlined,
                      title: 'Notes',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
                        ),
                        child: TextField(
                          controller: _notesCtrl,
                          focusNode: _notesFocusNode,
                          minLines: 4,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add notes…',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            height: 1.6,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onChanged: (_) => _markDirty(),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Photo attachment
                    _Section(
                      icon: Icons.image_outlined,
                      title: 'Attachment',
                      child: _imagePath == null
                          ? GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    SizedBox(height: 8),
                                    Text('Add a photo', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(_imagePath!),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest.withOpacity(0.8),
                                    ),
                                    icon: Icon(Icons.close, size: 20, color: Theme.of(context).colorScheme.onSurface),
                                    onPressed: _removeImage,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 24),

                    // Sub-tasks
                    _Section(
                      icon: Icons.checklist_outlined,
                      title: 'Sub-tasks',
                      trailing: TextButton.icon(
                        onPressed: () =>
                            _addSubtask(widget.task.id),
                        icon: Icon(Icons.add, size: 16),
                        label: Text('Add item'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          textStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      child: subtasksAsync.when(
                        data: (subs) => Column(
                          children: subs
                              .map((s) => _SubtaskRow(subtask: s))
                              .toList(),
                        ),
                        loading: () => SizedBox.shrink(),
                        error: (_, __) => SizedBox.shrink(),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Reminders & Schedule
                    _Section(
                      icon: Icons.calendar_today_outlined,
                      title: 'Reminders & Schedule',
                      child: Column(
                        children: [
                          _ScheduleCard(
                            label: 'Due Date',
                            icon: Icons.event_outlined,
                            value: _dueDate != null
                                ? DateFormat('EEE, MMM d · h:mm a')
                                    .format(_dueDate!)
                                : 'Not set',
                            onTap: _pickDueDate,
                          ),
                          SizedBox(height: 8),
                          _ScheduleCard(
                            label: 'Reminder',
                            icon: Icons.notifications_outlined,
                            value: _reminderOptions[_reminderMinutes] ?? 'None',
                            onTap: _pickReminder,
                          ),
                          SizedBox(height: 8),
                          _ScheduleCard(
                            label: 'Repeat',
                            icon: Icons.repeat,
                            value: _recurrenceLoaded 
                                ? (_recurrenceLabels[_recurrenceType] ?? 'No repeat')
                                : '...',
                            onTap: _pickRecurrence,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Time Tracker
                    _Section(
                      icon: Icons.timer_outlined,
                      title: 'Time Tracker',
                      child: _TimeTrackerRow(taskId: widget.task.id),
                    ),
                    SizedBox(height: 32),

                    // Delete
                    TextButton.icon(
                      onPressed: _confirmDelete,
                      icon: Icon(Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error, size: 20),
                      label: Text(
                        'Delete task',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        );
      },
    );
  }

  Future<void> _addSubtask(String taskId) async {
    final ctrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('New sub-task',
            style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration:
              InputDecoration(hintText: 'Sub-task description…'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Add')),
        ],
      ),
    );
    if (confirmed == true && ctrl.text.isNotEmpty) {
      await ref.read(databaseProvider).insertSubtask(
            SubtasksCompanion.insert(
              id: Uuid().v4(),
              taskId: taskId,
              title: ctrl.text.trim(),
            ),
          );
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
      );
      setState(() {
        _dueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime?.hour ?? 9,
          pickedTime?.minute ?? 0,
        );
        _dirty = true;
      });
      _saveIfDirty();
    }
  }

  Future<void> _pickReminder() async {
    final choice = await showModalBottomSheet<int?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _reminderOptions.entries
              .map(
                (e) => ListTile(
                  title: Text(e.value,
                      style: TextStyle(fontFamily: 'Inter')),
                  trailing: _reminderMinutes == e.key
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(ctx, e.key),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (mounted) {
      setState(() {
        _reminderMinutes = choice;
        _dirty = true;
      });
      _saveIfDirty();
    }
  }

  Future<void> _pickRecurrence() async {
    final choice = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _recurrenceLabels.entries
              .map(
                (e) => ListTile(
                  title: Text(e.value,
                      style: TextStyle(fontFamily: 'Inter')),
                  trailing: _recurrenceType == e.key
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () => Navigator.pop(ctx, e.key),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (mounted) {
      DateTime? selectedEndDate = _recurrenceEndDate;
      if (choice != null) {
        selectedEndDate = await showDatePicker(
          context: context,
          initialDate: _dueDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2040),
          helpText: 'End Date (Optional)',
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: Theme.of(context).colorScheme,
            ),
            child: child!,
          ),
        );
      }

      setState(() {
        _recurrenceType = choice;
        if (choice != null) _recurrenceEndDate = selectedEndDate;
        if (choice == null) _recurrenceEndDate = null;
        _dirty = true;
      });

      if (choice == null) {
        await ref.read(databaseProvider).deleteRecurrenceForTask(widget.task.id);
      } else {
        await ref.read(databaseProvider).upsertRecurrence(
          RecurrencesCompanion.insert(
            id: Uuid().v4(),
            taskId: widget.task.id,
            type: choice,
            endDate: Value(selectedEndDate),
            nextDue: _dueDate ?? DateTime.now(),
          ),
        );
      }
      _saveIfDirty();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy(p.join(appDir.path, fileName));
      
      setState(() {
        _imagePath = savedImage.path;
        _dirty = true;
      });
      _saveIfDirty();
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imagePath = null;
      _dirty = true;
    });
    _saveIfDirty();
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete task?',
            style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: Text('This cannot be undone.',
            style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await ref.read(databaseProvider).deleteTask(widget.task.id);
      await NotificationService.cancelReminder(widget.task.id);
      if (mounted) Navigator.pop(context);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Section({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
            SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 1.2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [1, 2, 3, 4].map((p) {
        final isSelected = p == selected;
        final color = AtelierTheme.forPriority(Theme.of(context).colorScheme, p);
        return GestureDetector(
          onTap: () => onChanged(p),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isSelected ? color.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Theme.of(context).colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            child: Text(
              'P$p',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final String? projectId;
  final List<Project> projects;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onCreateNew;

  const _ProjectRow({
    required this.projectId,
    required this.projects,
    required this.onChanged,
    this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    final project =
        projects.where((p) => p.id == projectId).firstOrNull;

    return GestureDetector(
      onTap: () => _pickProject(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.folder_outlined,
                  size: 18, color: Theme.of(context).colorScheme.onTertiaryContainer),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    project?.name ?? 'No project',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickProject(BuildContext context) async {
    final chosen = await showModalBottomSheet<String?>(
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
              leading: Icon(Icons.inbox_outlined),
              title: Text('No project',
                  style: TextStyle(fontFamily: 'Inter')),
              onTap: () => Navigator.pop(ctx, ''),
            ),
            ...projects.map(
              (p) => ListTile(
                leading:
                    Icon(Icons.folder_outlined, color: Theme.of(context).colorScheme.primary),
                title: Text(p.name,
                    style: TextStyle(fontFamily: 'Inter')),
                onTap: () => Navigator.pop(ctx, p.id),
              ),
            ),
            if (onCreateNew != null)
              ListTile(
                leading: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
                title: Text('Create new project',
                    style: TextStyle(fontFamily: 'Inter', color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  onCreateNew!();
                },
              ),
          ],
        ),
      ),
    );
    if (chosen != null) {
      onChanged(chosen.isEmpty ? null : chosen);
    }
  }
}

class _SubtaskRow extends ConsumerWidget {
  final Subtask subtask;
  const _SubtaskRow({required this.subtask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref
          .read(databaseProvider)
          .toggleSubtask(subtask.id, !subtask.done),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color:
                    subtask.done ? Theme.of(context).colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: subtask.done
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: 1.5,
                ),
              ),
              child: subtask.done
                  ? Icon(Icons.check,
                      size: 13, color: Theme.of(context).colorScheme.onPrimary)
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                subtask.title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  decoration: subtask.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  color: subtask.done
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _ScheduleCard({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeTrackerRow extends ConsumerWidget {
  final String taskId;
  const _TimeTrackerRow({required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = ref.watch(activeTimerTaskIdProvider) == taskId;
    final logsAsync = ref.watch(timeLogsProvider(taskId));

    return Column(
      children: [
        // Start/Stop button
        GestureDetector(
          onTap: () {
            final service = ref.read(timeTrackerServiceProvider);
            if (isActive) {
              service.stop(taskId);
            } else {
              service.start(taskId);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.error.withOpacity(0.08)
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: colorScheme.error.withOpacity(0.3))
                  : Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? Icons.stop_circle : Icons.play_circle_outline,
                  color: isActive ? colorScheme.error : colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isActive ? 'Stop Timer' : 'Start Timer',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isActive ? colorScheme.error : colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isActive)
                  _LiveTimer(),
              ],
            ),
          ),
        ),
        // Past sessions
        logsAsync.when(
          data: (logs) {
            final completed = logs.where((l) => l.endedAt != null).toList();
            if (completed.isEmpty) return SizedBox.shrink();
            final totalMins = completed.fold<int>(0, (sum, l) => sum + (l.durationMins ?? 0));
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(Icons.history, size: 14, color: colorScheme.onSurfaceVariant),
                  SizedBox(width: 6),
                  Text(
                    '${completed.length} session${completed.length == 1 ? '' : 's'} · ${_formatDuration(totalMins)}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => SizedBox.shrink(),
          error: (_, __) => SizedBox.shrink(),
        ),
      ],
    );
  }

  String _formatDuration(int mins) {
    if (mins < 60) return '${mins}m';
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}

class _LiveTimer extends StatefulWidget {
  @override
  State<_LiveTimer> createState() => _LiveTimerState();
}

class _LiveTimerState extends State<_LiveTimer> {
  late final _start = DateTime.now();
  late final _ticker = Stream.periodic(Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _ticker,
      builder: (_, __) {
        final elapsed = DateTime.now().difference(_start);
        final mm = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
        final ss = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
        final hh = elapsed.inHours;
        return Text(
          hh > 0 ? '$hh:$mm:$ss' : '$mm:$ss',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }
}
