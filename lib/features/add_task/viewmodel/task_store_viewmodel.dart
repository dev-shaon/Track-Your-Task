import 'package:flutter/material.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';

/// Global shared ViewModel — সব screen এ এই একটাই use হবে
class TaskStoreViewModel extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get allTasks => List.unmodifiable(_tasks);

  /// Category অনুযায়ী filter করা tasks
  List<TaskModel> tasksByCategory(String category) {
    return _tasks.where((t) => t.category == category).toList();
  }

  /// Task add করো
  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  /// Task edit করো
  void updateTask(TaskModel updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  /// Task delete করো
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Task complete/incomplete toggle
  void toggleComplete(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }
}
