import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'package:track_your_task/features/add_task/viewmodel/task_viewmodel.dart';
import 'package:track_your_task/features/add_task/add_task_screen.dart';
import 'package:track_your_task/features/home/presentation/fullscreen.dart';
import 'package:track_your_task/gen/colors.gen.dart';

class AllTaskScreen extends StatelessWidget {
  const AllTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskVm = context.watch<TaskViewModel>();
    final tasks = taskVm.tasks;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'All Tasks (${tasks.length})',
          style: TextFontStyle.headline18w700c3D3D3Dinter.copyWith(
            color: AppColors.scaffoldColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FullScreen(
        child: tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, color: Colors.white38, size: 60.sp),
                    SizedBox(height: 16.h),
                    Text(
                      'No tasks yet!\nTap + to add one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 16.sp),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(16.w),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: tasks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _TaskCard(task: task);
                  },
                ),
              ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final taskVm = context.read<TaskViewModel>();

    return GestureDetector(
      onTap: () {
        // Edit task
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: taskVm,
              child: AddTaskScreen(editTask: task),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: task.isCompleted
                ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                : [const Color(0xFF013220), const Color(0xFF014D2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFF00FF00)
                : const Color(0xFF00C639),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Category chip
            if (task.category.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  task.category,
                  style: TextStyle(
                    color: const Color(0xFF00FF00),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            SizedBox(height: 8.h),

            /// Title
            Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                decorationColor: Colors.white54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 6.h),

            /// Notes preview
            if (task.notes.isNotEmpty)
              Text(
                task.notes,
                style: TextStyle(color: Colors.white60, fontSize: 11.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

            const Spacer(),

            /// Date & complete button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (task.date.isNotEmpty)
                  Flexible(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white38,
                          size: 11.sp,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            task.date,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  onTap: () => taskVm.toggleComplete(task),
                  child: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.isCompleted
                        ? const Color(0xFF00FF00)
                        : Colors.white38,
                    size: 22.sp,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            /// Delete button
            GestureDetector(
              onTap: () => _confirmDelete(context, taskVm),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade300,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskViewModel taskVm) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF013220),
        title: const Text('Delete Task', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              taskVm.deleteTask(task.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

