import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;
import '../data/database.dart';
import '../data/database_provider.dart';
import '../providers/projects_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends ConsumerWidget {
  ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Projects',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: projectsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('Something went wrong')),
        data: (projects) => ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
          children: [
            // Editorial header
            Text(
              'Your Spaces',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w800,
                fontSize: 36,
                letterSpacing: -1.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Organise your thoughts into curated collections.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),

            if (projects.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Icon(Icons.folder_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant
                              .withOpacity(0.4)),
                      SizedBox(height: 16),
                      Text(
                        'No spaces yet —\ncreate your first collection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...projects.map((p) => _ProjectCard(project: p)),

            SizedBox(height: 16),
            // Create New Space
            GestureDetector(
              onTap: () => _showCreateProject(context, ref),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,
                        color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Create New Space',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GlassFab(
          onPressed: () => _showCreateProject(context, ref),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showCreateProject(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Space',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Space name',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  hintText: 'Description (optional)',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Create',
                      style: TextStyle(
                          fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (confirmed == true && nameCtrl.text.isNotEmpty) {
      await ref.read(databaseProvider).insertProject(
            ProjectsCompanion.insert(
              id: Uuid().v4(),
              name: nameCtrl.text.trim(),
              description: Value(descCtrl.text.isEmpty
                  ? null
                  : descCtrl.text.trim()),
            ),
          );
    }
  }
}

class _ProjectCard extends ConsumerWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(project: project)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.folder_outlined,
                  color: Theme.of(context).colorScheme.onTertiaryContainer, size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (project.description != null) ...[
                    SizedBox(height: 2),
                    Text(
                      project.description!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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
}
