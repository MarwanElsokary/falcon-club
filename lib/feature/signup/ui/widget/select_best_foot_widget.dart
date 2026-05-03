import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';

class SelectBestFootWidget extends StatefulWidget {
  const SelectBestFootWidget({super.key});

  @override
  State<SelectBestFootWidget> createState() => _SelectBestFootWidgetState();
}

class _SelectBestFootWidgetState extends State<SelectBestFootWidget> {
  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    List data = [
      {'title': 'يمين'.tr(), 'id': '0'},
      {'title': 'يسار'.tr(), 'id': '1'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: loginCubit.selectedDirection,
          hint: TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: mainColor.withOpacity(0.5),
            text: 'اختر القدم'.tr(),
          ),
          isExpanded: true,
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.keyboard_arrow_down, color: mainColor),
            iconSize: 24.sp,
          ),
          buttonStyleData: ButtonStyleData(
            height: 46.h,
            padding: EdgeInsets.zero,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            offset: const Offset(0, -5),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
          ),

          /// استخدمنا List data هنا 👇
          items: data.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'],
              child: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: loginCubit.selectedDirection == item['id']
                    ? Colors.black
                    : greyClr,
                text: item['title'],
              ),
            );
          }).toList(),

          /// عند الضغط اطبع الـ id
          onChanged: (String? newId) {
            setState(() {
              loginCubit.selectedDirection = newId;
            });
            print("Selected ID: $newId"); // 👈 هنا الطباعة
            loginCubit.direction = int.parse(newId.toString());
          },
        ),
      ),
    );
  }
}
