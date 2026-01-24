import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentVerificationScreen extends StatefulWidget {
  final String verificationUrl;
  final int packageId;

  const PaymentVerificationScreen({
    super.key,
    required this.verificationUrl,
    required this.packageId,
  });

  @override
  State<PaymentVerificationScreen> createState() =>
      _PaymentVerificationScreenState();
}

class _PaymentVerificationScreenState extends State<PaymentVerificationScreen> {
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _handlePaymentVerification();
  }

  Future<void> _handlePaymentVerification() async {
    try {
      // افتح اللينك في المتصفح الخارجي
      final uri = Uri.parse(widget.verificationUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // يفتح في المتصفح الخارجي
        );

        print('Verification URL opened in browser');

        // استنى 5 ثواني عشان المستخدم يكمل الـ verification
        await Future.delayed(const Duration(seconds: 5));

        setState(() {
          _isProcessing = false;
        });
      } else {
        print('Cannot launch URL: ${widget.verificationUrl}');
        _showError();
      }
    } catch (e) {
      print('Error launching URL: $e');
      _showError();
    }
  }

  void _completePayment() {
    if (mounted) {
      showSuccesSnackBar(
        context: context,
        title: 'تم إرسال طلب الاشتراك بنجاح',
      );
      context.pushNamedAndRemoveUntil(
        AppRoute.mainScreen,
        predicate: (route) => false,
      );
    }
  }

  void _showError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ في فتح صفحة التحقق'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isProcessing,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                CircularProgressIndicator(
                  color: mainColor,
                  strokeWidth: 3.w,
                ),
                SizedBox(height: 20.h),
                Text(
                  'جاري فتح صفحة التحقق الآمن',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    'يرجى إكمال التحقق في المتصفح',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                Icon(
                  Icons.check_circle_outline,
                  size: 80.w,
                  color: Colors.green,
                ),
                SizedBox(height: 20.h),
                Text(
                  'هل أكملت التحقق؟',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _completePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        'نعم، تم الدفع',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}