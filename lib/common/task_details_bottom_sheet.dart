import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'package:track_your_task/helpers/ui_helpers.dart';
import 'package:track_your_task/features/add_task/add_task_screen.dart';
import 'package:track_your_task/features/add_task/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';

class TaskDetailsBottomSheet extends StatelessWidget {
  final TaskModel task;
  const TaskDetailsBottomSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF013220), Color(0xFF014D2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: const Color(0xFF00C639).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          UIHelper.verticalSpace(24.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.white54,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(editTask: task),
                        ),
                      );
                    },
                    child: Icon(Icons.edit, color: const Color(0xFF00FF00), size: 22.sp),
                  ),
                  UIHelper.horizontalSpace(16.w),
                  GestureDetector(
                    onTap: () {
                      context.read<TaskViewModel>().deleteTask(task.id);
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.delete, color: Colors.redAccent, size: 22.sp),
                  ),
                ],
              ),
            ],
          ),
          
          UIHelper.verticalSpace(20.h),
          
          if (task.notes.isNotEmpty) ...[
            Text(
              'Notes',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              task.notes,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            UIHelper.verticalSpace(20.h),
          ],
          
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              if (task.date.isNotEmpty)
                _buildInfoBadge(Icons.calendar_month, task.date),
              if (task.time.isNotEmpty)
                _buildInfoBadge(Icons.access_time, task.time),
              if (task.category.isNotEmpty)
                _buildInfoBadge(Icons.category, task.category, color: const Color(0xFF00FF00)),
              if (task.reminderMinutes > 0)
                _buildInfoBadge(Icons.notifications_active, '${task.reminderMinutes} min before', color: const Color(0xFF00C639)),
            ],
          ),
          
          UIHelper.verticalSpace(30.h),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text, {Color color = Colors.white70}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          UIHelper.horizontalSpace(6.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
