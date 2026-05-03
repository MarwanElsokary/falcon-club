// import 'package:easy_localization/easy_localization.dart';
// import 'package:falconclubapp/core/helpers/extensions.dart';
// import 'package:falconclubapp/core/helpers/spacing.dart';
// import 'package:falconclubapp/core/thems/thems.dart';
// import 'package:falconclubapp/core/widget/center_text_utils.dart';
// import 'package:falconclubapp/core/widget/lottie_animation.dart';
// import 'package:falconclubapp/core/widget/padding_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'dart:io';
//
// import 'edit_video_screen.dart';
//
// class CreatRealScreen extends StatefulWidget {
//   const CreatRealScreen({super.key, required this.playAnimation});
//   final bool playAnimation;
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _CreatRealScreenState createState() => _CreatRealScreenState();
// }
//
// class _CreatRealScreenState extends State<CreatRealScreen> {
//   final ImagePicker _picker = ImagePicker();
//   bool loading = false;
//
//   Future<void> _pickVideo(ImageSource source) async {
//     setState(() {
//       loading = true;
//     });
//     final XFile? video = await _picker.pickVideo(
//       source: source,
//       maxDuration: Duration(minutes: 5),
//     );
//
//     if (video != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => EditVideoScreen(File(video.path)),
//         ),
//       );
//     }
//     setState(() {
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Stack(
//         children: [
//           Container(
//             padding: paddingUtils(),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   InkWell(
//                     borderRadius: BorderRadius.circular(30.r),
//                     onTap: () => _pickVideo(ImageSource.gallery),
//                     child: Container(
//                       height: context.displayHeight / 1.5,
//                       width: context.displayWidth / 1,
//                       padding: paddingUtils(),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30.r),
//                         // ignore: deprecated_member_use
//                         color: greyClr.withOpacity(0.3),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           widget.playAnimation
//                               ? LottieAnimation(
//                                   lottiePath:
//                                       'assets/lottie/Video camera icon.json',
//                                   width: context.displayWidth / 2,
//                                 )
//                               : Text(''),
//                           CenterTextUtils(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                             color: mainColor,
//                             text: 'وش تنتظر؟!'.tr(),
//                           ),
//                           verticalSpace(15),
//                           CenterTextUtils(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                             text: 'ارفع مقاطعك الحين وخلنا نشوف إبداعك'.tr(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           PositionedDirectional(
//             start: 0,
//             end: 0,
//             bottom: 0,
//             top: 0,
//             child: AnimatedSwitcher(
//               duration: Duration(milliseconds: 1000),
//
//               child: loading
//                   ? Container(
//                       width: context.displayWidth / 1,
//                       height: context.displayHeight / 1,
//                       color: offWhiteClr.withOpacity(0.7),
//                       child: Lottie.asset('assets/lottie/load.json'),
//                     )
//                   : Text(''),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
