import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // ✅ شيلنا AutomaticKeepAliveClientMixin خالص
  // ده كان السبب الجذري — بيمنع الـ widget من الـ dispose

  int? _viewId;

  @override
  void dispose() {
    // ✅ لما الـ widget يتدمر، وقف الفيديو فوراً
    if (_viewId != null) {
      try {
        final channel = MethodChannel('native-video-view-$_viewId');
        // Fire-and-forget, so the try/catch above cannot see a rejection: if the
        // native view is torn down first this rejects with MissingPluginException
        // and would surface as an unhandled async error on every disposal.
        channel.invokeMethod('pause').catchError((Object _) => null);
      } catch (_) {}
    }
    super.dispose();
  }

  void _onPlatformViewCreated(int viewId) {
    _viewId = viewId;
    widget.onPlatformViewCreated(viewId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Loading indicator
        const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
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
                    onPlatformViewCreated: _onPlatformViewCreated,
                  )
                : UiKitView(
                    viewType: 'native-video-view',
                    creationParams: {
                      'url': widget.videoUrl,
                      'index': widget.index,
                    },
                    creationParamsCodec: const StandardMessageCodec(),
                    onPlatformViewCreated: _onPlatformViewCreated,
                  ),
          ),
        ),
      ],
    );
  }
}
