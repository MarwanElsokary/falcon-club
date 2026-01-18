import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/anmiate_builder.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/core/widget/show_error_snack_bar.dart';
import 'package:falcon/feature/creat_real/cubit/creat_real_cubit.dart';
import 'package:falcon/feature/creat_real/cubit/creat_real_state.dart';
import 'package:falcon/feature/creat_real/ui/widget/upload_progras_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import '../../../../core/helpers/extensions.dart';
import '../widget/publish_button_widget.dart';
import '../widget/video_bio_widget.dart';

class PublishMyVideo extends StatefulWidget {
  final String videoPath;

  const PublishMyVideo({required this.videoPath, super.key});

  @override
  _PublishMyVideoState createState() => _PublishMyVideoState();
}

class _PublishMyVideoState extends State<PublishMyVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<CreatRealCubit>().videoPath = widget.videoPath;
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));
    await _controller.initialize();
    setState(() {
      _isInitialized = true;
    });
    _controller.setLooping(true);
    _controller.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        actions: [PublishButtonWidget(), horizontalSpace(20)],
      ),

      // 🔥 استخدام BlocListener للرسائل فقط
      body: BlocListener<CreatRealCubit, CreatRealState>(
        listener: (context, state) {
          state.maybeWhen(
            creatRealsuccess: () {
              context.pop();
              Future.delayed(Duration(microseconds: 300), () {
                showSuccesSnackBar(
                  context: context,
                  title: 'تم رفع الفيديو بنجاح!'.tr(),
                );
              });
              // عرض رسالة نجاح
            },
            creatRealerror: (error) {
              // عرض رسالة الخطأ
              showErrorSnackBar(context: context, title: error);
            },
            orElse: () {},
          );
        },

        // 🔥 Stack يحتوي على الشاشة + Progress Overlay
        child: Stack(
          children: [
            // ========== الـ body الأصلي بتاعك ==========
            _isInitialized
                ? Container(
                    padding: paddingUtils(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //اكتب وصف المقطع...
                          VideoBioWidget(),
                          verticalSpace(20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      _controller.play();
                                    }
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoPlayer(_controller),
                                    // أيقونة Play عند الإيقاف
                                    if (!_controller.value.isPlaying)
                                      AnimateBuilder(
                                        columnCount: 1,
                                        position: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                    PositionedDirectional(
                                      bottom: 0,
                                      start: 0,
                                      end: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        child: VideoProgressIndicator(
                                          _controller,
                                          allowScrubbing: true,
                                          padding: EdgeInsets.all(0),
                                          colors: VideoProgressColors(
                                            playedColor: mainColor,
                                            backgroundColor: greyClr
                                                .withOpacity(0.3),
                                            bufferedColor: greyClr.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),

            // ========== Upload Progress Overlay ==========
            BlocBuilder<CreatRealCubit, CreatRealState>(
              builder: (context, state) {
                // عرض الـ overlay فقط لو في loading أو progress
                final shouldShow = state.maybeWhen(
                  creatRealLoading: () => true,
                  creatRealProgress: (_, __, ___, ____) => true,
                  orElse: () => false,
                );

                if (!shouldShow) return SizedBox.shrink();

                return Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: state.maybeWhen(
                      creatRealProgress:
                          (progress, isCompressing, uploaded, total) {
                            return UploadProgressWidget(
                              progress: progress,
                              isCompressing: isCompressing,
                              uploadedBytes: uploaded,
                              totalBytes: total,
                              onCancel: null,
                            );
                          },
                      creatRealLoading: () {
                        return Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('جاري التحضير...'),
                            ],
                          ),
                        );
                      },
                      orElse: () => SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
