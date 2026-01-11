import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:falcon/core/thems/thems.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import '../../../login/cubit/login_cubit.dart';
import 'date_of_birth_widget.dart';
import 'gender_widget.dart';
import 'phone_auth_text_from_field.dart';
import 'position/select_position_widget.dart';
import 'select_best_foot_widget.dart';
import 'select_collage_widget.dart';
import 'select_uni_widget.dart';
import 'show_password_icon_widget.dart';
import 'upload_profile_image_widget.dart';

class SignupIputDataWidget extends StatelessWidget {
  const SignupIputDataWidget({super.key, required this.update});
  final bool update;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,
      child: Column(
        children: [
          //image widget
          update ? UploadProfileImageWidget() : SizedBox(),

          update
              ? Column(
                  children: [
                    //first and last name
                    Row(
                      children: [
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 0,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .name,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من ادخال الاسم'.tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,

                              textInputType: TextInputType.text,
                              hintText: 'Esmail'.tr(),
                              lableText: 'الاسم الأول'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 1,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .lastName,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من ادخال الاسم'.tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,

                              textInputType: TextInputType.text,
                              hintText: 'Osama',
                              lableText: 'الاسم الاخير'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    Row(
                      children: [
                        //email
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 2,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .email,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من ادخال البريد الاكتروني'
                                      .tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,
                              textInputType: TextInputType.text,
                              hintText: 'email@gmail.com',
                              lableText: 'البريد الاكتروني'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        horizontalSpace(20),
                        //phone
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 3,
                            child: PhoneAuthTextFormField(
                              onChanged: (value) {
                                context.read<LoginCubit>().changeButtonStatus();
                                if (value.toString().length ==
                                    context.read<LoginCubit>().maxLength) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              maxLength: context.read<LoginCubit>().maxLength,
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .phone,
                              obscureText: false,
                              validator: (validator) {
                                if (validator.toString().length !=
                                    context.read<LoginCubit>().maxLength) {
                                  return 'من فضلك ادخل رقم الهاتف صحيح'.tr();
                                }
                              },
                              textInputType: TextInputType.phone,
                              hintText: 'رقم الهاتف'.tr(),
                              suffix: Text(''),
                            ),
                          ),
                        ),
                      ],
                    ),

                    verticalSpace(20),
                    // height & weight
                    Row(
                      children: [
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 4,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .height,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من أدخل الطول'.tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,
                              textInputType: TextInputType.number,
                              hintText: 'أدخل الطول'.tr(),
                              lableText: 'الطول'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 5,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .weight,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من ادخال البريد الاكتروني'
                                      .tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,
                              textInputType: TextInputType.number,
                              hintText: 'أدخل الوزن',
                              lableText: 'الوزن'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: context
                                .read<LoginCubit>()
                                .showPassword,
                            builder: (context, showPassword, _) {
                              return AnimateBuilder(
                                columnCount: 1,
                                position: 6,
                                child: EditGenderWidget(),
                              );
                            },
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 7,
                            child: DateOfBirthWidget(),
                          ),
                        ),
                      ],
                    ),

                    verticalSpace(update ? 0 : 20),
                    Visibility(
                      visible: !update,
                      child: Row(
                        children: [
                          Expanded(
                            child: AnimateBuilder(
                              columnCount: 2,
                              position: 8,
                              child: SelectUniWidget(),
                            ),
                          ),
                          horizontalSpace(20),
                          Expanded(
                            child: AnimateBuilder(
                              columnCount: 2,
                              position: 9,
                              child: SelectCollageWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    verticalSpace(20),
                    Row(
                      children: [
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 10,
                            child: SelectBestFootWidget(),
                          ),
                        ),
                        horizontalSpace(20),
                        //password
                        Expanded(child: SelectPositionWidget()),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    //first and last name
                    Row(
                      children: [
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 0,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .name,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من ادخال الاسم'.tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,

                              textInputType: TextInputType.text,
                              hintText: 'Esmail'.tr(),
                              lableText: 'الاسم الأول'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: AnimateBuilder(
                            columnCount: 2,
                            position: 1,
                            child: TextFromFieldUtilsWidget(
                              controller: context
                                  .read<LoginCubit>()
                                  .controller
                                  .lastName,
                              obscureText: false,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'من فضلك تأكد من ادخال الاسم'.tr();
                                }
                                return null;
                              },
                              fillColor: fillColor,

                              textInputType: TextInputType.text,
                              hintText: 'Osama',
                              lableText: 'الاسم الاخير'.tr(),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    AnimateBuilder(
                      columnCount: 2,
                      position: 2,
                      child: TextFromFieldUtilsWidget(
                        controller: context.read<LoginCubit>().controller.email,
                        obscureText: false,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'من فضلك تأكد من ادخال البريد الاكتروني'
                                .tr();
                          }
                          return null;
                        },
                        fillColor: fillColor,
                        textInputType: TextInputType.text,
                        hintText: 'email@gmail.com',
                        lableText: 'البريد الاكتروني'.tr(),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    verticalSpace(20),
                    AnimateBuilder(
                      columnCount: 2,
                      position: 3,
                      child: PhoneAuthTextFormField(
                        onChanged: (value) {
                          context.read<LoginCubit>().changeButtonStatus();
                          if (value.toString().length ==
                              context.read<LoginCubit>().maxLength) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        maxLength: context.read<LoginCubit>().maxLength,
                        controller: context.read<LoginCubit>().controller.phone,
                        obscureText: false,
                        validator: (validator) {
                          if (validator.toString().length !=
                              context.read<LoginCubit>().maxLength) {
                            return 'من فضلك ادخل رقم الهاتف صحيح'.tr();
                          }
                        },
                        textInputType: TextInputType.phone,
                        hintText: 'رقم الهاتف'.tr(),
                        suffix: Text(''),
                      ),
                    ),
                  ],
                ),

          verticalSpace(20),
          Visibility(
            visible: !update,
            child: ValueListenableBuilder(
              valueListenable: context.read<LoginCubit>().showPassword,
              builder: (context, showPassword, _) {
                return AnimateBuilder(
                  columnCount: 1,
                  position: 4,
                  child: TextFromFieldUtilsWidget(
                    controller: context.read<LoginCubit>().controller.password,
                    obscureText: showPassword,
                    validator: (v) {
                      if (v!.length < 6) {
                        return 'من فضلك تأكد من ادخال كلمة المرور'.tr();
                      }
                      return null;
                    },

                    fillColor: fillColor,
                    suffix: ShowPasswordIconWidget(),
                    textInputType: TextInputType.text,
                    hintText: '******',
                    lableText: 'كلمة المرور'.tr(),
                    textInputAction: TextInputAction.next,
                  ),
                );
              },
            ),
          ),
          verticalSpace(20),
        ],
      ),
    );
  }
}
