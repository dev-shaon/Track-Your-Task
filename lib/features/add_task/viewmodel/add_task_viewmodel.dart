import 'package:flutter/material.dart';

class AddTaskViewModel extends ChangeNotifier {
  final List<String> categories = [
    "Work", "Study", "Personal", "Gym", "Shopping", "Travel",
  ];

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  TimeOfDay? _selectedTime;
  TimeOfDay? get selectedTime => _selectedTime;

  // For edit mode
  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  void initForEdit({
    required String category,
    required String date,
    required String time,
  }) {
    _isEditMode = true;
    _selectedCategory = category.isNotEmpty ? category : null;
    if (date.isNotEmpty) {
      try {
        final parts = date.split('/');
        _selectedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } catch (_) {}
    }
    if (time.isNotEmpty) {
      try {
        final parts = time.split(':');
        _selectedTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  String get formattedDate {
    if (_selectedDate == null) return "Select Date";
    return "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
  }

  String formattedTime(BuildContext context) {
    if (_selectedTime == null) return "Select Time";
    return _selectedTime!.format(context);
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B5E20),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setDate(picked);
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B5E20),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setTime(picked);
  }
}
