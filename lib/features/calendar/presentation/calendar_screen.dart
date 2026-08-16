import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'package:track_your_task/features/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:track_your_task/common/task_details_bottom_sheet.dart';
import 'package:track_your_task/features/home/presentation/fullscreen.dart';
import 'package:track_your_task/helpers/ui_helpers.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel(),
      child: const _CalendarScreenContent(),
    );
  }
}

class _CalendarScreenContent extends StatelessWidget {
  const _CalendarScreenContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarViewModel>();
    final selectedTasks = vm.selectedDayTasks;

    return Scaffold(
      body: FullScreen(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Column(
              children: [
                const Text(
                  "Calendar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UIHelper.verticalSpace(20.h),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF013220), Color(0xFF016A3A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF00).withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF00C639).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: vm.focusedDay,
                      selectedDayPredicate: vm.isSelectedDay,
                      onDaySelected: vm.onDaySelected,
                      calendarBuilders: CalendarBuilders(
                        // Task আছে এমন দিনে dot দেখাবে
                        markerBuilder: (context, day, events) {
                          if (vm.hasTaskOnDay(day)) {
                            return Positioned(
                              bottom: 4,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00FF00),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C639), Color(0xFF1B5E20)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF00FF00,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        selectedDecoration: BoxDecoration(
                          color: const Color(
                            0xFF00FF00,
                          ).withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00FF00),
                            width: 1.5,
                          ),
                        ),
                        defaultDecoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        weekendDecoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        todayTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        weekendTextStyle: const TextStyle(
                          color: Color(0xFF80CBC4),
                          fontSize: 14,
                        ),
                        outsideTextStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 13,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Color(0xFF00FF00),
                          fontWeight: FontWeight.bold,
                        ),
                        cellMargin: const EdgeInsets.all(4),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        leftChevronIcon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00FF00,
                            ).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Color(0xFF00FF00),
                            size: 20,
                          ),
                        ),
                        rightChevronIcon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00FF00,
                            ).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF00FF00),
                            size: 20,
                          ),
                        ),
                        headerPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF00C639,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            topRight: Radius.circular(24.r),
                          ),
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        weekendStyle: TextStyle(
                          color: const Color(0xFF80CBC4).withValues(alpha: 0.8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Selected day tasks
                Expanded(
                  child: selectedTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event_available,
                                color: Colors.white24,
                                size: 48.sp,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'There are no tasks on this day',
                                style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 4.h,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.task_alt,
                                    color: Color(0xFF00FF00),
                                    size: 18,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'This Day Tasks (${selectedTasks.length})',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                itemCount: selectedTasks.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final task = selectedTasks[index];
                                  return _TaskCard(task: task);
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => TaskDetailsBottomSheet(task: task),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: task.isCompleted
                ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                : [const Color(0xFF013220), const Color(0xFF014D2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFF00FF00).withValues(alpha: 0.5)
                : const Color(0xFF00C639).withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? const Color(0xFF00FF00)
                    : const Color(0xFF00C639),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: Colors.white54,
                    ),
                  ),
                  if (task.time.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white38,
                          size: 12,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          task.time,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 11.sp,
                          ),
                        ),
                        if (task.reminderMinutes > 0) ...[
                          SizedBox(width: 8.w),
                          const Icon(
                            Icons.notifications,
                            color: Color(0xFF00C639),
                            size: 12,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${task.reminderMinutes} min before',
                            style: TextStyle(
                              color: const Color(0xFF00C639),
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (task.category.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF00).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFF00FF00).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  task.category,
                  style: TextStyle(
                    color: const Color(0xFF00FF00),
                    fontSize: 10.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
