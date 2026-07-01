import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_your_task/constants/text_font_style.dart';
import 'package:track_your_task/gen/assets.gen.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final EdgeInsets? padding;

  const CustomAppBar({
    super.key,
    this.title,
    this.padding,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        width: double.infinity,
        padding: padding, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(14),
                height: 45.h,
                width: 45.w,
                decoration: BoxDecoration(
                  // color: AppColors.cE3EFFE,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: SvgPicture.asset(Assets.icons.arrowDown),
              ),
            ),
            Text(
              title ?? "",
              style: TextFontStyle.headline12w600c3F494Dinter,
            ),
            SizedBox(width: 48.w),
          ],
        ),
      ),
    );
  }
}
