import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:track_your_task/common/custom_button.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'package:track_your_task/features/add_task/viewmodel/add_task_viewmodel.dart';
import 'package:track_your_task/features/add_task/viewmodel/task_viewmodel.dart';
import 'package:track_your_task/features/add_task/widgets/categorys_section.dart';
import 'package:track_your_task/gen/assets.gen.dart';
import 'package:track_your_task/gen/colors.gen.dart';
import 'package:track_your_task/helpers/notification_service.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskModel? editTask;
  const AddTaskScreen({super.key, this.editTask});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = AddTaskViewModel();
        if (editTask != null) {
          vm.initForEdit(
            category: editTask!.category,
            date: editTask!.date,
            time: editTask!.time,
          );
        }
        return vm;
      },
      child: _AddTaskScreenContent(editTask: editTask),
    );
  }
}

class _AddTaskScreenContent extends StatefulWidget {
  final TaskModel? editTask;
  const _AddTaskScreenContent({this.editTask});

  @override
  State<_AddTaskScreenContent> createState() => _AddTaskScreenContentState();
}

class _AddTaskScreenContentState extends State<_AddTaskScreenContent> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _reminderMinutesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editTask != null) {
      _titleController.text = widget.editTask!.title;
      _notesController.text = widget.editTask!.notes;
      if (widget.editTask!.reminderMinutes > 0) {
        _reminderMinutesController.text = widget.editTask!.reminderMinutes
            .toString();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _reminderMinutesController.dispose();
    super.dispose();
  }

  Future<void> _saveTask(BuildContext context) async {
    final vm = context.read<AddTaskViewModel>();
    final taskVm = context.read<TaskViewModel>();

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reminderMins =
        int.tryParse(_reminderMinutesController.text.trim()) ?? 0;

    if (widget.editTask != null) {
      final updated = widget.editTask!.copyWith(
        title: title,
        notes: _notesController.text.trim(),
        category: vm.selectedCategory ?? widget.editTask!.category,
        date: vm.formattedDate == 'Select Date'
            ? widget.editTask!.date
            : vm.formattedDate,
        time: vm.formattedTime(context) == 'Select Time'
            ? widget.editTask!.time
            : vm.formattedTime(context),
        reminder: reminderMins > 0 ? '$reminderMins min' : '',
        reminderMinutes: reminderMins,
      );
      taskVm.updateTask(updated);
      // Cancel old notification and schedule new
      await NotificationService.instance.cancelTaskReminder(updated.id);
      await NotificationService.instance.scheduleTaskReminder(updated);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        notes: _notesController.text.trim(),
        category: vm.selectedCategory ?? '',
        date: vm.formattedDate == 'Select Date' ? '' : vm.formattedDate,
        time: vm.formattedTime(context) == 'Select Time'
            ? ''
            : vm.formattedTime(context),
        reminder: reminderMins > 0 ? '$reminderMins min' : '',
        reminderMinutes: reminderMins,
      );
      taskVm.addTask(task);
      // Notification schedule
      await NotificationService.instance.scheduleTaskReminder(task);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              reminderMins > 0
                  ? 'Task added! You will get a reminder $reminderMins minutes before 🔔'
                  : 'Task added!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AddTaskViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF001F14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          vm.isEditMode ? 'Edit Task' : 'Add Task',
          style: TextFontStyle.headline18w700c3D3D3Dinter.copyWith(
            color: AppColors.scaffoldColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Title'),
                    SizedBox(height: 10.h),
                    _textField(
                      controller: _titleController,
                      hint: 'Enter task title',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Set Time & Date'),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () => vm.pickDate(context),
                      child: _infoRow(
                        icon: Icons.calendar_month,
                        text: vm.formattedDate,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () => vm.pickTime(context),
                      child: _infoRow(
                        icon: Icons.access_time,
                        text: vm.formattedTime(context),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Color(0xFF00FF00),
                          size: 20,
                        ),
                        SizedBox(width: 8.w),
                        _label('Reminder'),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'How many minutes before the task starts should we notify you?',
                      style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _reminderMinutesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            style: const TextStyle(
                              color: Color(0xFF00FF00),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: const TextStyle(color: Colors.white30),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.05),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00C639),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00C639),
                                  width: 0.8,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00FF00),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00FF00,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(
                                0xFF00FF00,
                              ).withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            'minutes',
                            style: TextStyle(
                              color: const Color(0xFF00FF00),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      children: [5, 10, 15, 30].map((mins) {
                        return GestureDetector(
                          onTap: () {
                            _reminderMinutesController.text = mins.toString();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              '$mins min',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              _card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Category'),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () async {
                              final result = await showModalBottomSheet(
                                context: context,
                                backgroundColor: const Color(0xFF013220),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) => const CategorysSection(),
                              );
                              if (result != null) vm.setCategory(result);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.topicIcon,
                                  height: 30.h,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  vm.selectedCategory ?? 'Select',
                                  style: TextFontStyle
                                      .headline15w600cFEFEFEinter
                                      .copyWith(color: AppColors.c00FF00),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Notes'),
                    SizedBox(height: 8.h),
                    _textField(
                      controller: _notesController,
                      hint: 'Add notes...',
                      maxLines: 6,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 26.h),

              CustomButton(
                onTap: () => _saveTask(context),
                btnName: vm.isEditMode ? 'Update Task' : 'Target Set',
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.c00C639),
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF013220), Color(0xFF014D2A)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF00C639)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF00C639), width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF00FF00), width: 1.2),
        ),
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.c00C639),
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF014D2A), Color(0xFF013220)],
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00C853)),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: AppColors.c00FF00, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
