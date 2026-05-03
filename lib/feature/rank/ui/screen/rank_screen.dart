import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/extensions.dart';
import '../../cubit/rank_cubit.dart';
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
    // ✅ isSubscribed دايماً بييجي من الـ API عبر الـ cache اللي اتحفظ بعد اللوجين
    final myProfile = CacheHelper.getmyProfile();
    final isSubscribed = myProfile?.data.isSubscribed ?? false;
    context.read<RankCubit>().emitRank(isUserSubscribed: isSubscribed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: rankAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          width: context.displayWidth,
          height: context.displayHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Frame 1011 1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const RankHeaderWidget(),
                SizedBox(
                  width: context.displayWidth,
                  height: context.displayHeight / 1.2,
                  // ✅ PlayerRankWidget بيتكلف منطق الاشتراك داخلياً
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