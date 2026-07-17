import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/app_bar_utils.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/package/cubit/package_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/subscription_helper.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../cubit/package_state.dart';

class PackageScreen extends StatelessWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: ' الباقات'.tr()),
      body: BlocBuilder<PackageCubit, PackageState>(
        builder: (context, state) {
          if (state is packageLoading) {
            return Center(
              child: CupertinoActivityIndicator(
                radius: 20.w,
                color: Colors.black,
              ),
            );
          }
          return ListView.builder(
            padding: paddingUtils(),
            itemCount: context.read<PackageCubit>().packageList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final packageList = context.read<PackageCubit>().packageList;
              return Column(
                children: [
                  Container(
                    padding: paddingUtils(),
                    decoration: BoxDecoration(
                      border: Border.all(color: mainColor, width: 3.w),
                      borderRadius: BorderRadius.circular(35.r),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/package_back_ground.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUtils(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: packageList[index].name,
                        ),
                        verticalSpace(10),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 3.w,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Colors.white,
                          ),
                          child: TextUtils(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: mainColor,
                            text:
                                '${packageList[index].durationInDays} ${'يوم'.tr()}',
                          ),
                        ),
                        verticalSpace(10),
                        TextUtils(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text:
                              packageList[index].price.toString() + ' ر.س'.tr(),
                        ),

                        verticalSpace(30),
                        //feature
                        ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: packageList[index].desciptions.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        verticalSpace(3),
                                        SvgPicture.asset(
                                          'assets/svgs/contant_package.svg',
                                        ),
                                      ],
                                    ),
                                    horizontalSpace(5),
                                    Expanded(
                                      child: TextUtils(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        text: packageList[index]
                                            .desciptions[i]
                                            .content,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpace(
                                  i == packageList[index].desciptions.length - 1
                                      ? 0
                                      : 10,
                                ),
                              ],
                            );
                          },
                        ),
                        verticalSpace(30),
// في package_screen.dart - داخل ListView.builder
                        ButtonUtils(
                          border: 30.r,
                          text: 'اشتراك',
                          onPressed: () {
                            // التحقق من حالة الاشتراك
                            //
                            // This read `profile.isSubscribed` directly, which is
                            // true for anyone who *ever* bought a plan — so a user
                            // whose subscription had EXPIRED was told "أنت مشترك
                            // بالفعل" and blocked from renewing it. `isActive`
                            // checks the remaining days too, so an expired plan
                            // can be bought again.
                            if (isActiveSubscription()) {
                              // استخدام showErrorSnackBar مباشرة
                              showErrorSnackBar(
                                context: context,
                                title: 'أنت مشترك بالفعل'.tr(),
                              );
                              return;
                            }
                            // إذا لم يكن مشتركاً، ننتقل إلى شاشة الدفع
                            context.pushNamed(
                              AppRoute.packagePayMentScreen,
                              arguments: {'packageModel': packageList[index]},
                            );
                          },
                          colorstext: mainColor,
                          background: Colors.white,
                        ),                      ],
                    ),
                  ),
                  verticalSpace(15),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
