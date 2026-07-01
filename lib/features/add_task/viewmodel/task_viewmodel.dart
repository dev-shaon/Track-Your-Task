import 'package:flutter/material.dart';
import 'package:track_your_task/features/add_task/data/task_repository.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final _repo = TaskRepository.instance;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  /// আজকের ±12 ঘন্টার মধ্যের tasks (real 24 hour window)
  List<TaskModel> get todayTasks {
    final now = DateTime.now();
    // আজকের শুরু এবং শেষ
    final todayStart = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _tasks.where((task) {
      if (task.date.isEmpty) return false;
      try {
        final parts = task.date.split('/');
        final taskDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        return taskDate.isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
            taskDate.isBefore(todayEnd.add(const Duration(seconds: 1)));
      } catch (_) {
        return false;
      }
    }).toList();
  }

  List<TaskModel> get filteredTasks {
    final base = _selectedCategory == null ? todayTasks : _tasks;
    if (_selectedCategory == null) return base;
    return base
        .where((t) =>
            t.category.toLowerCase() == _selectedCategory!.toLowerCase())
        .toList();
  }

  TaskViewModel() {
    loadTasks();
  }

  void loadTasks() {
    _tasks = _repo.getAllTasks();
    notifyListeners();
  }

  void addTask(TaskModel task) {
    _repo.saveTask(task);
    loadTasks();
  }

  void updateTask(TaskModel task) {
    _repo.updateTask(task);
    loadTasks();
  }

  void deleteTask(String id) {
    _repo.deleteTask(id);
    loadTasks();
  }

  void toggleComplete(TaskModel task) {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    _repo.updateTask(updated);
    loadTasks();
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilter() {
    _selectedCategory = null;
    notifyListeners();
  }
}
