import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_your_task/gen/colors.gen.dart';

import '../constants/text_font_style.dart';

final class CustomFormField extends StatelessWidget {
  final String? hintText;
  final double? hintFontSize;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final double? fieldHeight;
  final int? maxline;
  final int? minline;
  final String? Function(String?)? validator;
  final bool? validation;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isObsecure;
  final bool isPass;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final bool? isEnabled;
  final double? cursorHeight;
  final Color? disableColor;
  final bool isRead;
  final double? borderRadius;
  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? fillColor;
  final TextStyle? hintsTextStyle;
  final bool? filled;

  const CustomFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.inputType,
    this.fieldHeight,
    this.maxline,
    this.minline,
    this.validator,
    this.validation = false,
    this.suffixIcon,
    this.prefixIcon,
    this.isObsecure = false,
    this.isPass = false,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.labelStyle,
    this.isEnabled,
    this.style,
    this.cursorHeight,
    this.disableColor,
    this.isRead = false,
    this.borderRadius,
    this.hintFontSize,
    this.enableBorderColor,
    this.focusBorderColor,
    this.fillColor,
    this.hintsTextStyle,
    this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isRead,
      cursorHeight: cursorHeight ?? 20.h,
      cursorColor: AppColors.c00C639,
      focusNode: focusNode,
      obscureText: isPass ? isObsecure : false,
      textInputAction: textInputAction,
      autovalidateMode: validation!
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction,
      validator: validator,
      maxLines: maxline ?? 1,
      minLines: minline ?? 1,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      enabled: isEnabled,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: fieldHeight ?? 14.h,
          horizontal: 16.w,
        ),

        filled: filled ?? false,
        fillColor: fillColor ?? AppColors.scaffoldColor,
        isDense: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null
            ? Padding(padding: EdgeInsets.all(12.sp), child: prefixIcon)
            : null,
        hintText: hintText,
        hintStyle:
            hintsTextStyle ??
            TextFontStyle.headline12w600c3F494Dinter.copyWith(
              color: AppColors.scaffoldColor.withValues(alpha: 0.5),
            ),
        labelText: labelText,
        errorStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          // color: AppColors.cD12E34,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: BorderSide(color: AppColors.c008000, width: 2.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: BorderSide(
            color: focusBorderColor ?? AppColors.c008000,
            width: 1.w,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: BorderSide(
            // color: disableColor ?? AppColors.c6D6D6D.withOpacity(0.19),
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          borderSide: BorderSide(
            color: enableBorderColor ?? AppColors.c50C878,
            width: 1.w,
          ),
        ),
      ),
      style:
          style ??
          TextFontStyle.headline14w400c3F494Dinter.copyWith(
            color: AppColors.scaffoldColor,
          ),
      keyboardType: inputType,
    );
  }
}
