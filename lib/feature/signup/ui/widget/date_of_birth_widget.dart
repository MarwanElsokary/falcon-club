import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/thems/thems.dart';
import '../../../../../core/widget/text_utils.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/app_bar_utils.dart';
import '../../../../core/widget/button_utils.dart';

class DateOfBirthWidget extends StatefulWidget {
  const DateOfBirthWidget({super.key});

  @override
  State<DateOfBirthWidget> createState() => _DateOfBirthWidgetState();
}

class _DateOfBirthWidgetState extends State<DateOfBirthWidget> {
  DateTime dateTime = DateTime(2024, 1, 1, 10, 20);

  chooseDate(BuildContext contexxt, double width, LoginCubit cubit) {
    return showModalBottomSheet(
      context: contexxt,
      builder: (BuildContext context) {
        return Container(
          height: 350.h,
          width: width / 1,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 3,
                  width: 100,
                  decoration: BoxDecoration(
                    color: greyClr,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                verticalSpace(15),
                TextAppBarUtils(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: 'اختر تاريخ ميلادك'.tr(),
                ),
                verticalSpace(20),
                SizedBox(
                  height: 150, // Fixed height for the date picker
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.white,
                    initialDateTime: dateTime,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        dateTime = newTime;
                      });
                    },
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
                verticalSpace(24.h),
                Row(
                  children: [
                    Expanded(
                      child: ButtonUtils(
                        borderColor: offWhiteClr,
                        text: 'إلغاء'.tr(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        colorstext: Colors.black,
                        background: offWhiteClr,
                      ),
                    ),
                    horizontalSpace(10),
                    Expanded(
                      child: ButtonUtils(
                        text: 'تأكيد'.tr(),
                        onPressed: () {
                          setState(() {
                            cubit.birthDate =
                                '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                          });

                          Navigator.pop(context);
                        },
                        colorstext: Colors.white,
                        background: mainColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        print(dateTime);

        chooseDate(context, width, context.read<LoginCubit>());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 13.w),
        width: width / 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: fillColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w400,

                color: context.read<LoginCubit>().birthDate == ''
                    ? mainColor.withOpacity(0.5)
                    : Colors.black,

                text: context.read<LoginCubit>().birthDate == ''
                    ? 'تاريخ الميلاد'.tr()
                    : context.read<LoginCubit>().birthDate,
              ),
            ),
            SvgPicture.asset('assets/svgs/cleander_date_of_birth.svg'),
          ],
        ),
      ),
    );
  }
}
