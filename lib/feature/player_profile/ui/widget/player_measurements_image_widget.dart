// file: player_bio_image_widget.dart

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../main_screen/data/model/my_profile_model.dart';

class PlayerBioImageWidget extends StatelessWidget {
  final MyProfileModel playerProfile;

  const PlayerBioImageWidget({super.key, required this.playerProfile});

  @override
  Widget build(BuildContext context) {
    final bioImage = playerProfile.data.bioImage;

    // إذا لم توجد صورة قياسات، لا نعرض أي شيء
    if (bioImage == null || bioImage.isEmpty || bioImage == 'null') {
      return SizedBox.shrink();
    }

    return Stack(
      children: [
        Container(
          width: context.displayWidth / 1,
          padding: paddingUtils(),
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              TextUtils(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'صورة القياسات',
              ),
              verticalSpace(15),

              // صورة القياسات
              _buildBioImage(bioImage, context),
            ],
          ),
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: SvgPicture.asset('assets/svgs/Group 385.svg'),
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: SvgPicture.asset('assets/svgs/Group 386-2.svg', width: 120.w),
        ),
      ],
    );
  }

  Widget _buildBioImage(String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImageOptions(context, imageUrl);
      },
      child: Column(
        children: [
          // حاوية الصورة مع مؤشر تحميل
          Container(
            width: double.infinity,
            height: 220.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: mainColor.withOpacity(0.2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // الصورة مع تحميل متحرك
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            greyClr.withOpacity(0.1),
                            greyClr.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: mainColor,
                                backgroundColor: mainColor.withOpacity(0.1),
                              ),
                            ),
                            verticalSpace(10),
                            Text(
                              'جاري تحميل الصورة...',
                              style: TextStyle(
                                color: greyClr,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: greyClr.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, color: greyClr, size: 40.w),
                          verticalSpace(8),
                          Text(
                            'تعذر تحميل الصورة',
                            style: TextStyle(color: greyClr, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Gradient overlay خفيف
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),

                  // زر التكبير في الزاوية
                  Positioned(
                    top: 12.w,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.zoom_in, color: mainColor, size: 20.w),
                    ),
                  ),

                  // شريط "انقر للتحميل أو العرض" - تصميم جديد
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(13.r),
                          bottomRight: Radius.circular(13.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.download_rounded,
                                  color: Colors.white,
                                  size: 14.w,
                                ),
                                horizontalSpace(5),
                                Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 14.w,
                                ),
                              ],
                            ),
                          ),
                          horizontalSpace(10),
                          Expanded(
                            child: Text(
                              'انقر للتحميل أو العرض',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          verticalSpace(12),

          // معلومات التاريخ
          if (playerProfile.data.bioDate != null) _buildDateInfo(),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: mainColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.calendar_today, size: 12.w, color: mainColor),
            ),
          ),
          horizontalSpace(8),
          Text(
            'تاريخ القياسات: ${_formatDate(playerProfile.data.bioDate)}',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'غير محدد';
    }

    try {
      // إزالة الوقت إذا كان موجوداً
      if (dateString.contains('T')) {
        final parts = dateString.split('T');
        if (parts.isNotEmpty) {
          final dateParts = parts[0].split('-');
          if (dateParts.length >= 3) {
            return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
          }
        }
      }

      // إذا كان التاريخ بصيغة yyyy-MM-dd
      if (dateString.contains('-')) {
        final dateParts = dateString.split('-');
        if (dateParts.length >= 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
      }

      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  void _showImageOptions(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'خيارات الصورة',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              verticalSpace(20),

              // زر عرض الصورة
              _buildOptionButton(
                icon: Icons.fullscreen,
                title: 'عرض الصورة كاملة',
                subtitle: 'عرض الصورة بحجم كامل',
                onTap: () {
                  Navigator.pop(context);
                  _showFullScreenImage(context, imageUrl);
                },
              ),
              verticalSpace(10),

              // زر تحميل الصورة
              _buildOptionButton(
                icon: Icons.download_rounded,
                title: 'تحميل الصورة',
                subtitle: 'حفظ الصورة في معرض الصور',
                onTap: () {
                  Navigator.pop(context);
                  _downloadImage(context, imageUrl);
                },
              ),
              verticalSpace(20),

              // زر الإغلاق
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greyClr.withOpacity(0.1),
                    foregroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'إغلاق',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: mainColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(icon, color: mainColor, size: 22.w),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  verticalSpace(2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: greyClr,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  _downloadImage(context, imageUrl);
                },
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator(color: mainColor)),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 40.w,
                      ),
                      verticalSpace(10),
                      Text(
                        'تعذر تحميل الصورة',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    try {
      // طلب إذن الكتابة للتخزين
      if (Platform.isAndroid || Platform.isIOS) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          showSuccesSnackBar(context: context, title: 'يجب منح إذن التخزين لتحميل الصورة');
          return;
        }
      }

      showSuccesSnackBar(context: context, title: 'جاري تحميل الصورة...');

      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      // حفظ الصورة في المعرض
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(bytes),
        quality: 100,
        name:
        'قياسات_${playerProfile.data.firstName}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] == true) {
        showSuccesSnackBar(title: 'تم تحميل الصورة بنجاح', context: context);
      } else {
        showErrorSnackBar(title: 'فشل في تحميل الصورة', context: context);
      }
    } catch (e) {
      showErrorSnackBar(context: context, title: 'حدث خطأ أثناء التحميل: $e');
    }
  }
}