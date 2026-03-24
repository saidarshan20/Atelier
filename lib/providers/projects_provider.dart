import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../data/database_provider.dart';

final projectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(databaseProvider).watchAllProjects();
});
