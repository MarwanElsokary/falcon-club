import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/thems/thems.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/app_bar_utils.dart';
import '../../../../core/widget/text_utils.dart';

class EditGenderWidget extends StatefulWidget {
  const EditGenderWidget({super.key});

  @override
  State<EditGenderWidget> createState() => _EditGenderWidgetState();
}

class _EditGenderWidgetState extends State<EditGenderWidget> {
  String gender = '';

  @override
  void initState() {
    super.initState();
    gender = context.read<LoginCubit>().gender == 0 ? 'رجل' : 'أنثي';
  }

  choosegender(BuildContext contexxt, double width, LoginCubit cubit) {
    return showModalBottomSheet(
      context: contexxt,
      builder: (BuildContext context) {
        return Container(
          height: 180.h,
          width: width / 1,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                text: 'اختر جنسك'.tr(),
              ),

              verticalSpace(30),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          gender = 'رجل';
                        });
                        cubit.gender = 0;
                        context.pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: gender == 'رجل' ? mainColor : null,
                          border: Border.all(
                            color: gender == 'رجل' ? mainColor : greyClr,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextUtils(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: gender == 'رجل'
                                  ? Colors.white
                                  : Colors.black,
                              text: 'رجل'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          gender = 'أنثي';
                        });
                        cubit.gender = 1;
                        context.pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 15.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: gender == 'أنثي' ? mainColor : null,
                          border: Border.all(
                            color: gender == 'أنثي' ? mainColor : greyClr,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextUtils(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: gender == 'أنثي'
                                  ? Colors.white
                                  : Colors.black,
                              text: 'أنثي'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        choosegender(context, width, context.read<LoginCubit>());
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

                color: context.read<LoginCubit>().gender == -1
                    ? mainColor.withOpacity(0.5)
                    : Colors.black,
                text: context.read<LoginCubit>().gender == -1
                    ? 'الجنس'.tr()
                    : gender,
              ),
            ),
            SvgPicture.asset(
              'assets/svgs/expand_more_black_24dp 1.svg',
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
