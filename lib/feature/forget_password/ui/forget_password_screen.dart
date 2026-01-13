import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import '../../signup/ui/widget/phone_auth_text_from_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController _phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      // TODO: إرسال الرمز فعلياً
      Navigator.pushNamed(
        context,
        AppRoute.sendOtp,
        arguments: _phoneController.text, // تمرير رقم الهاتف
      );
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),

              // استخدام cached network image للصور الخارجية
              Image.asset(
                'assets/images/Frame 1059.png',
                height: 180.h,
                cacheWidth: (180 * 2).toInt(),
                cacheHeight: (180 * 2).toInt(),
                filterQuality: FilterQuality.low, // تحسين الأداء
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
                controller: _phoneController,
                obscureText: false,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'من فضلك تأكد من ادخال رقم الهاتف'.tr();
                  } else if (v.length != 9) {
                    return 'رقم الهاتف يجب أن يكون 9 أرقام'.tr();
                  } else if (!v.startsWith('5')) {
                    return 'رقم الهاتف يجب أن يبدأ بـ 5'.tr();
                  }
                  return null;
                },
                textInputType: TextInputType.phone,
                hintText: "5X XXX XXXX",
                maxLength: 9,
                suffix: const Icon(
                  Icons.phone_android,
                  color: Colors.grey,
                  size: 20,
                ),
              ),

              SizedBox(height: 24.h),

              // Send Button
              ButtonUtils(
                text: 'ارسال'.tr(),
                onPressed: _sendOtp,
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
