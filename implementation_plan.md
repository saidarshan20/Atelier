# Atelier — Local-First To-Do App: Implementation Plan (Flutter)

A private, high-end Flutter mobile app. Fully offline — data lives in **Drift (SQLite)** on-device. Follows the **"Digital Atelier"** design system ([ink_slate/DESIGN.md](file:///c:/Users/saida/OneDrive/Documents/3.%20Learnings/Projects/Atelier/reference/ink_slate/DESIGN.md)).

---

## Tech Stack

| Layer | Choice |
|---|---|
| UI | Flutter + Material 3 |
| State | Riverpod 2.0 + `riverpod_annotation` |
| Database | Drift + `sqlite3_flutter_libs` |
| Calendar widget | `table_calendar` |
| Notifications | `flutter_local_notifications` |
| Export/share | `share_plus` |
| Recurrence | Custom engine — pure Dart |

---

## Design Tokens (Inlined from [ink_slate/DESIGN.md](file:///c:/Users/saida/OneDrive/Documents/3.%20Learnings/Projects/Atelier/reference/ink_slate/DESIGN.md))

These must be hardcoded into `ThemeData`. Antigravity must not guess at colours.

**Colours**
| Token | Value |
|---|---|
| `primary` | `#545a94` |
| `primary-dim` | `#484e87` |
| `on-primary` | `#f9f6ff` |
| `primary-container` | `#dfe0ff` |
| `on-primary-container` | `#474d86` |
| `secondary` | `#545e7e` |
| `surface` | `#f8f9fa` |
| `surface-container-lowest` | `#ffffff` |
| `surface-container-low` | `#f1f4f6` |
| `surface-container` | `#eaeff1` |
| `surface-container-high` | `#e3e9ec` |
| `on-surface` | `#2b3437` |
| `on-surface-variant` | `#586064` |
| `outline` | `#737c7f` |
| `outline-variant` | `#abb3b7` (use at 15% opacity for ghost borders) |
| `error` | `#9e3f4e` |

**Typography**
- Headlines / Display: **Manrope** (weights 600, 700, 800)
- Body / Labels: **Inter** (weights 400, 500, 600)
- Task titles: Inter `title-md` 1.125rem / 18sp
- Section labels: Inter `body-md` 0.875rem / 14sp

**Rules**
- No explicit 1px borders — use background colour shifts only
- FAB: `Colors.white.withOpacity(0.8)` + `BackdropFilter(blur: 12)`
- Card hover → shift to `surface-container-lowest` + `BoxShadow(blurRadius: 2, color: onSurface @ 6%)`
- Border radius — cards/sheets: `12px`; chips: full pill; inputs: underline only

---

## Gaps Filled

| Gap | Decision |
|---|---|
| Calendar shows 2023 | Defaults to current month (March 2026) |
| Calendar had no "+" FAB | FAB on Calendar, pre-fills selected date |
| No Add Task modal ref | Bottom sheet: title, project, priority, date/time, reminder |
| Only 3 bottom tab refs | 4 tabs: **Inbox → Calendar → Projects → Search** |
| No Project Detail ref | Task list scoped to project with back button |
| No empty states | Illustrated copy for all screens |
| Task deletion | Three-dot `MoreVert` → Delete / Edit |
| Title editing | **Tap-to-edit** `TextFormField`, auto-saves on dismiss |
| No export/backup | Settings → Export JSON via `share_plus` |
| No sample data | Starts with blank DB |

---

## Proposed Changes

---

### 1 — Project Setup

#### [NEW] Flutter project at `Atelier/`

```bash
flutter create --org com.atelier --project-name atelier .
```

#### [MODIFY] `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  drift: ^2.x
  sqlite3_flutter_libs: ^0.x   # correct native SQLite setup
  riverpod: ^2.x
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x
  flutter_local_notifications: ^x
  table_calendar: ^3.x
  share_plus: ^9.x
  path_provider: ^2.x
  uuid: ^4.x
  intl: ^0.x

dev_dependencies:
  build_runner: ^2.x
  drift_dev: ^2.x
  riverpod_generator: ^2.x
```

> [!IMPORTANT]
> `drift_flutter` does **not** exist. Use `drift` + `sqlite3_flutter_libs`. No `supabase_flutter` — local-only.

---

### 2 — Database Layer (Drift)

#### [NEW] `lib/data/database.dart`

**`tasks` table**
```dart
class Tasks extends Table {
  TextColumn  get id             => text()();                          // UUID
  TextColumn  get title          => text()();
  TextColumn  get notes          => text().nullable()();
  TextColumn  get projectId      => text().nullable()();
  IntColumn   get priority       => integer().withDefault(const Constant(2))(); // P1=highest … P4=lowest
  DateTimeColumn get dueDate     => dateTime().nullable()();
  IntColumn   get reminderMinutes => integer().nullable()();           // e.g. 30, 60, 1440
  BoolColumn  get done           => boolean().withDefault(const Constant(false))();
  IntColumn   get sortOrder      => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt   => dateTime()();
  DateTimeColumn get updatedAt   => dateTime()();
}
```

**`projects` table**
```dart
class Projects extends Table {
  TextColumn get id          => text()();
  TextColumn get name        => text()();
  TextColumn get icon        => text().withDefault(const Constant('folder'))();
  TextColumn get description => text().nullable()();
  TextColumn get color       => text().withDefault(const Constant('#545a94'))();
  IntColumn  get sortOrder   => integer().withDefault(const Constant(0))();
}
```

**`subtasks` table**
```dart
class Subtasks extends Table {
  TextColumn get id     => text()();
  TextColumn get taskId => text()();  // FK → tasks.id
  TextColumn get text   => text()();
  BoolColumn get done   => boolean().withDefault(const Constant(false))();
}
```

**`recurrences` table**
```dart
class Recurrences extends Table {
  TextColumn     get id       => text()();
  TextColumn     get taskId   => text()();           // FK → tasks.id
  TextColumn     get type     => text()();           // 'daily' | 'weekly' | 'monthly'
  IntColumn      get interval => integer().withDefault(const Constant(1))();
  TextColumn     get weekdays => text().nullable()(); // JSON e.g. "[1,3,5]"
  DateTimeColumn get endDate  => dateTime().nullable()();
  DateTimeColumn get nextDue  => dateTime()();
}
```

**`time_logs` table**
```dart
class TimeLogs extends Table {
  TextColumn     get id           => text()();
  TextColumn     get taskId       => text()();  // FK → tasks.id
  DateTimeColumn get startedAt    => dateTime()();
  DateTimeColumn get endedAt      => dateTime().nullable()();
  IntColumn      get durationMins => integer().nullable()();  // set on stop
}
```

#### [NEW] `lib/data/database_provider.dart`
Riverpod `Provider<AppDatabase>` — singleton, opened once.

---

### 3 — State (Riverpod)

#### [NEW] `lib/providers/tasks_provider.dart`
- `tasksProvider` — stream of all non-done tasks ordered by `sortOrder`
- `todayTasksProvider` — tasks where `dueDate` = today
- `upcomingTasksProvider` — tasks where `dueDate` > today
- `tasksByDateProvider(DateTime)`
- `tasksByProjectProvider(String)`

#### [NEW] `lib/providers/projects_provider.dart`
- `projectsProvider` — stream ordered by `sortOrder`

---

### 4 — Services

#### [NEW] `lib/services/notification_service.dart`
- `init()` — requests permission, sets up `flutter_local_notifications`
- `scheduleReminder(Task t)` — schedules at `dueDate - reminderMinutes`
- `cancelReminder(String taskId)`
- Called on task create / edit / complete / delete

#### [NEW] `lib/services/recurrence_engine.dart`
Core feature — pure Dart, no packages.
- `computeNextDue(Recurrence r, DateTime completedAt) → DateTime`
- `onTaskCompleted(Task t)` — if task has a recurrence row, reset `done = false`, update `dueDate` to `nextDue`, then call `computeNextDue` and persist new `nextDue`
- Handles `daily`, `weekly` (respects `weekdays` JSON), `monthly`

#### [NEW] `lib/services/time_tracker_service.dart`
- `start(String taskId)` — inserts a `TimeLog` row with `startedAt = now`, `endedAt = null`
- `stop(String taskId)` — sets `endedAt = now`, computes `durationMins`, updates row
- `activeTaskId` — Riverpod state; ensures only one timer runs at a time
- `getLogsForTask(String taskId) → List<TimeLog>`

> [!IMPORTANT]
> No `sync/` folder. `supabase_service.dart`, `sync_engine.dart`, `sync_queue.dart` do **not** exist. This is local-only.

---

### 5 — Screens

#### [NEW] `lib/screens/inbox_screen.dart`
- Sections: **"Today's Focus"** (due today) → **"Coming Up"** (future) → **"Inbox"** (no date)
- Task card: checkbox + title + P-label chip + project tag + date chip
- Tap task → `TaskDetailSheet`
- Three-dot menu → Edit / Delete
- FAB "+" → `AddTaskSheet`
- Empty state: *"All clear — Your day is yours."*

#### [NEW] `lib/screens/calendar_screen.dart`
- `TableCalendar` widget, `firstDay: DateTime(2020)`, starts at `DateTime.now()`
- Dot markers on dates with tasks
- Selected-day task list below the grid
- "**+ New Task**" button in selected-day panel (pre-fills `dueDate`)
- FAB "+" → `AddTaskSheet` with selected date

#### [NEW] `lib/screens/projects_screen.dart`
- Project cards: icon + name + description + task count
- "Create New Space" card at bottom
- Tap → `ProjectDetailScreen`
- FAB "+" → create project sheet
- Empty state: *"No spaces yet — create your first collection."*

#### [NEW] `lib/screens/search_screen.dart`
- Auto-focused `TextField` on tab activation
- Recent items when empty; live-filters tasks + projects
- Hint: *"Use # for projects"*
- Result tap → `TaskDetailSheet` or `ProjectDetailScreen`

#### [NEW] `lib/screens/project_detail_screen.dart`
- Back button + project icon + name
- Task list scoped to project
- FAB "+" → `AddTaskSheet` with project pre-filled

#### [NEW] `lib/screens/settings_screen.dart`
- **Export JSON** — serialise tasks + projects + subtasks + recurrences → `share_plus` share sheet
- **Import JSON** — file picker → parse → upsert via Drift
- App version

---

### 6 — Shared Widgets

#### [NEW] `lib/widgets/task_detail_sheet.dart`
```dart
DraggableScrollableSheet(
  initialChildSize: 0.7,
  minChildSize: 0.5,
  maxChildSize: 0.95,
  snap: true,
  snapSizes: [0.5, 0.7, 0.95],
)
```
Contents (top → bottom):
1. Drag handle
2. Priority chip (P1–P4) + "Created X ago"
3. **Title** — `TextFormField` in-place, Manrope bold 32sp; auto-saves on `onEditingComplete` / sheet dismiss
4. Project row (tap → project picker sheet)
5. Notes `TextField`
6. Sub-tasks list + "Add item" button
7. Reminders & Schedule (due date picker + `reminderMinutes` dropdown: None/15/30/60/1440)
8. Time log row (start/stop timer, shows elapsed)
9. Delete button (destructive, bottom)

#### [NEW] `lib/widgets/add_task_sheet.dart`
Lightweight bottom sheet, auto-focuses title:
- Large Manrope title input
- Project chips row
- Priority chips P1 / P2 / P3 / P4
- Date + Time row
- Reminder dropdown (None / 15 min / 30 min / 1 h / 1 day)
- "Add" + "Cancel"

#### [NEW] `lib/widgets/task_card.dart`
Reusable task row used in Inbox, Calendar, Project Detail.

---

### 7 — Navigation Shell

#### [MODIFY] `lib/main.dart`
- `ProviderScope` wraps `MaterialApp`
- `ThemeData` with all tokens from §Design Tokens above

#### [NEW] `lib/shell.dart`
- `IndexedStack` for 4 tabs (preserves scroll state)
- `BottomNavigationBar`: **Inbox → Calendar → Projects → Search**
- Active tab: `surface-container-low` pill background, `primary` icon + Manrope label

---

## Verification Plan

### Build Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

### Device Tests
1. All 4 tabs switch, scroll state preserved
2. Add task (Inbox FAB) → appears in correct section
3. Add task (Calendar FAB) → dot appears on date
4. Tap task → `DraggableScrollableSheet` slides up at 70%, drags to 95%
5. Tap title in sheet → keyboard opens, edit saves on dismiss
6. Sub-task toggle → check/uncheck
7. Task complete → strikethrough animation
8. Project create → task list scoped correctly
9. Search live-filters tasks + projects
10. Calendar shows **March 2026** on first open
11. Recurring task complete → `RecurrenceEngine` resets with new `nextDue`
12. Time tracker start/stop → `durationMins` persisted
13. Export JSON → share sheet with valid JSON
14. Hot restart → all data survives (Drift/SQLite)
