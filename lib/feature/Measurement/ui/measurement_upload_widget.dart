// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/helpers/extensions.dart';
// import '../../../core/helpers/spacing.dart';
// import '../../../core/thems/thems.dart';
// import '../../../core/widget/center_text_utils.dart';
// import '../../last_attempt/ui/widget/ai_loading_widget.dart';
// import '../cubit/MeasurementCubit.dart';
// import '../cubit/measurement_state.dart';
//
// class MeasurementUploadWidget extends StatelessWidget {
//   const MeasurementUploadWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MeasurementCubit, MeasurementState>(
//       builder: (context, state) {
//         int percent = 0;
//         if (state is _UploadProgress) {
//           percent = state.progress.clamp(0, 100);
//         }
//
//         return Container(
//           color: offWhiteClr.withOpacity(0.3),
//           child: Center(
//             child: Container(
//               width: context.displayWidth / 1.2,
//               height: context.displayHeight / 2,
//               decoration: BoxDecoration(
//                 color: mainColor,
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Progress circle (same as video upload)
//                   Container(
//                     height: 250.w,
//                     width: 250.w,
//                     padding: EdgeInsets.all(7.w),
//                     decoration: BoxDecoration(
//                       color: offWhiteClr.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: offWhiteClr.withOpacity(0.2),
//                         width: 5.w,
//                       ),
//                     ),
//                     child: CustomPaint(
//                       painter: GradientCirclePainter(
//                         percent: percent / 100,
//                         strokeWidth: 15.w,
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.all(8.w),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: offWhiteClr.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CenterTextUtils(
//                                   fontSize: 35,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                   text: '$percent%',
//                                 ),
//                                 verticalSpace(5),
//                                 CenterTextUtils(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                   color: percent >= 70 ? greenClr : Colors.white,
//                                   text: percent >= 70
//                                       ? 'باقي شوي ويخلص...'
//                                       : 'الحين ننزله لك...',
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
