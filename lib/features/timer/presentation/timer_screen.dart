import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:track_your_task/common/custom_button.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/features/home/presentation/fullscreen.dart';
import 'package:track_your_task/features/timer/viewmodel/timer_viewmodel.dart';
import 'package:track_your_task/gen/assets.gen.dart';
import 'package:track_your_task/gen/colors.gen.dart';
import 'package:track_your_task/helpers/ui_helpers.dart';
import 'package:track_your_task/features/timer/widgets/circular_timer.dart';
import 'package:track_your_task/features/timer/widgets/finished_dialog.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerViewModel(),
      child: const _TimerScreenContent(),
    );
  }
}

class _TimerScreenContent extends StatelessWidget {
  const _TimerScreenContent();

  void _showTimePickerSheet(BuildContext context, TimerViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF013220), Color(0xFF014D2A)],
            ),
          ),
          height: 300,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Select Time",
                style: TextFontStyle.headline20w700c3F494Dinter.copyWith(
                  color: AppColors.scaffoldColor,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.005,
                        diameterRatio: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (value) {
                          vm.selectedHour = value;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) => Center(
                            child: Text(
                              "$index h",
                              style: TextFontStyle.headline15w600cFEFEFEinter
                                  .copyWith(color: AppColors.scaffoldColor),
                            ),
                          ),
                          childCount: 13,
                        ),
                      ),
                    ),
                    Text(
                      ":",
                      style: TextFontStyle.headline18w700c3D3D3Dinter.copyWith(
                        color: AppColors.scaffoldColor,
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        perspective: 0.005,
                        diameterRatio: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (value) {
                          vm.selectedMinute = value;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) => Center(
                            child: Text(
                              "$index m",
                              style: TextFontStyle.headline15w600cFEFEFEinter
                                  .copyWith(color: AppColors.scaffoldColor),
                            ),
                          ),
                          childCount: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  vm.setTime();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.c1B553C,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      "Set Time",
                      style: TextFontStyle.headline18w700c3D3D3Dinter.copyWith(
                        color: AppColors.scaffoldColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showFinishedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TimerFinishedDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF001F14),
      body: FullScreen(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showTimePickerSheet(context, vm),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.c00C639),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF013220), Color(0xFF014D2A)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.c3D3D3D.withValues(alpha: 0.9),
                        blurRadius: 16,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vm.displayTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SvgPicture.asset(
                        Assets.icons.timerIcon,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              CircularTimer(progress: vm.progress, time: vm.timerLabel),
              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          if (vm.isRunning) {
                            vm.pauseTimer();
                          } else {
                            vm.startTimer(() => _showFinishedDialog(context));
                          }
                        },
                        btnName: vm.isRunning ? "Pause" : "Start",
                      ),
                    ),
                    UIHelper.horizontalSpace(10.w),
                    Expanded(
                      child: CustomButton(
                        onTap: vm.resetTimer,
                        btnName: "Reset",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
