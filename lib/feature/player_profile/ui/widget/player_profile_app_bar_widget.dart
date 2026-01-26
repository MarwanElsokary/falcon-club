import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';

class PlayerProfileAppBarWidget extends StatelessWidget {
  const PlayerProfileAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      child: Row(
        children: [
         const  BackButton(color: Colors.white),
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
    );
  }
}
