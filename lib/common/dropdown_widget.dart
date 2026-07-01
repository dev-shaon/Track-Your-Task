// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:track_your_task/constants/text_font_style.dart';
// import 'package:track_your_task/gen/assets.gen.dart';
// import 'package:track_your_task/gen/colors.gen.dart';
// import 'package:track_your_task/helpers/ui_helpers.dart';


// class CustomDropdown extends StatelessWidget {
//   final String hint;
//   final String? value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;
//   final Color? color;

//   const CustomDropdown({
//     super.key,
//     required this.hint,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.scaffoldColor,
//         borderRadius: BorderRadius.circular(8.r),
//         border: Border.all(color: AppColors.c3D3D3D, width: 1.w),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2<String>(
//           isExpanded: true,

//           hint: Text(
//             hint,
//             style: TextFontStyle.headline12w600c3F494Dinter,
//           ),

//           items: items.map((item) {
//             if (item == "__add_other__") {
//               return DropdownMenuItem<String>(
//                 enabled: false,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8.h),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                       debugPrint("Add Other Clicked");
//                     },
//                     child: Container(
//                       height: 40.h,
//                       // padding: EdgeInsets.symmetric(horizontal: 100.w,vertical: 8.h),
//                       decoration: BoxDecoration(
//                         color: AppColors.c3F494D,
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             Assets.icons.arrowDown,
//                             colorFilter: ColorFilter.mode(
//                               AppColors.scaffoldColor,
//                               BlendMode.srcIn,
//                             ),
//                           ),

//                           UIHelper.horizontalSpace(9.w),
//                           Text(
//                             "Add Other",
//                             style: TextFontStyle
//                                 .headline15w600cFEFEFEinter
//                                 .copyWith(color: AppColors.scaffoldColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }

//             return DropdownMenuItem<String>(
//               value: item,
//               child: Text(
//                 item,
//                 style: TextFontStyle.headline12w400c4A5565inter,
//               ),
//             );
//           }).toList(),

//           value: value,

//           onChanged: onChanged,

//           buttonStyleData: ButtonStyleData(
//             height: 37.h,
//             padding: EdgeInsets.symmetric(horizontal: 6.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: color ?? AppColors.scaffoldColor,
//             ),
//           ),

//           iconStyleData: IconStyleData(
//             icon: SvgPicture.asset(Assets.icons.arrowDown, height: 20.h),
//           ),

//           dropdownStyleData: DropdownStyleData(
//             maxHeight: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: AppColors.scaffoldColor,
//             ),
//           ),

//           menuItemStyleData: MenuItemStyleData(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             selectedMenuItemBuilder: (context, child) {
//               return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10.w),
//                 // padding: EdgeInsets.symmetric(horizontal: 12.w,),
//                 decoration: BoxDecoration(
//                   color: AppColors.c00C639,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: child,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
