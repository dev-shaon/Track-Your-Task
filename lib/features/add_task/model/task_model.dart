import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String notes;
  final String category;
  final String date;
  final String time;
  final String reminder;
  final int reminderMinutes; // নতুন: কত মিনিট আগে notification আসবে
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.category,
    required this.date,
    required this.time,
    required this.reminder,
    this.reminderMinutes = 0,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? notes,
    String? category,
    String? date,
    String? time,
    String? reminder,
    int? reminderMinutes,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      reminder: reminder ?? this.reminder,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'notes': notes,
        'category': category,
        'date': date,
        'time': time,
        'reminder': reminder,
        'reminderMinutes': reminderMinutes,
        'isCompleted': isCompleted,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        notes: json['notes'] ?? '',
        category: json['category'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        reminder: json['reminder'] ?? '',
        reminderMinutes: json['reminderMinutes'] ?? 0,
        isCompleted: json['isCompleted'] ?? false,
      );

  String toJsonString() => jsonEncode(toJson());

  factory TaskModel.fromJsonString(String jsonString) =>
      TaskModel.fromJson(jsonDecode(jsonString));
}
