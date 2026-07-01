import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/features/add_task/viewmodel/task_viewmodel.dart';
import 'package:track_your_task/features/home/viewmodel/home_viewmodel.dart';
import 'package:track_your_task/gen/colors.gen.dart';
import 'package:track_your_task/helpers/ui_helpers.dart';
import 'package:track_your_task/common/task_details_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final taskVm = context.watch<TaskViewModel>();

    final filteredTasks = taskVm.filteredTasks;
    final selectedCategory = taskVm.selectedCategory;

    return Scaffold(
      backgroundColor: const Color(0xFF001F14),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(40.h),

              Text(
                'Categories',
                style: TextFontStyle.headline20w700c3F494Dinter.copyWith(
                  color: AppColors.scaffoldColor,
                ),
              ),

              UIHelper.verticalSpace(20.h),

              GridView.builder(
                itemCount: vm.categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final isPressed = vm.pressedIndex == index;
                  final label = vm.categories[index]['label']!;
                  final isSelected =
                      selectedCategory?.toLowerCase() == label.toLowerCase();

                  return GestureDetector(
                    onTapDown: (_) => vm.onPressDown(index),
                    onTapUp: (_) {
                      vm.onPressUp();
                      if (isSelected) {
                        taskVm.clearFilter();
                      } else {
                        taskVm.filterByCategory(label);
                      }
                    },
                    onTapCancel: vm.onPressUp,
                    child: AnimatedScale(
                      scale: isPressed ? 0.93 : 1,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [
                                    const Color(0xFF00C639),
                                    const Color(0xFF1B5E20),
                                  ]
                                : [
                                    const Color(0xFF013220),
                                    const Color(0xFF016A3A),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF00FF00),
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _WobblingIcon(
                              isSelected: isSelected,
                              iconPath: vm.categories[index]['icon']!,
                            ),
                            UIHelper.verticalSpace(8.h),
                            Text(
                              label,
                              style: TextStyle(
                                color: AppColors.scaffoldColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              UIHelper.verticalSpace(24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory != null
                        ? '$selectedCategory Tasks'
                        : "Today's Tasks",
                    style: TextFontStyle.headline20w700c3F494Dinter.copyWith(
                      color: AppColors.scaffoldColor,
                    ),
                  ),
                  if (selectedCategory != null)
                    GestureDetector(
                      onTap: taskVm.clearFilter,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Show All',
                          style: TextStyle(
                            color: AppColors.c00FF00,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              UIHelper.verticalSpace(16.h),

              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          selectedCategory != null
                              ? 'No tasks in $selectedCategory'
                              : 'No tasks yet!\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredTasks.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => TaskDetailsBottomSheet(task: task),
                              );
                            },
                            child: AnimatedContainer(
                            duration: Duration(
                              milliseconds: 300 + (index * 80),
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: task.isCompleted
                                    ? [
                                        const Color(0xFF1B5E20),
                                        const Color(0xFF2E7D32),
                                      ]
                                    : [
                                        const Color(0xFF013220),
                                        const Color(0xFF014D2A),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: task.isCompleted
                                    ? const Color(0xFF00FF00)
                                    : Colors.transparent,
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor: Colors.white54,
                                        ),
                                      ),
                                      if (task.notes.isNotEmpty) ...[
                                        SizedBox(height: 4.h),
                                        Text(
                                          task.notes,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white60,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      if (task.date.isNotEmpty) ...[
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.white38,
                                              size: 11.sp,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              task.date,
                                              style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                            if (task.time.isNotEmpty) ...[
                                              SizedBox(width: 8.w),
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.white38,
                                                size: 11.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                task.time,
                                                style: TextStyle(
                                                  color: Colors.white38,
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
                                GestureDetector(
                                  onTap: () => taskVm.toggleComplete(task),
                                  child: Icon(
                                    task.isCompleted
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: task.isCompleted
                                        ? const Color(0xFF00FF00)
                                        : Colors.white38,
                                    size: 26.sp,
                                  ),
                                ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WobblingIcon extends StatefulWidget {
  final bool isSelected;
  final String iconPath;

  const _WobblingIcon({
    required this.isSelected,
    required this.iconPath,
  });

  @override
  State<_WobblingIcon> createState() => _WobblingIconState();
}

class _WobblingIconState extends State<_WobblingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      value: 0.5,
    );
    _animation = Tween<double>(begin: -0.12, end: 0.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_WobblingIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.repeat(reverse: true);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.animateTo(0.5, duration: const Duration(milliseconds: 150));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isSelected ? 1.25 : 1.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: child,
          );
        },
        child: SvgPicture.asset(
          widget.iconPath,
          height: 38.sp,
          width: 38.sp,
          colorFilter: const ColorFilter.mode(
            AppColors.scaffoldColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
