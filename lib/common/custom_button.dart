import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String btnName;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? height;
  final double? width;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.btnName,
    this.textStyle,
    this.borderRadius,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius ?? 22.r),
      child: Container(
        width: width ?? 355.w,
        height: height ?? 56.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF013220), Color(0xFF014D2A)],
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 22.r),
        ),
        child: FittedBox(
          child: Text(
            btnName,
            style:
                textStyle ??
                TextFontStyle.headline18w700c3D3D3Dinter.copyWith(
                  color: AppColors.scaffoldColor,
                ),
          ),
        ),
      ),
    );
  }
}
