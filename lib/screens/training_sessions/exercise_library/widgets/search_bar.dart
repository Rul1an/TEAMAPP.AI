import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../exercise_library_controller.dart';

/// Search bar for filtering exercises by name/keyword.
///
/// Uses [ExerciseLibraryController.setSearch] to update state in real-time.
class ExerciseSearchBar extends ConsumerWidget {
  const ExerciseSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(exerciseLibraryControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        key: const Key('exercise_search_field'),
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search exercises…',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
