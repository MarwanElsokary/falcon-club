import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

/// 🎥 Video Player Widget
/// Widget منفصل لعرض الفيديو
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int index;
  final Function(int viewId) onPlatformViewCreated;
  final VoidCallback onTap;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.index,
    required this.onPlatformViewCreated,
    required this.onTap,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 🔥 مهم للـ AutomaticKeepAlive

    return Stack(
      fit: StackFit.expand,
      children: [
        // Loading indicator
        Center(
          child: Lottie.asset(
            'assets/lottie/load.json',
            width: 100,
            height: 100,
            repeat: true,
            animate: true,
          ),
        ),

        // Video Player
        GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Platform.isAndroid
                ? AndroidView(
              viewType: 'native-video-view',
              creationParams: {
                'url': widget.videoUrl,
                'index': widget.index,
              },
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: widget.onPlatformViewCreated,
            )
                : UiKitView(
              viewType: 'native-video-view',
              creationParams: {
                'url': widget.videoUrl,
                'index': widget.index,
              },
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: widget.onPlatformViewCreated,
            ),
          ),
        ),
      ],
    );
  }
}