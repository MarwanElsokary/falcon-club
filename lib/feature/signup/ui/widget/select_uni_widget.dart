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
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // تحديد حجم التكيف بناءً على عرض الشاشة
        bool isSmallScreen = screenWidth < 360;
        bool isMediumScreen = screenWidth >= 360 && screenWidth < 600;
        bool isLargeScreen = screenWidth >= 600;

        // قيم مخصصة لكل حجم شاشة
        double buttonHeight = isSmallScreen ? 44.h :
        isMediumScreen ? 48.h :
        52.h;

        double iconSize = isSmallScreen ? 18.w :
        isMediumScreen ? 20.w :
        22.w;

        double fontSize = isSmallScreen ? 12.sp :
        isMediumScreen ? 13.sp :
        14.sp;

        double borderRadius = isSmallScreen ? 12.r :
        isMediumScreen ? 14.r :
        16.r;

        double horizontalPadding = isSmallScreen ? 10.w :
        isMediumScreen ? 12.w :
        14.w;

        return BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  verticalSpace(6),
                  Container(
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: mainColor.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<int>(
                        value: loginCubit.selectedUniversityId,
                        hint: state is universityLoading
                            ? Container(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              Lottie.asset(
                                'assets/lottie/load.json',
                                width: iconSize,
                              ),
                              horizontalSpace(8),
                              Expanded(
                                child: TextUtils(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w500,
                                  color: greyClr,
                                  text: 'جاري التحميل...'.tr(),
                                  maxlines: 1,
                                ),
                              ),
                            ],
                          ),
                        )
                            : Container(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                color: mainColor,
                                size: iconSize,
                              ),
                              horizontalSpace(10),
                              Expanded(
                                child: TextUtils(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w500,
                                  color: mainColor.withOpacity(0.7),
                                  text: 'اختر المدينة'.tr(),
                                  maxlines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isExpanded: true,
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: mainColor,
                            size: iconSize * 1.2,
                          ),
                        ),
                        buttonStyleData: ButtonStyleData(
                          height: buttonHeight,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                            color: fillColor,
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: screenHeight * 0.4,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
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
                          height: buttonHeight,
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: _searchController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: 4.h,
                            ),
                            child: TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'ابحث عن مدينة...'.tr(),
                                hintStyle: TextStyle(
                                  color: greyClr,
                                  fontSize: fontSize,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: mainColor,
                                  size: iconSize,
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            final university = loginCubit.universityList
                                .firstWhere((uni) => uni.id == item.value);
                            return university.name
                                ?.toLowerCase()
                                .contains(searchValue.toLowerCase()) ??
                                false;
                          },
                        ),
                        items: loginCubit.universityList.map((university) {
                          return DropdownMenuItem<int>(
                            value: university.id,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: loginCubit.selectedUniversityId == university.id
                                        ? mainColor
                                        : greyClr,
                                    size: iconSize,
                                  ),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: TextUtils(
                                      fontSize: fontSize,
                                      fontWeight: loginCubit.selectedUniversityId == university.id
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: loginCubit.selectedUniversityId == university.id
                                          ? mainColor
                                          : Colors.black87,
                                      text: university.name ?? '',
                                      maxlines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newId) {
                          if (newId != null) {
                            final loginCubit = context.read<LoginCubit>();

                            // إعادة تعيين النادي المختار
                            loginCubit.selectedCollegesId = null;
                            loginCubit.collegesList.clear();

                            setState(() {
                              loginCubit.selectedUniversityId = newId;
                            });

                            // استدعاء API لجلب النوادي
                            loginCubit.emitclubsByCountry(countryId: newId.toString());
                          }
                        },
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _searchController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}