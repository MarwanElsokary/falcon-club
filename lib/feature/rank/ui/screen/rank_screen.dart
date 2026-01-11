import 'package:falcon/core/helpers/extensions.dart';

import 'package:flutter/material.dart';

import '../widget/player_rank_widget.dart';
import '../widget/rank_app_bar.dart';
import '../widget/rank_header_widget.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rankAppBar(context),
      body: Container(
        width: context.displayWidth / 1,
        height: context.displayHeight / 1,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Frame 1011 1.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              RankHeaderWidget(),

              SizedBox(
                width: context.displayWidth / 1,
                height: context.displayHeight / 1.2,
                child: PlayerRankWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
