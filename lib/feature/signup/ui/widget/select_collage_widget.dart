import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:lottie/lottie.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../login/cubit/login_state.dart';

class SelectCollageWidget extends StatefulWidget {
  const SelectCollageWidget({super.key});

  @override
  State<SelectCollageWidget> createState() => _SelectCollageWidgetState();
}

class _SelectCollageWidgetState extends State<SelectCollageWidget> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ بعد
  dynamic getValidSelectedValue(LoginCubit cubit) {
    if (cubit.selectedCollegesId != null) {
      bool exists = cubit.collegesList.any((college) =>
      college.id.toString() == cubit.selectedCollegesId.toString());
      return exists ? cubit.selectedCollegesId : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final loginCubit = context.read<LoginCubit>();
        final isEnabled = loginCubit.selectedUniversityId != null;

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  if (!isEnabled)
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 16.w,
                      ),
                    ),
                ],
              ),
              verticalSpace(8),
              Container(
                decoration: BoxDecoration(
                  color: isEnabled ? fillColor : fillColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: isEnabled
                        ? mainColor.withOpacity(0.2)
                        : greyClr.withOpacity(0.3),
                  ),
                  boxShadow: [
                    if (isEnabled)
                      BoxShadow(
                        color: mainColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<dynamic>(
                    value: getValidSelectedValue(loginCubit), // استخدام الدالة للتحقق
                    hint: state is collegesLoading
                        ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Lottie.asset(
                            'assets/lottie/load.json',
                            width: 20.w,
                          ),
                          horizontalSpace(10),
                          Expanded(
                            child: TextUtils(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: greyClr,
                              text: 'جاري تحميل النوادي...'.tr(),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sports_soccer,
                            color: isEnabled
                                ? mainColor
                                : greyClr.withOpacity(0.5),
                            size: 20.w,
                          ),
                          horizontalSpace(10),
                          Expanded(
                            child: TextUtils(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isEnabled
                                  ? mainColor.withOpacity(0.7)
                                  : greyClr.withOpacity(0.5),
                              text: isEnabled
                                  ? 'اختر النادي'.tr()
                                  : 'اختر المدينة أولاً'.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isExpanded: true,
                    // التصحيح هنا: استخدم enabled بدلاً من enableFeedback
                     enableFeedback: isEnabled && loginCubit.collegesList.isNotEmpty,
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isEnabled ? mainColor : greyClr.withOpacity(0.5),
                        size: 24.sp,
                      ),
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 52.h,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: isEnabled ? fillColor : fillColor.withOpacity(0.5),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 350.h,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      offset: Offset(0, -8.h),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    dropdownSearchData: loginCubit.collegesList.length > 10
                        ? DropdownSearchData(
                      searchController: _searchController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'ابحث عن نادي...'.tr(),
                            hintStyle: TextStyle(
                              color: greyClr,
                              fontSize: 14.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: mainColor,
                              size: 20.w,
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        try {
                          final college = loginCubit.collegesList
                              .firstWhere((col) => col.id == item.value);
                          return college.name
                              ?.toLowerCase()
                              .contains(searchValue.toLowerCase()) ??
                              false;
                        } catch (e) {
                          return false;
                        }
                      },
                    )
                        : null,
                    items: loginCubit.collegesList.map((college) {
                      return DropdownMenuItem<dynamic>(
                        value: college.id,
                        child: Row(
                          children: [
                            Icon(
                              Icons.sports_soccer_outlined,
                              color:
                              loginCubit.selectedCollegesId == college.id
                                  ? mainColor
                                  : greyClr,
                              size: 18.w,
                            ),
                            horizontalSpace(10),
                            Expanded(
                              child: TextUtils(
                                fontSize: 14,
                                fontWeight:
                                loginCubit.selectedCollegesId == college.id
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color:
                                loginCubit.selectedCollegesId == college.id
                                    ? mainColor
                                    : Colors.black87,
                                text: college.name ?? '',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: isEnabled && loginCubit.collegesList.isNotEmpty
                        ? (dynamic ? newId) {
                      if (newId != null) {
                        setState(() {
                          loginCubit.selectedCollegesId = newId;
                        });
                      }
                    }
                        : null,
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        _searchController.clear();
                      }
                    },
                  ),
                ),
              ),
              if (!isEnabled)
                Padding(
                  padding: EdgeInsets.only(top: 8.h, right: 8.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 14.w,
                      ),
                      horizontalSpace(5),
                      Flexible(
                        child: TextUtils(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                          text: 'يرجى اختيار المدينة أولاً'.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isEnabled && loginCubit.collegesList.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.h, right: 8.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orange,
                        size: 14.w,
                      ),
                      horizontalSpace(5),
                      Flexible(
                        child: TextUtils(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                          text: 'لا توجد نوادي متاحة في هذه المدينة'.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}