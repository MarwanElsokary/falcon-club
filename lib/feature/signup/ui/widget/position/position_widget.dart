import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/anmiate_builder.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionWidget extends StatefulWidget {
  const PositionWidget({super.key});

  @override
  State<PositionWidget> createState() => _PositionWidgetState();
}

class _PositionWidgetState extends State<PositionWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.displayWidth / 1,
          height: context.displayHeight / 1.4,
          padding: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 60.h),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/field.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              //Rm CF LM
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  locationWidget(
                    positionNumber: 1,
                    onTap: () {
                      setState(() {
                        context.read<LoginCubit>().positionID.value = 12;
                        context.read<LoginCubit>().positionName.value =
                            "جناح ايمن";
                      });
                    },
                    position: 'RM',
                    select: context.read<LoginCubit>().positionID.value == 12,
                    positionName: "جناح ايمن",
                  ),
                  Column(
                    children: [
                      locationWidget(
                        positionNumber: 2,
                        onTap: () {
                          setState(() {
                            context.read<LoginCubit>().positionID.value = 11;
                            context.read<LoginCubit>().positionName.value =
                                "راس حربة";
                          });
                        },
                        position: 'CF',
                        select:
                            context.read<LoginCubit>().positionID.value == 11,
                        positionName: "راس حربة",
                      ),
                      verticalSpace(20),
                    ],
                  ),

                  locationWidget(
                    positionNumber: 3,
                    onTap: () {
                      setState(() {
                        context.read<LoginCubit>().positionID.value = 10;
                        context.read<LoginCubit>().positionName.value =
                            "جناح ايسر";
                      });
                    },
                    position: 'LM',
                    select: context.read<LoginCubit>().positionID.value == 10,
                    positionName: "جناح ايسر",
                  ),
                ],
              ),
              //Lm CM Rm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  locationWidget(
                    positionNumber: 4,
                    onTap: () {
                      setState(() {
                        context.read<LoginCubit>().positionID.value = 8;
                        context.read<LoginCubit>().positionName.value =
                            "صانع العاب";
                      });
                    },
                    position: 'CM',
                    select: context.read<LoginCubit>().positionID.value == 8,
                    positionName: "صانع العاب",
                  ),
                  locationWidget(
                    positionNumber: 5,
                    onTap: () {
                      setState(() {
                        context.read<LoginCubit>().positionID.value = 7;
                        context.read<LoginCubit>().positionName.value =
                            "وسط مدافع";
                      });
                    },
                    position: 'CDM',
                    select: context.read<LoginCubit>().positionID.value == 7,
                    positionName: "وسط مدافع",
                  ),
                ],
              ),

              //CDM

              //Lb CB RB
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  locationWidget(
                    positionNumber: 7,
                    onTap: () {
                      setState(() {
                        context.read<LoginCubit>().positionID.value = 3;
                        context.read<LoginCubit>().positionName.value =
                            "ظهير ايمن";
                      });
                    },
                    positionName: "ظهير ايمن",
                    position: 'RB',
                    select: context.read<LoginCubit>().positionID.value == 3,
                  ),
                  Column(
                    children: [
                      verticalSpace(40),
                      Row(
                        children: [
                          locationWidget(
                            positionNumber: 8,
                            onTap: () {
                              setState(() {
                                context.read<LoginCubit>().positionID.value = 5;
                                context.read<LoginCubit>().positionName.value =
                                    "مدافع ايمن";
                              });
                            },
                            position: 'CB',
                            select:
                                context.read<LoginCubit>().positionID.value ==
                                5,
                            positionName: "مدافع ايمن",
                          ),
                          horizontalSpace(20),
                          locationWidget(
                            positionNumber: 8,
                            onTap: () {
                              setState(() {
                                context.read<LoginCubit>().positionID.value = 6;
                                context.read<LoginCubit>().positionName.value =
                                    "مدافع ايسر";
                              });
                            },
                            positionName: "مدافع ايسر",
                            position: 'CB',
                            select:
                                context.read<LoginCubit>().positionID.value ==
                                6,
                          ),
                        ],
                      ),
                    ],
                  ),

                  locationWidget(
                    positionNumber: 6,
                    onTap: () {
                      setState(() {
                        context.read<LoginCubit>().positionID.value = 2;
                        context.read<LoginCubit>().positionName.value =
                            "ظهير ايسر";
                      });
                    },
                    position: 'LB',
                    select: context.read<LoginCubit>().positionID.value == 2,
                    positionName: "ظهير ايسر",
                  ),
                ],
              ),

              //Gk
              locationWidget(
                positionNumber: 9,
                onTap: () {
                  setState(() {
                    context.read<LoginCubit>().positionID.value = 1;
                    context.read<LoginCubit>().positionName.value = "حارس مرمى";
                  });
                },
                position: 'Gk',
                select: context.read<LoginCubit>().positionID.value == 1,
                positionName: "حارس مرمى",
              ),
            ],
          ),
        ),
      ],
    );
  }

  locationWidget({
    required Function() onTap,
    required String position,
    required bool select,
    required String positionName,
    required int positionNumber,
  }) {
    return Column(
      children: [
        AnimateBuilder(
          columnCount: 4,
          position: positionNumber,
          child: InkWell(
            onTap: onTap,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),

              // padding: EdgeInsets.all(7.w),
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: select ? mainColor : Colors.transparent,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: mainColor, width: select ? 2.w : 0),
                color: select ? mainColor : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CenterTextUtils(
                  fontSize: position.length == 3 ? 14 : 16,
                  fontWeight: FontWeight.w700,
                  color: select ? Colors.white : blackclr,
                  text: position,
                ),
              ),
            ),
          ),
        ),
        verticalSpace(3),
        CenterTextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: positionName,
        ),
      ],
    );
  }
}
