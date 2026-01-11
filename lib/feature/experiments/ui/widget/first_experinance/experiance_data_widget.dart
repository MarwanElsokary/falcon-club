import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/widget/text_utils.dart';

class ExperianceDataWidget extends StatelessWidget {
  const ExperianceDataWidget({
    super.key,
    required this.title,
    required this.cat,
  });
  final String title;
  final String cat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/svgs/cil_balance-scale.svg'),
        verticalSpace(10),
        TextUtils(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: title,
        ),
        verticalSpace(10),
        TextUtils(
          fontSize: 10,
          maxlines: 1,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: cat,
        ),
      ],
    );
  }
}
