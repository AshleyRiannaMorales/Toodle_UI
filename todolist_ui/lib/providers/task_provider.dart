import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task]; // Add task to the list
    print('Updated Tasks: $state'); // Debugging line
  }

  void updateTask(Task task) {
    state = [
      for (final t in state)
        if (t.id == task.id) task else t, // Update the task if IDs match
    ];
  }

  // Delete a specific task
  void deleteTask(Task task) {
    state = state.where((t) => t.id != task.id).toList();
  }

  List<Task> getFilteredTasks(String? status) {
    if (status == null) {
      return state;
    }
    return state.where((task) => task.status == status).toList();
  }

}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});
