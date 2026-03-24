import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/projects_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/add_task_sheet.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final Project project;
  ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksByProjectProvider(project.id));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.folder_outlined,
                  color: Theme.of(context).colorScheme.onTertiaryContainer, size: 16),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                project.name,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'edit') {
                _editProject(context, ref);
              } else if (val == 'delete') {
                _deleteProject(context, ref);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit project')),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete project', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('Something went wrong')),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_outlined,
                      size: 56,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)),
                  SizedBox(height: 16),
                  Text(
                    'No tasks in this space yet.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => showAddTaskSheet(
                      context,
                      ref,
                      prefilledProjectId: project.id,
                    ),
                    icon: Icon(Icons.add),
                    label: Text('Add first task'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return TaskCard(
                task: task,
                onTap: () => showTaskDetailSheet(context, ref, task),
                onToggle: (done) => ref
                    .read(databaseProvider)
                    .toggleTaskDone(task.id, done ?? false),
                onEdit: () => showTaskDetailSheet(context, ref, task),
                onDelete: () =>
                    ref.read(databaseProvider).deleteTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GlassFab(
          onPressed: () => showAddTaskSheet(
            context,
            ref,
            prefilledProjectId: project.id,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _editProject(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController(text: project.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Project', style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Project name...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Save')),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != project.name) {
      await ref.read(databaseProvider).updateProject(
        ProjectsCompanion(
          id: Value(project.id),
          name: Value(newName),
        ),
      );
    }
  }

  Future<void> _deleteProject(BuildContext context, WidgetRef ref) async {
    final conf = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Project?', style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to completely delete this project and ALL its tasks? This cannot be undone.',
          style: TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (conf == true) {
      final db = ref.read(databaseProvider);
      // Fetch all tasks for this project
      final tasks = await (db.select(db.tasks)..where((t) => t.projectId.equals(project.id))).get();
      // Cancel their notifications & delete them
      for (final t in tasks) {
        await NotificationService.cancelReminder(t.id);
        await db.deleteTask(t.id);
      }
      // Finally, delete the project itself
      await db.deleteProject(project.id);
      
      if (context.mounted) {
        Navigator.pop(context); // Go back to calendar or previous screen
      }
    }
  }
}
