import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../providers/tasks_provider.dart';
import '../providers/projects_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_detail_sheet.dart';
import 'project_detail_screen.dart';
import '../shell.dart' show searchFocusTriggerProvider;

class SearchScreen extends ConsumerStatefulWidget {
  SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(searchFocusTriggerProvider, (_, __) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    final allTasks = ref.watch(allTasksProvider).value ?? [];
    final allProjects = ref.watch(projectsProvider).value ?? [];

    final filteredTasks = _query.isEmpty
        ? allTasks.take(5).toList()
        : allTasks
            .where((t) =>
                t.title.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    final filteredProjects = _query.isEmpty
        ? <Project>[]
        : allProjects
            .where((p) =>
                p.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Search',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.search,
                        color: Theme.of(context).colorScheme.primary, size: 22),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focusNode,
                      onChanged: (v) => setState(() => _query = v),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type to search or use # for projects',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                      onPressed: () {
                        _ctrl.clear();
                        setState(() => _query = '');
                      },
                    ),
                ],
              ),
            ),
          ),

          // Results
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
              children: [
                if (_query.isEmpty && allTasks.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        'Nothing here yet.\nStart adding tasks from Inbox!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ),

                // Project results
                if (filteredProjects.isNotEmpty) ...[
                  const _ResultHeader(label: 'Projects'),
                  ...filteredProjects.map((p) => _ProjectResult(
                        project: p,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProjectDetailScreen(project: p)),
                        ),
                      )),
                ],

                // Task results
                if (filteredTasks.isNotEmpty) ...[
                  _ResultHeader(
                      label: _query.isEmpty ? 'Recent Tasks' : 'Tasks'),
                  ...filteredTasks.map((t) => _TaskResult(
                        task: t,
                        onTap: () =>
                            showTaskDetailSheet(context, ref, t),
                      )),
                ],

                if (_query.isNotEmpty &&
                    filteredTasks.isEmpty &&
                    filteredProjects.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final String label;
  const _ResultHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TaskResult extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const _TaskResult({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_box_outline_blank,
                color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectResult extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  const _ProjectResult({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.folder_outlined,
                color: Theme.of(context).colorScheme.primary, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '#${project.name}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
