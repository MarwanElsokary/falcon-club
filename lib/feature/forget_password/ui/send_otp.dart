import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/feature/forget_password/data/widgets/pin_put.dart';
import 'package:falcon/feature/forget_password/data/widgets/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/core/widget/show_error_snack_bar.dart';
import '../../../core/routing/routes.dart';
import '../../pinput/ui/widget/pin_put_widget.dart';
import '../cubit/forget_password_cubit.dart';
import '../data/repo/forget_password_repo.dart';
import '../../../../core/di/dependency_injection.dart';

class SendOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const SendOtpScreen({super.key, required this.phoneNumber});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ForgetPasswordCubit(getIt<ForgetPasswordRepo>());
        cubit.phoneController.text = widget.phoneNumber; // هنا نعين رقم الهاتف
        return cubit;
      },
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          state.whenOrNull(
            otpVerified: (token) {
              context.pushNamed(
                AppRoute.resetPasswordScreen,
                arguments: {'token': token},
              );
            },
            error: (message) {
              showErrorSnackBar(context: context, title: message);
            },
          );
        },
        builder: (context, state) {
          final cubit = context.read<ForgetPasswordCubit>();

          bool isButtonEnabled = cubit.otpController.text.length == 6;

          bool isVerifying = state.maybeWhen(
            verifying: () => true,
            orElse: () => false,
          );

          return Scaffold(
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
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),

                    Image.asset(
                      'assets/images/Frame 1059 (1).png',
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
                          Icons.verified_user,
                          size: 60.w,
                          color: mainColor,
                        ),
                      ),
                    ),

                    verticalSpace(24),

                    Align(
                      alignment: AlignmentGeometry.center,
                      child: TextUtils(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: mainColor.withAlpha(150),
                        text:
                            'نرجو ادخال الكود المكون من اربع ارقام الذي ارسل الي رقمك +966 ${widget.phoneNumber}'
                                .tr(),
                      ),
                    ),

                    verticalSpace(32),

                    // Form و PinPutWidget
                    Form(key: _otpFormKey, child: PinPutWidgetForget()),

                    verticalSpace(24),

                    // TimerWidget
                    TimerWidget(phoneNumber: widget.phoneNumber),

                    verticalSpace(24),

                    // زر التحقق مع تحسين
                    if (isVerifying)
                      Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                          strokeWidth: 2.0,
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  if (_otpFormKey.currentState!.validate()) {
                                    cubit.verifyOtp();
                                  } else {
                                    showErrorSnackBar(
                                      context: context,
                                      title: 'من فضلك ادخل الرمز بشكل صحيح'
                                          .tr(),
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonEnabled
                                ? mainColor
                                : Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          child: Text(
                            'تحقق'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // رسالة إذا لم يكتمل الرمز
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
