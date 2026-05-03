import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
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
  });
  final bool playnowOrNot;
  final bool playerProfile;

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
      context.read<MainCubit>().show.value = !context
          .read<MainCubit>()
          .show
          .value;
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
                              bottom: 0,
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
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: AddCommentWidget(),
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
