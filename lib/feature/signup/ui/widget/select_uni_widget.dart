import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lottie/lottie.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../login/cubit/login_state.dart';

class SelectUniWidget extends StatefulWidget {
  const SelectUniWidget({super.key});

  @override
  State<SelectUniWidget> createState() => _SelectUniWidgetState();
}

class _SelectUniWidgetState extends State<SelectUniWidget> {
  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: fillColor,
            borderRadius: BorderRadius.circular(100.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<int>(
              value: loginCubit.selectedUniversityId,
              hint: state is universityLoading
                  ? Row(
                      children: [
                        Lottie.asset('assets/lottie/load.json', width: 20.w),
                        horizontalSpace(5),
                        Expanded(
                          child: TextUtils(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: greyClr,
                            text: 'تحميل...'.tr(),
                          ),
                        ),
                      ],
                    )
                  : TextUtils(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: mainColor.withOpacity(0.5),
                      text: 'اختر المدينه'.tr(),
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
                  borderRadius: BorderRadius.circular(100.r),
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
                scrollbarTheme: ScrollbarThemeData(
                  radius: Radius.circular(100.r),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              items: loginCubit.universityList.map((university) {
                return DropdownMenuItem<int>(
                  value: university.id,
                  child: TextUtils(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: loginCubit.selectedUniversityId == university.id
                        ? Colors.black
                        : greyClr,
                    text: university.name ?? '',
                  ),
                );
              }).toList(),
              onChanged: (int? newId) {
                if (newId != null) {
                  setState(() {
                    loginCubit.selectedUniversityId = newId;
                  });
                  loginCubit.emitclubsByCountry(countryId: newId.toString());
                  // Optionally, call any cubit function to emit colleges based on this university
                  // loginCubit.emitColleges(universitiesId: newId.toString());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
