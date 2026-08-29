import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_your_task/features/add_task/add_task_screen.dart';
import 'package:track_your_task/features/all_task/presentation/all_task_screen.dart';
import 'package:track_your_task/features/calendar/presentation/calendar_screen.dart';
import 'package:track_your_task/features/home/presentation/fullscreen.dart';
import 'package:track_your_task/features/home/presentation/home_screen.dart';
import 'package:track_your_task/features/timer/presentation/timer_screen.dart';
import 'package:track_your_task/gen/assets.gen.dart';
import 'package:track_your_task/gen/colors.gen.dart';

class NavberScreen extends StatefulWidget {
  const NavberScreen({super.key});

  @override
  State<NavberScreen> createState() => _NavberScreenState();
}

class _NavberScreenState extends State<NavberScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CalendarScreen(),
    AllTaskScreen(),
    TimerScreen(),
  ];

  final List<String> _screenLabels = ['Home', 'Calendar', 'Tasks', 'Timer'];
  // final List<String> _svgPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FullScreen(child: _screens[_selectedIndex]),
      floatingActionButton: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.c05A981),
          shape: BoxShape.circle,
          color: AppColors.c05A981,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            );
            if (result == true && mounted) {
              setState(() {});
            }
          },
          child: const Icon(
            Icons.add,
            color: AppColors.scaffoldColor,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 16.w, left: 16.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            color: const Color(0xFF001F14),
            border: Border.all(
              color: AppColors.c05A981.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
              height: 70.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(index: 0, svgPath: Assets.icons.homeIcon),
                  _navItem(index: 1, svgPath: Assets.icons.calendarIcon),
                  // SizedBox(width: 32.w), // Space for FAB
                  _navItem(index: 2, svgPath: Assets.icons.allTasks),
                  _navItem(index: 3, svgPath: Assets.icons.timerIcon),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({required int index, required String svgPath}) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h)
            : EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: isSelected ? AppColors.c05A981 : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              height: 24.h,
              width: 24.w,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.white60,
                BlendMode.srcIn,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                _screenLabels[index],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
