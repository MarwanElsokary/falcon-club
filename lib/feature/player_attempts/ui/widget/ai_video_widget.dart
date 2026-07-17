import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiVideoWidget extends StatefulWidget {
  final String videoUrl;

  const AiVideoWidget({super.key, required this.videoUrl});

  @override
  State<AiVideoWidget> createState() => _AiVideoWidgetState();
}

class _AiVideoWidgetState extends State<AiVideoWidget> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {});
          });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.isInitialized
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController,
            ),
          )
        : Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              // ignore: deprecated_member_use
              color: greyClr.withOpacity(0.6),
            ),
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 20.w,
                color: Colors.white,
              ),
            ),
          );
  }
}
