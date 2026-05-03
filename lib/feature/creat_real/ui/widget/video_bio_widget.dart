// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:falconclubapp/feature/creat_real/cubit/creat_real_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../core/thems/thems.dart';
//
// class VideoBioWidget extends StatelessWidget {
//   // Add this parameter
//
//   const VideoBioWidget({super.key});
//
//   InputDecoration _inputDecoration() {
//     return InputDecoration(
//       fillColor: Colors.transparent,
//       hintText: 'اكتب وصف المقطع...',
//       hintStyle: GoogleFonts.cairo(
//         color: blackclr,
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w700,
//         letterSpacing: -0.30,
//       ),
//       floatingLabelStyle: GoogleFonts.cairo(
//         color: Colors.black,
//         fontSize: 14.sp,
//         fontWeight: FontWeight.w400,
//         letterSpacing: -0.30,
//       ),
//       errorStyle: GoogleFonts.cairo(
//         color: mainColor,
//         fontSize: 14.sp,
//         fontWeight: FontWeight.w400,
//         letterSpacing: -0.30,
//       ),
//       filled: true,
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.transparent),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.transparent),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.transparent),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         // ignore: deprecated_member_use
//         borderSide: BorderSide(color: Colors.transparent),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       style: GoogleFonts.cairo(
//         color: Colors.black,
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w700,
//         letterSpacing: -0.30,
//       ),
//       controller: context.read<CreatRealCubit>().controller,
//       maxLength: null,
//       buildCounter:
//           (
//             BuildContext context, {
//             required int currentLength,
//             required bool isFocused,
//             required int? maxLength,
//           }) => null,
//
//       cursorColor: Colors.black,
//       keyboardType: TextInputType.text,
//       validator: (v) {
//         return null;
//       },
//       textInputAction: TextInputAction.done,
//       decoration: _inputDecoration(),
//       onTapOutside: (event) => FocusScope.of(context).unfocus(),
//     );
//   }
// }
