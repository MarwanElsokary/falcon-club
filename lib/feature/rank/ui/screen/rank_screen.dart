import 'package:falcon/core/cache/cach_Helper.dart';
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
    // الحصول على حالة الاشتراك من بيانات البروفايل المحفوظة
    final myProfile = CacheHelper.getmyProfile();
    final isSubscribed = myProfile?.data.isSubscribed ?? false;

    // استدعاء emitRank مع حالة الاشتراك الحقيقية
    context.read<RankCubit>().emitRank(isUserSubscribed: isSubscribed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rankAppBar(context),
      body: Container(
        width: context.displayWidth / 1,
        height: context.displayHeight / 1,
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
                width: context.displayWidth / 1,
                height: context.displayHeight / 1.2,
                child: const PlayerRankWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}