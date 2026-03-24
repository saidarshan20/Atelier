import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/inbox_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/search_screen.dart';
import 'theme/app_theme.dart';

final searchFocusTriggerProvider = StateProvider<int>((ref) => 0);
final _tabIndexProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerWidget {
  AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_tabIndexProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: currentIndex,
        children: [
          InboxScreen(),
          CalendarScreen(),
          ProjectsScreen(),
          SearchScreen(),
        ],
      ),
      bottomNavigationBar: _AtelierBottomNav(
        currentIndex: currentIndex,
        onTap: (i) {
          if (i == 3 && currentIndex == 3) {
            ref.read(searchFocusTriggerProvider.notifier).state++;
          }
          ref.read(_tabIndexProvider.notifier).state = i;
        },
      ),
    );
  }
}

class _AtelierBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AtelierBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.inbox_outlined,
                activeIcon: Icons.inbox,
                label: 'Inbox',
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'Calendar',
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.folder_outlined,
                activeIcon: Icons.folder,
                label: 'Projects',
                index: 2,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: 'Search',
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 22,
              ),
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
