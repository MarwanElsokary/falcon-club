import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/core/helpers/spacing.dart';

import '../../pinput/ui/widget/pin_put_widget.dart';

class SendOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const SendOtpScreen({super.key, required this.phoneNumber});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // إضافة استماع للتحرك بين الخانات
    for (int i = 0; i < 3; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) {
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    String otp = '';
    for (var controller in _controllers) {
      otp += controller.text;
    }

    if (otp.length == 4) {
      // TODO: التحقق من صحة الـ OTP
      print('OTP: $otp');
      Navigator.pushNamed(
        context,
        AppRoute.resetPassword,
      ); // الانتقال لشاشة إعادة تعيين كلمة المرور
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: mainColor),
          onPressed: () => Navigator.pop(context),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Image.asset(
                'assets/images/Frame 1059 (1).png',
                height: 180.h,
                cacheWidth: (180 * 2).toInt(),
                cacheHeight: (180 * 2).toInt(),
              ),

              verticalSpace(24),

              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: mainColor.withAlpha(150),
                text: 'أدخل الرمز المكون من 4 أرقام المرسل إلى'.tr(),
              ),

              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: mainColor.withAlpha(150),
                text: '+966 ${widget.phoneNumber}',
              ),

              verticalSpace(32),

              // OTP Input Fields
              PinPutWidget(),

              verticalSpace(24),

              // Resend Code Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextUtils(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    text: 'لم يصلك الرمز؟'.tr(),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      // TODO: إعادة إرسال الرمز
                      print('إعادة إرسال الرمز إلى ${widget.phoneNumber}');
                    },
                    child: TextUtils(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: mainColor,
                      text: 'إعادة الإرسال'.tr(),
                    ),
                  ),
                ],
              ),

              verticalSpace(32),

              // Verify Button
              ButtonUtils(
                text: 'تحقق'.tr(),
                onPressed: _verifyOtp,
                colorstext: Colors.white,
                background: mainColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
