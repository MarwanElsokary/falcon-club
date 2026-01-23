import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/core/widget/show_error_snack_bar.dart'; // إضافة الاستيراد
import '../../../core/routing/routes.dart';
import '../../signup/ui/widget/phone_auth_text_from_field.dart';
import '../cubit/forget_password_cubit.dart';
import '../data/repo/forget_password_repo.dart';
import '../../../../core/di/dependency_injection.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(getIt<ForgetPasswordRepo>()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: mainColor),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'الرجوع'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
        ),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            state.whenOrNull(
              otpSent: (message) {
                context.pushNamed(
                  AppRoute.sendOtp,
                  arguments: {
                    'phoneNumber': context
                        .read<ForgetPasswordCubit>()
                        .phoneController
                        .text,
                  },
                );
              },
              error: (message) {
                showErrorSnackBar(context: context, title: message);
              },
            );
          },
          builder: (context, state) {
            final cubit = context.read<ForgetPasswordCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),

                      Image.asset(
                        'assets/images/Frame 1059.png',
                        height: 180.h,
                        cacheWidth:
                            (180 * MediaQuery.of(context).devicePixelRatio)
                                .round(),
                        cacheHeight:
                            (180 * MediaQuery.of(context).devicePixelRatio)
                                .round(),
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180.h,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.lock_reset,
                            size: 60.w,
                            color: mainColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextUtils(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: mainColor.withAlpha(150),
                          text: 'ادخل رقم هاتفك وسوف يتم ارسال كود إليك'.tr(),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Phone Field
                      PhoneAuthTextFormField(
                        controller: cubit.phoneController,
                        obscureText: false,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'من فضلك تأكد من ادخال رقم الهاتف'.tr();
                          } else if (v.length != 9) {
                            return 'رقم الهاتف يجب أن يكون 9 أرقام'.tr();
                          } else if (!v.startsWith('')) {
                            return 'رقم الهاتف يجب أن يبدأ بـ 5'.tr();
                          }
                          return null;
                        },
                        textInputType: TextInputType.phone,
                        hintText: "",
                        maxLength: 9,
                        onChanged: (value) {
                          if (value.length == 9) {
                            cubit.changeButtonStatus(true);
                          } else {
                            cubit.changeButtonStatus(false);
                          }
                        },
                        suffix: const Icon(
                          Icons.phone_android,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),

                      SizedBox(height: 24.h),


                      // Send Button
                      state.maybeWhen(
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                            strokeWidth: 2.0,
                          ),
                        ),
                        orElse: () => SizedBox(
                          width: double.infinity,
                          child: ButtonUtils(
                            text: 'ارسال'.tr(),
                            onPressed: () {
                              // هنا نفس النمط الذي أرسلته
                              if (_formKey.currentState!.validate()) {
                                cubit.sendOtp();
                              } else {
                                showErrorSnackBar(
                                  context: context,
                                  title: 'من فضلك ادخل رقم هاتفك بشكل صحيح'.tr(),
                                );
                              }
                            },
                            colorstext: Colors.white,
                            background: cubit.phoneController.text.length == 9
                                ? mainColor
                                : Colors.grey[400]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}