import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lottie/lottie.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../login/cubit/login_state.dart';

class SelectDepartWidget extends StatefulWidget {
  const SelectDepartWidget({super.key});

  @override
  State<SelectDepartWidget> createState() => _SelectCollageWidgetState();
}

class _SelectCollageWidgetState extends State<SelectDepartWidget> {
  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: GestureDetector(
            onTap: () {
              showErrorSnackBar(
                context: context,
                title: 'من فضلك حدد كليتك اولا'.tr(),
              );
            },
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                value: loginCubit.selectedDepartmentsId,
                hint: state is departmentsLoading
                    ? Row(
                        children: [
                          Lottie.asset('assets/lottie/load.json', width: 20.w),
                          horizontalSpace(5),
                          TextUtils(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: greyClr,
                            text: 'جاري التحميل...'.tr(),
                          ),
                        ],
                      )
                    : TextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: greyClr,
                        text: 'اختر تخصصك'.tr(),
                      ),
                isExpanded: true,
                iconStyleData: IconStyleData(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
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
                  scrollbarTheme: ScrollbarThemeData(
                    radius: Radius.circular(10.r),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: MenuItemStyleData(
                  height: 45.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                items: loginCubit.departmentsList.map((departmentsList) {
                  return DropdownMenuItem<int>(
                    value: departmentsList.id,
                    child: TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:
                          loginCubit.selectedDepartmentsId == departmentsList.id
                          ? Colors.black
                          : greyClr,
                      text: departmentsList.name ?? '',
                    ),
                  );
                }).toList(),
                onChanged: (int? newId) {
                  if (newId != null) {
                    setState(() {
                      loginCubit.selectedDepartmentsId = newId;
                    });
                    // loginCubit.emitColleges(universitiesId: newId.toString());
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
