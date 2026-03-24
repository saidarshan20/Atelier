# Atelier

A local-first, beautifully designed personal to-do and task management application ("Digital Atelier").

## Overview

Atelier is a completely offline, local-first mobile application built with Flutter. It focuses on providing a premium, visually engaging experience utilizing modern UI design principles such as glassmorphism, dynamic coloring, and intentional, editorial typography. 

It aims to help you manage your daily tasks, projects, and calendar schedules seamlessly without needing an active internet connection or a backend account.

## Key Features

- **Local-First Architecture:** All data is safely stored on your device using an offline `drift` SQLite database. No internet connection is ever required.
- **Dynamic Theming:** Deeply integrates with `dynamic_color` to adapt its color palette to your system's overall theme (Material You support).
- **Task Management:** Create, track, and organize tasks.
- **Project Grouping:** Bundle related tasks together into specific projects for better organization.
- **Calendar Integration:** A bird's-eye view of your tasks using a clean, integrated calendar view powered by `table_calendar`.
- **Reliable Reminders:** Receive timely, localized schedule pushes utilizing `flutter_local_notifications` and exact device timezones.
- **Beautiful UI:** A distinctive "Digital Atelier" design language prioritizing aesthetic excellence and fluid interactions.

## Tech Stack

This project is built using:

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`, `riverpod_annotation`)
- **Local Database:** [Drift](https://drift.simonbinder.eu/) (SQLite)
- **Notifications:** `flutter_local_notifications`, `flutter_timezone`, `timezone`
- **UI & Utilities:** `table_calendar`, `dynamic_color`, `shared_preferences`

## Getting Started

1. **Prerequisites:** Ensure you have the Flutter SDK installed and environment set up. Android Studio or VS Code is recommended.
2. **Clone/Download:** Grab a copy of the repository.
3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
4. **Code Generation:** Because Drift and Riverpod use code generation, run:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Run the App:**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/data/` - Database definitions and queries (Drift).
- `lib/providers/` - Riverpod state pods and controllers.
- `lib/models/` - Domain logic and data structures.
- `lib/screens/` - Main pages (Home, Calendar, Projects, Onboarding).
- `lib/widgets/` - Reusable UI components (Task cards, Bottom sheets).
- `lib/services/` - Background and platform services (Notifications).
- `lib/theme/` - Global styling, typographic tokens, and color logic. 

## License

This project is for personal learning and development. All rights reserved.
