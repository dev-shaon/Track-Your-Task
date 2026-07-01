

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/gen/colors.gen.dart';



final class ToastUtil {
  ToastUtil._();

  static void showErrorMessage(String message) {
    Get.snackbar(
      titleText: Text(
        "Warning",
        style: TextFontStyle.headline12w600c3F494Dinter,
      ),
      messageText: Text(
        message,
        style: TextFontStyle.headline14w400c3F494Dinter,
      ),
      "",
      message,
      backgroundColor: Colors.red,
      borderRadius: 26.r,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 12.h),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showSuccessMessage(String message) {
    Get.snackbar(
      titleText: Text(
        "Successful",
        style: TextFontStyle.headline12w600c3F494Dinter,
      ),
      messageText: Text(
        message,
        style: TextFontStyle.headline14w500c979292inter,
      ),
      "",
      message,
      backgroundColor: AppColors.c3D3D3D,
      borderRadius: 26.r,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h, bottom: 10.h),
      snackPosition: SnackPosition.TOP,
    );
  }


  
  static void showShortToast(String message) {
    Fluttertoast.showToast(
      msg: message.tr,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

    static void showLongToast(String message) {
    String trn = message.tr;
    Fluttertoast.showToast(
      msg: trn,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}