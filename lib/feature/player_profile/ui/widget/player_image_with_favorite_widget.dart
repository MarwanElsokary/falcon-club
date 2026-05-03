// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:falconclubapp/core/helpers/spacing.dart';
// import 'package:falconclubapp/core/thems/thems.dart';
// import 'package:falconclubapp/core/widget/center_text_utils.dart';
// import 'package:falconclubapp/feature/main_screen/data/model/my_profile_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:skeletonizer/skeletonizer.dart';
//
// class PlayerImageWithFavoriteWidget extends StatelessWidget {
//   const PlayerImageWithFavoriteWidget({
//     super.key,
//     required this.playerProfile,
//     required this.showFavoriteButton,
//     required this.isFavorited,
//     required this.isFavLoading,
//     required this.onFavoriteTap,
//   });
//
//   final MyProfileModel playerProfile;
//   final bool showFavoriteButton;
//   final bool isFavorited;
//   final bool isFavLoading;
//   final VoidCallback onFavoriteTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.center,
//           children: [
//             // ── الصورة الأساسية ──────────────────────────────────────────
//             Container(
//               width: 98.w,
//               height: 139.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100.r),
//                 border: Border.all(color: secondMainColor, width: 5.w),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100.r),
//                 child: CachedNetworkImage(
//                   width: 98.w,
//                   height: 139.w,
//                   imageUrl: playerProfile.data.photo ?? '',
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Skeletonizer(
//                     enabled: true,
//                     child: Container(
//                       width: 98.w,
//                       height: 139.w,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20.r),
//                       ),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Padding(
//                     padding: EdgeInsets.all(20.w),
//                     child:
//                     SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
//                   ),
//                 ),
//               ),
//             ),
//
//             // ── زرار القلب — يظهر فقط للمدرب/الكشاف ─────────────────────
//             if (showFavoriteButton)
//               Positioned(
//                 bottom: -6.w,
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: onFavoriteTap,
//                   child: Container(
//                     width: 34.w,
//                     height: 34.w,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       transitionBuilder: (child, animation) =>
//                           ScaleTransition(scale: animation, child: child),
//                       child: isFavLoading
//                           ? Padding(
//                         key: const ValueKey('loading'),
//                         padding: EdgeInsets.all(8.w),
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.red,
//                         ),
//                       )
//                           : Icon(
//                         key: ValueKey(isFavorited),
//                         isFavorited
//                             ? Icons.favorite_rounded
//                             : Icons.favorite_border_rounded,
//                         color:
//                         isFavorited ? Colors.red : Colors.grey,
//                         size: 18.w,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         verticalSpace(5),
//         CenterTextUtils(
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
//           color: greyClr,
//           text: 'Fteet Ai',
//         ),
//         verticalSpace(2),
//         CenterTextUtils(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//           text: playerProfile.data.firstName ?? '',
//         ),
//       ],
//     );
//   }
// }