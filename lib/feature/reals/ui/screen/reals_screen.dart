import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/reals/ui/widget/stop_and_mute_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/reals_cubit.dart';
import '../../data/model/real_model.dart';
import '../widget/comment_button_widget.dart';
import '../widget/fav_reals_widget.dart';
import '../widget/share_icon_button.dart';
import '../widget/video_user_data_widget.dart';

class RealsScreen extends StatefulWidget {
  const RealsScreen({
    super.key,
    required this.ontap,
    required this.playnowOrNot,
    required this.playerProfile,
  });
  final Function() ontap;
  final bool playnowOrNot;
  final bool playerProfile;

  @override
  State<RealsScreen> createState() => _RealsScreenState();
}

class _RealsScreenState extends State<RealsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  int lastIndex = 0;

  /// ⭐ بدل _videos الثابتة
  List<RealsVide> get reals => context.read<RealsCubit>().realsVide;

  final Map<int, int> _viewIds = {};
  final Map<int, bool> _muted = {};
  final Map<int, bool> _isPlaying = {};
  bool isPlayNow = true;

  @override
  void initState() {
    super.initState();
    log('initState');

    /// تهيئة mute / play لكل فيديو
    for (int i = 0; i < reals.length; i++) {
      _muted[i] = false;
      _isPlaying[i] = false;
    }
  }

  void _pauseAllExcept(int currentIndex) {
    _viewIds.forEach((index, viewId) {
      if (index != currentIndex) {
        final channel = MethodChannel('native-video-view-$viewId');
        channel.invokeMethod('pause');
        _isPlaying[index] = false;
      }
    });
  }

  void _onViewCreated(int index, int viewId) {
    _viewIds[index] = viewId;

    if (index == 0) {
      _playVideo(index);
      _smartPreload(index);
    }
  }

  void _smartPreload(int currentIndex) {
    try {
      const channel = MethodChannel('video-preloader');
      channel.invokeMethod('preload', {
        'urls': reals.map((e) => e.video.toString()).toList(),
        'currentIndex': currentIndex,
      });
    } catch (e) {
      debugPrint('❌ Preload error: $e');
    }
  }

  void _playVideo(int index) {
    lastIndex = index;

    if (!_viewIds.containsKey(index)) return;

    final viewId = _viewIds[index]!;
    final channel = MethodChannel('native-video-view-$viewId');

    _pauseAllExcept(index);

    channel.invokeMethod('play');
    _isPlaying[index] = true;

    setState(() {});
    _smartPreload(index);
  }

  void _pauseVideo(int index) {
    lastIndex = index;

    if (!_viewIds.containsKey(index)) return;

    final viewId = _viewIds[index]!;
    final channel = MethodChannel('native-video-view-$viewId');

    channel.invokeMethod('pause');
    _isPlaying[index] = false;

    setState(() {});
  }

  void _togglePlay(int index) {
    lastIndex = index;

    if (_isPlaying[index] == true) {
      _pauseVideo(index);
      isPlayNow = false;
    } else {
      isPlayNow = true;
      _playVideo(index);
    }
  }

  void _toggleMute(int index) {
    lastIndex = index;

    if (!_viewIds.containsKey(index)) return;

    final viewId = _viewIds[index]!;
    final channel = MethodChannel('native-video-view-$viewId');

    _muted[index] = !(_muted[index] ?? false);
    channel.invokeMethod('setVolume', {'muted': _muted[index]});

    setState(() {});
  }

  bool iOpenItNow = false;

  @override
  Widget build(BuildContext context) {
    /// ⛔ إغلاق وفتح الفيديو عند الرجوع للشاشة
    if (widget.playnowOrNot) {
      if (_viewIds.containsKey(lastIndex) && !iOpenItNow) {
        final viewId = _viewIds[lastIndex]!;
        final channel = MethodChannel('native-video-view-$viewId');

        _pauseAllExcept(lastIndex);
        channel.invokeMethod('play');
        _isPlaying[lastIndex] = true;
      }
      iOpenItNow = true;
    } else {
      iOpenItNow = false;
      if (_viewIds.containsKey(lastIndex)) {
        final viewId = _viewIds[lastIndex]!;
        final channel = MethodChannel('native-video-view-$viewId');
        channel.invokeMethod('pause');
        _isPlaying[lastIndex] = false;
      }
    }

    return PopScope(
      onPopInvoked: (didPop) {
        if (_viewIds.containsKey(lastIndex)) {
          final viewId = _viewIds[lastIndex]!;
          final channel = MethodChannel('native-video-view-$viewId');
          channel.invokeMethod('pause');
          _isPlaying[lastIndex] = false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                final index =
                    (_scrollController.offset /
                            MediaQuery.of(context).size.height)
                        .round();

                if (index != _currentIndex) {
                  _currentIndex = index;
                  _playVideo(_currentIndex);
                }

                return true;
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                physics: const PageScrollPhysics(),

                /// ⭐ هنا عدد الريلز الحقيقية
                itemCount: reals.length,

                itemBuilder: (context, index) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Lottie.asset(
                            'assets/lottie/load.json',
                            width: 100,
                            height: 100,
                          ),
                        ),

                        /// ⭐ تشغيل الفيديو من API
                        GestureDetector(
                          onTap: () => _togglePlay(index),
                          child: SizedBox(
                            height: context.displayHeight,
                            width: context.displayWidth,
                            child: Platform.isAndroid
                                ? AndroidView(
                                    viewType: 'native-video-view',
                                    creationParams: {
                                      'url': reals[index].video.toString(),
                                      'index': index,
                                    },
                                    creationParamsCodec:
                                        const StandardMessageCodec(),
                                    onPlatformViewCreated: (viewId) =>
                                        _onViewCreated(index, viewId),
                                  )
                                : UiKitView(
                                    viewType: 'native-video-view',
                                    creationParams: {
                                      'url': reals[index].video.toString(),
                                      'index': index,
                                    },
                                    creationParamsCodec:
                                        const StandardMessageCodec(),
                                    onPlatformViewCreated: (viewId) =>
                                        _onViewCreated(index, viewId),
                                  ),
                          ),
                        ),

                        PositionedDirectional(
                          end: 20.w,
                          bottom: widget.playerProfile ? 20.h : 100.h,
                          start: 20.w,
                          top: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FavRealsWidget(
                                key: ValueKey(reals[index].id),
                                index: index,
                              ),
                              verticalSpace(10),
                              CommentButtonWidget(
                                index: index,
                                onTap: widget.ontap,
                              ),
                              verticalSpace(10),
                              ShareIconButton(),
                            ],
                          ),
                        ),

                        PositionedDirectional(
                          bottom: widget.playerProfile ? 20.h : 110.h,
                          start: 20.w,
                          end: 75.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: VideoUserDataWidget(
                                  playerProfile: widget.playerProfile,
                                  index: index,
                                  onTab: () async {
                                    if (_viewIds.containsKey(lastIndex)) {
                                      final viewId = _viewIds[lastIndex]!;
                                      final channel = MethodChannel(
                                        'native-video-view-$viewId',
                                      );
                                      channel.invokeMethod('pause');
                                      _isPlaying[lastIndex] = false;
                                    }
                                    context.read<MainCubit>().openProfile =
                                        true;

                                    await Future.delayed(
                                      const Duration(milliseconds: 500),
                                    );

                                    iOpenItNow = false;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        PositionedDirectional(
                          end: 70.w,
                          top: 0,
                          bottom: 180.h,
                          start: 0,
                          child: InkWell(
                            onTap: () => _togglePlay(index),
                            child: Visibility(
                              visible: !isPlayNow,
                              child: StopAndMuteWidget(
                                isPlaying: _isPlaying[index] ?? false,
                                muted: _muted[index] ?? false,
                                toggleMute: () => _toggleMute(index),
                                togglePlay: () => _togglePlay(index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: widget.playerProfile,
              child: PositionedDirectional(
                top: 40.w,
                start: 0.w,
                end: 20.w,
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Row(
                    children: [
                      BackButton(color: Colors.white),
                      Expanded(
                        child: TextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: 'الرجوع'.tr(),
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
