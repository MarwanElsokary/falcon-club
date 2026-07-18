import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/thems/thems.dart';
import '../../cubit/rank_cubit.dart';
import '../../cubit/rank_state.dart';
import '../widget/player_rank_widget.dart';
import '../widget/rank_app_bar.dart';
import '../widget/rank_header_widget.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  @override
  void initState() {
    super.initState();
    // F11: the shell/route provider already calls emitRank (it also feeds the
    // home top-3 widget). With the lazy tab stack this screen mounts *after*
    // that, so only fetch if the list is still empty — kills the double-fetch
    // that fired when both this initState and the provider ran at shell mount.
    // The standalone rank route has a fresh (empty) cubit, so it still fetches.
    final RankCubit cubit = context.read<RankCubit>();
    if (cubit.rankList.isEmpty) cubit.emitRank();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: rankAppBar(context),
      body: RefreshIndicator(
        color: mainColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          if (!mounted) return;
          context.read<RankCubit>().emitRank();
          final cubit = context.read<RankCubit>();
          if (!cubit.isClosed) {
            await cubit.stream
                .firstWhere((state) => state is! rankLoading)
                .catchError((_) {});
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            width: context.displayWidth,
            height: context.displayHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Frame 1011 1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const RankHeaderWidget(),
                SizedBox(
                  width: context.displayWidth,
                  height: context.displayHeight / 1.2,
                  child: const PlayerRankWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}