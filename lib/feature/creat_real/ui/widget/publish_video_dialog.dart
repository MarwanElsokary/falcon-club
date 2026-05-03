// import 'dart:async';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:falconclubapp/core/helpers/extensions.dart';
// import 'package:falconclubapp/core/helpers/spacing.dart';
// import 'package:falconclubapp/core/thems/thems.dart';
// import 'package:falconclubapp/core/widget/center_text_utils.dart';
// import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
// import 'package:flutter/material.dart';
//
// import 'package:percent_indicator/percent_indicator.dart';
//
// publishVideoDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext dialogContext) {
//       return _UploadDialog();
//     },
//   );
// }
//
// // Widget منفصل لـ Dialog التحميل
// class _UploadDialog extends StatefulWidget {
//   @override
//   _UploadDialogState createState() => _UploadDialogState();
// }
//
// class _UploadDialogState extends State<_UploadDialog> {
//   double _uploadProgress = 0.0;
//   String _statusText = 'جاري رفع الفيديو...';
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _startUpload();
//   }
//
//   void _startUpload() {
//     // محاكاة عملية الرفع
//     _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
//       setState(() {
//         _uploadProgress += 0.02;
//
//         if (_uploadProgress >= 1.0) {
//           _uploadProgress = 1.0;
//           _statusText = 'تم النشر بنجاح! 🎉';
//           timer.cancel();
//
//           // إغلاق الـ dialog بعد ثانيتين
//           context.pop();
//           context.pop();
//           showSuccesSnackBar(
//             context: context,
//             title: 'تم نشر الفيديو بنجاح!'.tr(),
//           );
//         } else if (_uploadProgress > 0.3 && _uploadProgress < 0.7) {
//           _statusText = 'الحين ننزله لك...';
//         } else if (_uploadProgress >= 0.7 && _uploadProgress < 1.0) {
//           _statusText = 'باقي شوي ويخلص...';
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: EdgeInsets.all(30),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CenterTextUtils(
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//               color: mainColor,
//               text: 'نشر الفيديو'.tr(),
//             ),
//             SizedBox(height: 30),
//
//             // دائرة التقدم
//             CircularPercentIndicator(
//               radius: 80.0,
//               lineWidth: 12.0,
//               percent: _uploadProgress,
//               center: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CenterTextUtils(
//                     fontSize: 32,
//                     fontWeight: FontWeight.w700,
//                     color: mainColor,
//                     text: '${(_uploadProgress * 100).toInt()}%',
//                   ),
//
//                   if (_uploadProgress < 1.0)
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(mainColor),
//                       ),
//                     ),
//                 ],
//               ),
//               circularStrokeCap: CircularStrokeCap.round,
//               backgroundColor: Colors.grey.shade200,
//               progressColor: _uploadProgress >= 1.0 ? greenClr : mainColor,
//               animation: true,
//               animateFromLastPercent: true,
//             ),
//
//             verticalSpace(30),
//
//             // نص الحالة
//             CenterTextUtils(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: _uploadProgress >= 1.0
//                   ? greenClr
//                   : greyClr.withOpacity(0.8),
//               text: _statusText,
//             ),
//
//             verticalSpace(10),
//
//             // رسالة تشجيعية
//             if (_uploadProgress < 1.0)
//               CenterTextUtils(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: blackclr,
//                 text: 'يلا شوي وينزل فيديوك'.tr(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
