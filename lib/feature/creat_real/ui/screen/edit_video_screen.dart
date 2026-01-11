import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/anmiate_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'dart:io';

import '../../../../core/widget/app_bar_utils.dart';

class EditVideoScreen extends StatefulWidget {
  final File file;

  const EditVideoScreen(this.file, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditVideoScreenState createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;

  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() async {
    await _trimmer.loadVideo(videoFile: widget.file);
  }

  Future<void> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });

        if (outputPath != null) {
          context.pushReplacementNamed(
            AppRoute.publishMyVideo,
            arguments: {'outputPath': outputPath},
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkclr,
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: darkclr,
        title: TextAppBarUtils(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: 'قص الفيديو',
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ignore: deprecated_member_use
              color: greyClr.withOpacity(0.2),
            ),
            child: IconButton(
              icon: Icon(Icons.check, size: 20.w, color: Colors.white),
              onPressed: _progressVisibility ? null : _saveVideo,
            ),
          ),
          horizontalSpace(20),
        ],
      ),
      body: Column(
        children: [
          verticalSpace(15),
          // عرض الفيديو
          Expanded(
            child: GestureDetector(
              onTap: () async {
                bool playbackState = await _trimmer.videoPlaybackControl(
                  startValue: _startValue,
                  endValue: _endValue,
                );
                setState(() {
                  _isPlaying = playbackState;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: greyClr.withOpacity(0.5)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),

                      child: VideoViewer(trimmer: _trimmer),
                    ),
                  ),
                  // أيقونة Play/Pause في النص
                  if (!_isPlaying)
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
                ],
              ),
            ),
          ),
          verticalSpace(20),

          // الـ Timeline للقص
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 56.h,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: Duration(seconds: 15),
              durationStyle: DurationStyle.FORMAT_MM_SS,
              areaProperties: TrimAreaProperties(
                thumbnailFit: BoxFit.cover,
                borderRadius: 8.r,
              ),

              editorProperties: TrimEditorProperties(
                borderRadius: 8.r,
                borderPaintColor: Colors.white,
                borderWidth: 5.w,
              ),
              onChangeStart: (value) async {
                // لما تحرك نقطة البداية، الفيديو يروح للمكان ده
                await _trimmer.videoPlaybackControl(
                  startValue: value,
                  endValue: _endValue,
                );
                setState(() {
                  _startValue = value;
                  // _isPlaying = false;
                });
              },
              onChangeEnd: (value) async {
                // لما تحرك نقطة النهاية، الفيديو يروح للمكان ده
                await _trimmer.videoPlaybackControl(
                  startValue: _startValue,
                  endValue: value,
                );
                setState(() {
                  _endValue = value;
                  // _isPlaying = false;
                });
              },
              onChangePlaybackState: (value) {
                setState(() {
                  _isPlaying = value;
                });
              },
            ),
          ),

          // أزرار التحكم
          verticalSpace(40),
          // Padding(
          //   padding: EdgeInsets.all(20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       IconButton(
          //         icon: Icon(
          //           _isPlaying ? Icons.pause : Icons.play_arrow,
          //           size: 40,
          //           color: Colors.white,
          //         ),
          //         onPressed: () async {
          //           bool playbackState = await _trimmer.videoPlaybackControl(
          //             startValue: _startValue,
          //             endValue: _endValue,
          //           );
          //           setState(() {
          //             _isPlaying = playbackState;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
