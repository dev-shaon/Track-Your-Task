import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_your_task/features/add_task/add_task_screen.dart';
import 'package:track_your_task/features/all_task/presentation/all_task_screen.dart';
import 'package:track_your_task/features/calendar/presentation/calendar_screen.dart';
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
      body: _screens[_selectedIndex],
      floatingActionButton: Container(
        width: 56.w,
        height: 56.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.c1B5E20,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            );
            if (result == true && mounted) {
              setState(() {});
            }
          },
          child: const Icon(Icons.add, color: AppColors.scaffoldColor),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: const Color(0xFF013220),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: SizedBox(
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(index: 0, svgPath: Assets.icons.homeIcon),
                  _navItem(index: 1, svgPath: Assets.icons.calendarIcon),
                  const SizedBox(width: 20),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: isSelected
              ? const Color(0xFF00FF00).withValues(alpha: 0.15)
              : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF00FF00).withValues(alpha: 0.5),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF00FF00) : Colors.white54,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _screenLabels[index],
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF00FF00)
                    : Colors.transparent,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
