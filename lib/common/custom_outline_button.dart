
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/gen/colors.gen.dart';


class CustomOutlineButton extends StatelessWidget {
  final VoidCallback onTap;
  final String btnName;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? bgColor;
  final Color? fontColor;
  final double? height;
  final double? width;
  final double? fontSize;

  const CustomOutlineButton({
    super.key,
    required this.onTap,
    required this.btnName,
    this.textStyle,
    this.borderRadius,
    this.bgColor,
    this.height,
    this.width,
    this.fontSize,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: ShapeDecoration(
          // color: bgColor ?? AppColors.allPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 22.r),
            side: BorderSide(color: bgColor ?? AppColors.allPrimaryColor),
          ),
        ),
        child: FittedBox(
          child: Text(
            btnName,
            style:
                textStyle ??
                TextFontStyle. headline12w600c3F494Dinter.copyWith(
                  color: fontColor ?? AppColors.allPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize ?? 14.sp,
                ),
          ),
        ),
      ),
    );
  }
}
