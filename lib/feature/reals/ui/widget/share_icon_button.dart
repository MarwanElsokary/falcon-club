import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import '../../../../core/thems/thems.dart';

class ShareIconButton extends StatelessWidget {
  const ShareIconButton({super.key, required this.index});
  final int index;

  // 🔥 دالة تحميل الفيديو من الرابط
  Future<String?> _downloadVideo(String videoUrl) async {
    try {
      final dio = Dio();
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/shared_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await dio.download(
        videoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      return filePath;
    } catch (e) {
      print('Error downloading video: $e');
      return null;
    }
  }

  // 🔥 دالة المشاركة المُحدَّثة
  Future<void> _shareVideo(BuildContext context) async {
    final cubit = context.read<RealsCubit>();
    final reel = cubit.realsVide[index];

    // عرض loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('جاري تحضير الفيديو...'),
            ],
          ),
        ),
      ),
    );

    try {
      // تحميل الفيديو
      final videoPath = await _downloadVideo(reel.video.toString());

      // إغلاق loading
      Navigator.pop(context);

      if (videoPath != null) {
        // 🔥 الحل: إضافة sharePositionOrigin للـ iPad/iOS
        final box = context.findRenderObject() as RenderBox?;
        final sharePositionOrigin = box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null;

        // مشاركة الفيديو مع النص
        final result = await Share.shareXFiles(
          [XFile(videoPath)],
          text: '${reel.description ?? ""}\n\nشاهد هذا الفيديو الرائع! 🎥',
          subject: 'مشاركة فيديو',
          sharePositionOrigin: sharePositionOrigin, // 🔥 هذا هو الحل
        );

        // حذف الملف المؤقت بعد المشاركة
        if (result.status == ShareResultStatus.success ||
            result.status == ShareResultStatus.dismissed) {
          try {
            await File(videoPath).delete();
          } catch (e) {
            print('Error deleting temp file: $e');
          }
        }
      } else {
        // في حالة فشل التحميل، شارك الرابط فقط
        final box = context.findRenderObject() as RenderBox?;
        final sharePositionOrigin = box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null;

        await Share.share(
          '${reel.description ?? ""}\n\nشاهد هذا الفيديو: ${reel.video}',
          subject: 'مشاركة فيديو',
          sharePositionOrigin: sharePositionOrigin,
        );
      }
    } catch (e) {
      print('Share error: $e');

      // إغلاق loading في حالة الخطأ
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // مشاركة الرابط كبديل
      try {
        final box = context.findRenderObject() as RenderBox?;
        final sharePositionOrigin = box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null;

        await Share.share(
          '${reel.description ?? ""}\n\nشاهد هذا الفيديو: ${reel.video}',
          subject: 'مشاركة فيديو',
          sharePositionOrigin: sharePositionOrigin,
        );
      } catch (shareError) {
        print('Fallback share error: $shareError');

        // عرض رسالة للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء المشاركة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _shareVideo(context),
      child: ClipOval(
        child: Container(
          width: 45.w,
          height: 45.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset('assets/svgs/share_reals.svg'),
        ),
      ),
    );
  }
}