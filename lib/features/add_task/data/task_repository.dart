import 'package:get_storage/get_storage.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  TaskRepository._internal();
  static TaskRepository get instance => _instance;

  final _box = GetStorage();
  static const _key = 'tasks';

  List<TaskModel> getAllTasks() {
    final raw = _box.read<List>(_key);
    if (raw == null) return [];
    return raw
        .map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void saveTask(TaskModel task) {
    final tasks = getAllTasks();
    tasks.add(task);
    _save(tasks);
  }

  void updateTask(TaskModel updated) {
    final tasks = getAllTasks();
    final idx = tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      tasks[idx] = updated;
      _save(tasks);
    }
  }

  void deleteTask(String id) {
    final tasks = getAllTasks();
    tasks.removeWhere((t) => t.id == id);
    _save(tasks);
  }

  void _save(List<TaskModel> tasks) {
    _box.write(_key, tasks.map((t) => t.toJson()).toList());
  }
}
