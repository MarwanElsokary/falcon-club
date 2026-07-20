import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/ui/screen/reals_screen.dart';
import 'package:falconclubapp/feature/reals/ui/widget/comment_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/reals_state.dart';
import '../widget/add_comment_widget.dart';

class MainRealsScreen extends StatefulWidget {
  const MainRealsScreen({
    super.key,
    required this.playnowOrNot,
    required this.playerProfile,
    this.onChromeVisibilityChanged,
  });

  final bool playnowOrNot;
  final bool playerProfile;

  /// Asks the host to show (`true`) or hide (`false`) its own chrome — the
  /// shells use it to collapse the bottom nav while the comment sheet is open.
  ///
  /// An outbound callback rather than a cubit lookup: this screen must not know
  /// what its host's chrome *is*. The previous approach reached sideways into
  /// `MainCubit.show`, which no shell listens to (each shell drives its own
  /// notifier), so the behaviour never worked — and Scout's notifier is a
  /// private field no cubit could reach anyway. Null when there is no chrome to
  /// manage, e.g. reels opened from a player profile.
  final ValueChanged<bool>? onChromeVisibilityChanged;

  @override
  State<MainRealsScreen> createState() => _MainRealsScreenState();
}

class _MainRealsScreenState extends State<MainRealsScreen>
    with SingleTickerProviderStateMixin {
  bool _showBottom = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  toggleContainer() {
    setState(() {
      _showBottom = !_showBottom;
      // Sheet open → chrome hidden, and vice versa.
      widget.onChromeVisibilityChanged?.call(!_showBottom);
      if (_showBottom) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: context.displayHeight / 1,
                  width: context.displayWidth / 1,
                  child: Stack(
                    children: [
                      BlocBuilder<RealsCubit, RealsState>(
                        builder: (context, state) {
                          if (state is realsLoading &&
                              context.read<RealsCubit>().realsVide.isEmpty) {
                            return Container(
                              width: context.displayWidth / 1,
                              height: context.displayHeight / 1,
                              color: Colors.black,
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  radius: 20.w,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                          return RealsScreen(
                            playerProfile: widget.playerProfile,

                            playnowOrNot: widget.playnowOrNot,
                            ontap: () {
                              toggleContainer();
                            },
                          );
                        },
                      ),
                      PositionedDirectional(
                        bottom: 0,
                        start: 0,
                        end: 0,
                        top: 0,

                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                toggleContainer();
                              },
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _showBottom ? 1 : 0,
                                child: Container(
                                  height: _showBottom
                                      ? context.displayHeight
                                      : 0,
                                  width: context.displayWidth,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              // Lift the sheet above the keyboard. The Scaffold's
                              // resizeToAvoidBottomInset cannot help here: this
                              // Stack sits inside a fixed displayHeight SizedBox
                              // in a non-scrollable SingleChildScrollView, so the
                              // body never shrinks and a bottom:0 sheet stays
                              // pinned behind the keyboard — you could not see
                              // what you were typing.
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              child: SizeTransition(
                                sizeFactor: _animation,
                                axisAlignment: -1.0,
                                child: CommentViewWidget(
                                  onTap: toggleContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 🔥 ConstrainedBox بحد أقصى واضح يمنع Infinity/NaN
          // في حساب SizeTransition وقت إغلاق الـ animation
          PositionedDirectional(
            start: 0,
            end: 0,
            // This is the actual text input. It needs lifting for the same
            // reason as the sheet above it: this Stack sizes itself to the
            // full-height scroll child, so bottom:0 resolves to the original
            // screen bottom even though the Scaffold body has shrunk — leaving
            // the field you are typing into underneath the keyboard.
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 110.w),
              child: SizeTransition(
                sizeFactor: _animation,
                axisAlignment: -1.0,
                child: AddCommentWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}