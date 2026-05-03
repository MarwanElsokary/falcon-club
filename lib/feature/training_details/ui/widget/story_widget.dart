import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../data/model/exercise_details_model.dart';

class StoryWidget extends StatefulWidget {
  final List<Video> videos;
  final String image;

  const StoryWidget({required this.videos, super.key, required this.image});

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  late PageController _pageController;
  late List<VideoPlayerController?> _controllers;
  int _currentIndex = 0;
  bool ispause = false;
  bool showPause = false;
  bool showTitle = false;
  var currentController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _controllers = List.generate(widget.videos.length, (_) => null);

    _initializeController(0);
    if (widget.videos.length > 1) {
      _initializeController(1);
    }
  }

  Future<void> _initializeController(int index) async {
    if (index >= widget.videos.length) return;

    final controller = VideoPlayerController.network(
      widget.videos[index].video,
    );
    await controller.initialize();
    controller.setLooping(false);

    // listener لتحديث الـ progress و كشف النهاية
    controller.addListener(() {
      if (mounted) {
        setState(() {}); // لتحديث الـ progress bar
        // بداية الفيديو
        if (controller.value.position.inMilliseconds == 0 &&
            controller.value.isPlaying) {
          print('start');
          showDataFun();
        }

        // إذا الفيديو وصل للنهاية
        if (controller.value.position >= controller.value.duration &&
            !controller.value.isPlaying) {
          print('done'); // هنا هيتطبع "done"

          if (_currentIndex != widget.videos.length - 1) {
            _pageController.animateToPage(
              _currentIndex + 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );

            final oldController = _controllers[_currentIndex]!;
            oldController.seekTo(Duration.zero);
            oldController.play();
            setState(() {});
          }
        }
      }
    });

    setState(() {
      _controllers[index] = controller;
    });

    if (index == _currentIndex) {
      controller.play();
    }
  }

  void _handlePageChange(int index) {
    int oldIndex = _currentIndex;

    // Pause old video
    if (oldIndex != index && _controllers[oldIndex] != null) {
      _controllers[oldIndex]!.pause();
    }

    // Update index
    _currentIndex = index;

    // Play new video
    if (_controllers[index] != null) {
      _controllers[index]!.play();
    }

    // Preload next video
    if (index + 1 < widget.videos.length && _controllers[index + 1] == null) {
      _initializeController(index + 1);
    }

    setState(() {});
  }

  showDataFun() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      showTitle = true;
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      child: Stack(
        children: [
          Container(
            width: context.displayWidth / 1,
            height: context.displayHeight / 1.22,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(30.r),
                bottomEnd: Radius.circular(30.r),
              ),
            ),
            child: widget.videos.isEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                      16.r,
                    ), // Using .r for responsive border radius
                    child: SizedBox(
                      width: context.displayWidth / 1,
                      height: context.displayHeight / 1.2,
                      child: CachedNetworkImage(
                        width: 100.h,
                        height: 120.h,
                        imageUrl: widget.image,

                        fit: BoxFit.cover,
                        placeholder: (context, url) => Skeletonizer(
                          enabled: true,
                          child: Container(
                            width: 100.h,
                            height: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                30.r,
                              ), // Match the border radius
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Padding(
                          padding: EdgeInsets.all(20.w),
                          child: SvgPicture.asset(
                            'assets/svgs/unavailabeImage.svg',
                          ),
                        ),
                      ),
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.videos.length,
                    onPageChanged: _handlePageChange,
                    itemBuilder: (context, index) {
                      final controller = _controllers[index];
                      currentController = controller;

                      if (controller == null ||
                          !controller.value.isInitialized) {
                        return Center(
                          child: CupertinoActivityIndicator(
                            animating: true,
                            color: Colors.white,
                            radius: 20.w,
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          /// VIDEO VIEW
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.r),
                              child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              ),
                            ),
                          ),

                          /// PROGRESS BAR (under Tap Zones)

                          /// Pause / Resume
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                showPause = !showPause;
                              });
                            },
                            onLongPress: () => controller.pause(),
                            onLongPressUp: () => controller.play(),
                            child: const SizedBox.expand(),
                          ),
                          PositionedDirectional(
                            start: 0,
                            end: 0,
                            top: 0,
                            bottom: 0,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 700),
                              child: showPause
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showPause = !showPause;
                                        });
                                      },
                                      child: Container(
                                        width: context.displayWidth / 1,
                                        height: context.displayHeight / 1,
                                        color: Colors.black.withOpacity(0.2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (ispause) {
                                                  controller.play();
                                                  setState(() {
                                                    showPause = !showPause;
                                                  });
                                                } else {
                                                  controller.pause();
                                                }
                                                setState(() {
                                                  ispause = !ispause;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  ispause
                                                      ? Icons.play_arrow
                                                      : Icons.pause,
                                                  color: Colors.white,
                                                  size: 40.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Text(''),
                            ),
                          ),

                          /// Tap zones يمين/يسار
                          PositionedDirectional(
                            top: 0,
                            bottom: 50.h, // فوق Progress Bar
                            end: 0,
                            child: InkWell(
                              onTap: () {
                                if (_currentIndex != widget.videos.length - 1) {
                                  _pageController.animateToPage(
                                    _currentIndex + 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                  final controller =
                                      _controllers[_currentIndex]!;
                                  controller.seekTo(Duration.zero);
                                  controller.play();
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: context.displayWidth / 3.5,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            top: 0,
                            bottom: 50.h, // فوق Progress Bar
                            start: 0,
                            child: InkWell(
                              onTap: () {
                                if (_currentIndex != 0) {
                                  _pageController.animateToPage(
                                    _currentIndex - 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                }
                                final controller = _controllers[_currentIndex]!;
                                controller.seekTo(Duration.zero);
                                controller.play();
                                setState(() {});
                              },
                              child: Container(
                                width: context.displayWidth / 3.5,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          showTitle
              ? Positioned(
                  bottom: 10.h,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideEnimationWidget(
                          index: 0,
                          child: TextUtils(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            text: widget.videos[_currentIndex].description,
                          ),
                        ),
                        verticalSpace(15),
                        Row(
                          children: List.generate(widget.videos.length, (i) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: _currentIndex > i
                                    ? Container(
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      )
                                    : _currentIndex == i
                                    ? currentController == null ||
                                              !currentController
                                                  .value
                                                  .isInitialized
                                          ? Container(
                                              height: 4.h,
                                              decoration: BoxDecoration(
                                                color: greyClr.withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            )
                                          : LinearProgressIndicator(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              value:
                                                  currentController
                                                          .value
                                                          .duration
                                                          .inMilliseconds ==
                                                      0
                                                  ? 0
                                                  : currentController
                                                            .value
                                                            .position
                                                            .inMilliseconds /
                                                        currentController
                                                            .value
                                                            .duration
                                                            .inMilliseconds,
                                              backgroundColor: greyClr
                                                  .withOpacity(0.5),
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                    Color
                                                  >(Colors.white),
                                            )
                                    : Container(
                                        height: 4.h,
                                        decoration: BoxDecoration(
                                          color: greyClr.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(''),
        ],
      ),
    );
  }
}
