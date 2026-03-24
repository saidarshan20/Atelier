import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../data/database_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings',
            style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionHeader(title: 'Appearance'),
          _ThemeSettings(),
          SizedBox(height: 32),
          _SectionHeader(title: 'Data & Backup'),
          _SettingsCard(
            icon: Icons.download_outlined,
            title: 'Export JSON',
            subtitle: 'Download a backup of all your tasks',
            onTap: () async {
              final data = await ref.read(databaseProvider).exportAll();
              await _exportJson(context, data);
            },
          ),
          SizedBox(height: 12),
          _SettingsCard(
            icon: Icons.upload_outlined,
            title: 'Import JSON',
            subtitle: 'Restore from a previous backup',
            onTap: () => _importJson(context, ref),
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              'Atelier v1.0.0\nLocal-first ❤',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _importJson(BuildContext context, WidgetRef ref) async {
    try {
      // Use a simple file path input since file_picker needs extra dependency
      // For now we'll use the same export path convention
      final dir = await _getExportDir();
      final file = File('${dir.path}/atelier_backup.json');

      if (!await file.exists()) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No backup file found. Export first, then place atelier_backup.json in Documents.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Confirm with user
      if (!context.mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Restore Backup?'),
          content: Text(
            'This will replace ALL current data with the backup from ${data['exported_at'] ?? 'unknown date'}.\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Restore'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      await ref.read(databaseProvider).importAll(data);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup restored successfully!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<Directory> _getExportDir() async {
    // Same directory used by export
    final dir = await Directory('/storage/emulated/0/Documents').create(recursive: true);
    return dir;
  }

  Future<void> _exportJson(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      final jsonString =
          const JsonEncoder.withIndent('  ').convert(data);
      final bytes = Uint8List.fromList(utf8.encode(jsonString));
      final xFile = XFile.fromData(
        bytes,
        name: 'atelier_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        mimeType: 'application/json',
      );
      await Share.shareXFiles([xFile], subject: 'Atelier Backup');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ThemeSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: Text('Use System Colors (Material You)',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: colorScheme.onSurface)),
            subtitle: Text('Adapts to your wallpaper',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant)),
            value: themeState.useDynamicColor,
            activeColor: colorScheme.primary,
            onChanged: (val) {
              ref.read(themeProvider.notifier).setDynamicColor(val);
            },
          ),
          Divider(height: 1, color: colorScheme.outlineVariant.withOpacity(0.2)),
          ListTile(
            title: Text('Theme Mode',
                style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: colorScheme.onSurface)),
            trailing: DropdownButton<ThemeMode>(
              value: themeState.themeMode,
              underline: SizedBox.shrink(),
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary),
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeProvider.notifier).setThemeMode(mode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
