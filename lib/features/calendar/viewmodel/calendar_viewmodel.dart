import 'package:flutter/material.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'package:track_your_task/features/add_task/data/task_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<TaskModel> _allTasks = [];

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  CalendarViewModel() {
    _selectedDay = DateTime.now();
    _loadTasks();
  }

  void _loadTasks() {
    _allTasks = TaskRepository.instance.getAllTasks();
    notifyListeners();
  }

  void refreshTasks() {
    _loadTasks();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    notifyListeners();
  }

  bool isSelectedDay(DateTime day) {
    if (_selectedDay == null) return false;
    return isSameDay(_selectedDay, day);
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// কোনো দিনে task আছে কিনা
  bool hasTaskOnDay(DateTime day) {
    return _allTasks.any((task) => _taskMatchesDay(task, day));
  }

  /// selected day এর tasks
  List<TaskModel> get selectedDayTasks {
    if (_selectedDay == null) return [];
    return _allTasks
        .where((task) => _taskMatchesDay(task, _selectedDay!))
        .toList();
  }

  bool _taskMatchesDay(TaskModel task, DateTime day) {
    if (task.date.isEmpty) return false;
    try {
      final parts = task.date.split('/');
      final taskDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      return isSameDay(taskDate, day);
    } catch (_) {
      return false;
    }
  }
}
