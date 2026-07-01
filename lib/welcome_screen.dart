import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_your_task/common/custom_button.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/gen/assets.gen.dart';
import 'package:track_your_task/gen/colors.gen.dart';
import 'package:track_your_task/helpers/all_routes.dart';
import 'package:track_your_task/helpers/navigation_service.dart';
import 'package:track_your_task/helpers/ui_helpers.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                UIHelper.verticalSpace(150.h),
                Center(child: Image.asset(Assets.images.welcome.path)),
                UIHelper.verticalSpace(40.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Simplify, Organize, and Conquer ',
                    style: TextFontStyle.headline24w700c3D3D3Dinter.copyWith(color: AppColors.scaffoldColor),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Your Day',
                        style: TextFontStyle.headline24w700c3D3D3Dinter
                            .copyWith(color: AppColors.c00C639),
                      ),
                    ],
                  ),
                ),

                // Text(
                //   "Welcome to Your \nInventory Manager",
                //   style: TextFontStyle.headline28w700c003012plusJakartaSans,
                //   textAlign: TextAlign.center,
                // ),
                UIHelper.verticalSpace(20.h),
                Text(
                  "Plan your day, organize your tasks, and stay productive with smart reminders designed for your daily life.",
                  style: TextFontStyle.headline15w600cFEFEFEinter.copyWith(color: Colors.greenAccent),
                  textAlign: TextAlign.center,
                ),
                UIHelper.verticalSpace(100.h),
                CustomButton(
                  onTap: () {
                    NavigationService.navigateToReplacementUntil(Routes.navberScreen);
                  },
                  btnName: 'Get Started',
                ),
              ],
            ),
          ),
    );
  }
}
