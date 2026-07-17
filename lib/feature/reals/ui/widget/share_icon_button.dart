import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/center_text_utils.dart';

class ShareIconButton extends StatefulWidget {
  const ShareIconButton({super.key, required this.index});
  final int index;

  @override
  State<ShareIconButton> createState() => _ShareIconButtonState();
}

class _ShareIconButtonState extends State<ShareIconButton> {
  // 🔥 حل المشكلة: مفيش static - كل زر له key خاص به
  late final GlobalKey _shareButtonKey = GlobalKey();

  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      return true;
    } else if (Platform.isAndroid) {
      if (await Permission.videos.isDenied) {
        final status = await Permission.videos.request();
        return status.isGranted;
      }
      return true;
    }
    return true;
  }

  Future<String?> _downloadVideo(String videoUrl, BuildContext context) async {
    try {
      // A dedicated, interceptor-free Dio for downloading the (public) reel
      // video — deliberately NOT the injected `getIt<Dio>()`. That instance
      // attaches the session `Authorization: Bearer` header to every request via
      // its interceptor, and this download hits a public media host that must
      // never receive the app's session token. Same family as the Auth
      // token-leak fixes: never send the Bearer to a third-party/CDN URL. Its
      // own timeouts, since it inherits none.
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'falcon_video_$timestamp.mp4';
      final filePath = '${directory.path}/$fileName';

      debugPrint('📥 بدء التحميل من: $videoUrl');

      await dio.download(
        videoUrl,
        filePath,
        options: Options(
          // Timeouts live on the dedicated Dio's BaseOptions above.
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(1);
            debugPrint('📥 التقدم: $progress%');
          }
        },
      );

      final file = File(filePath);
      if (await file.exists()) {
        final fileSize = await file.length();
        final fileSizeMB = fileSize / (1024 * 1024);

        debugPrint('📦 حجم الملف: ${fileSizeMB.toStringAsFixed(2)} MB');

        // 🔥 التحقق من أن الملف تم تحميله بنجاح (أكبر من 100 KB)
        if (fileSize < 100 * 1024) {
          debugPrint('❌ الملف صغير جداً ($fileSize bytes) - التحميل فشل');
          await file.delete();
          return null;
        }

        if (fileSizeMB > 50) {
          debugPrint('⚠️ الملف كبير جداً');
          if (context.mounted) {
            _showSizeWarning(context, fileSizeMB);
          }
        }

        return filePath;
      }

      return null;
    } catch (e) {
      debugPrint('❌ خطأ في التحميل: $e');
      return null;
    }
  }

  Future<void> _shareVideo(BuildContext context) async {
    final cubit = context.read<RealsCubit>();
    final reel = cubit.realsVide[widget.index];

    debugPrint('🎬 تم الضغط على زر المشاركة - Index: ${widget.index}');
    debugPrint('🎬 Reel ID: ${reel.id}');
    debugPrint('🎬 Video URL: ${reel.video}');
    debugPrint('🎬 Share Video Path: ${reel.shareVideo}');
    debugPrint('🎬 Share Video Path is null?: ${reel.shareVideo == null}');
    debugPrint('🎬 Share Video Path is empty?: ${reel.shareVideo?.isEmpty ?? true}');

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60.w,
                  height: 60.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'جاري تحضير الفيديو...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        if (context.mounted) {
          Navigator.pop(context);
          _showPermissionDialog(context);
        }
        return;
      }

      String? videoPath;

      // 🔥 محاولة 1: استخدام shareVideoPath
      if (reel.shareVideo != null &&
          reel.shareVideo!.isNotEmpty &&
          !reel.shareVideo!.contains('.m3u8')) {
        debugPrint('✅ محاولة 1: استخدام shareVideoPath للتحميل');
        videoPath = await _downloadVideo(reel.shareVideo!, context);
      }

      // 🔥 محاولة 2: لو shareVideoPath فشل، جرب نحول الـ HLS لـ MP4
      if (videoPath == null && reel.video != null) {
        final videoUrl = reel.video.toString();

        // لو الرابط .m3u8، حاول تحوله لـ .mp4
        if (videoUrl.contains('.m3u8')) {
          debugPrint('⚠️ محاولة 2: تحويل HLS لـ MP4');
          final mp4Url = videoUrl.replaceAll('.m3u8', '.mp4');
          debugPrint('🔄 المحاولة بـ: $mp4Url');
          videoPath = await _downloadVideo(mp4Url, context);
        } else {
          debugPrint('⚠️ محاولة 2: استخدام video URL مباشرة');
          videoPath = await _downloadVideo(videoUrl, context);
        }
      }

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (videoPath != null && context.mounted) {
        await _performShare(context, reel, videoPath);
        _scheduleCleanup(videoPath);
      } else {
        debugPrint('⚠️ كل المحاولات فشلت، سيتم مشاركة الرابط فقط');
        if (context.mounted) {
          await _shareLinkOnly(context, reel);
        }
      }
    } catch (e) {
      debugPrint('❌ خطأ: $e');
      if (context.mounted) {
        Navigator.pop(context);
        _showErrorDialog(context, 'حدث خطأ');
      }
    }
  }

  /// 🔥 الحصول على مكان الزر للـ iOS
  Rect? _getShareButtonRect() {
    try {
      final RenderBox? renderBox =
      _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        debugPrint('📍 مكان الزر: $position, الحجم: $size');

        return Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        );
      }
    } catch (e) {
      debugPrint('⚠️ خطأ في الحصول على مكان الزر: $e');
    }
    return null;
  }

  Future<void> _performShare(BuildContext context, dynamic reel, String videoPath) async {
    try {
      final xFile = XFile(
        videoPath,
        mimeType: 'video/mp4',
        name: 'فيديو_falcon_${reel.id}.mp4',
      );

      final playerName = reel.playerName ?? 'لاعب';

      final shareText =
          'فيديو اللاعب $playerName\n'
          'تطبيق فتيت لاكتشاف المواهب الرياضية في كرة القدم\n\n'
          'https://apps.apple.com/app/id6744823258';

      final sharePositionOrigin = _getShareButtonRect();

      final result = await Share.shareXFiles(
        [xFile],
        text: shareText,
        subject: 'فيديو اللاعب $playerName',
        sharePositionOrigin: sharePositionOrigin,
      );

      if (context.mounted && result.status == ShareResultStatus.success) {
        _showSuccessSnackbar(context);
      }
    } catch (e) {
      if (context.mounted) {
        await _shareLinkOnly(context, reel);
      }
    }
  }

  Future<void> _shareLinkOnly(BuildContext context, dynamic reel) async {
    final playerName = reel.playerName ?? 'لاعب';

    final shareText =
        'فيديو اللاعب $playerName\n'
        'تطبيق فتيت لاكتشاف المواهب الرياضية في كرة القدم\n\n'
        'https://apps.apple.com/app/id6744823258';

    final sharePositionOrigin = _getShareButtonRect();

    await Share.share(
      shareText,
      subject: 'فيديو اللاعب $playerName',
      sharePositionOrigin: sharePositionOrigin,
    );

    if (context.mounted) {
      _showInfoSnackbar(context);
    }
  }
  void _scheduleCleanup(String filePath) {
    Future.delayed(const Duration(seconds: 30), () {
      try {
        final file = File(filePath);
        if (file.existsSync()) {
          file.deleteSync();
          debugPrint('🗑️ تم حذف الملف');
        }
      } catch (e) {
        debugPrint('⚠️ خطأ في الحذف: $e');
      }
    });
  }

  void _showSizeWarning(BuildContext context, double sizeMB) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('الفيديو كبير (${sizeMB.toStringAsFixed(1)} MB)'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت المشاركة بنجاح'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showInfoSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت مشاركة الرابط'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('صلاحيات مطلوبة'),
        content: Text('يحتاج التطبيق للوصول للتخزين'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text('الإعدادات'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔨 بناء ShareIconButton - Index: ${widget.index}');

    return Column(
      children: [
        GestureDetector(
          // 🔥 إضافة key هنا
          key: _shareButtonKey,
          behavior: HitTestBehavior.opaque,
          onTap: () {
            debugPrint('🎯 تم الضغط على Share - Index: ${widget.index}');
            _shareVideo(context);
          },
          child: Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 45.w,
                  height: 45.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              PositionedDirectional(
                start: 0,
                bottom: 0,
                end: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(10.w), // 🔥 توسيع منطقة الضغط الداخلية
                  child: SvgPicture.asset('assets/svgs/share_reals.svg'),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(5),
        SizedBox(
          width: 45.w,
          child: CenterTextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: '', // 🔥 نفس نمط الأزرار الأخرى
          ),
        ),
      ],
    );
  }
}