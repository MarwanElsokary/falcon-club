import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future bootomshet({
  required String title,
  required Function() cameratab,
  required Function() galleryatab,
  required BuildContext context,
}) async {
  await showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text(
          title.tr(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        message: CenterTextUtils(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: CupertinoColors.systemGrey,
          text: 'اختر طريقة'.tr(),
        ),

        actions: [
          CupertinoActionSheetAction(
            onPressed: cameratab,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.camera,
                  color: CupertinoColors.activeBlue,
                ),
                horizontalSpace(6),
                CenterTextUtils(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.activeBlue,
                  text: 'كاميرا'.tr(),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: galleryatab,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.photo,
                  color: CupertinoColors.activeBlue,
                ),
                horizontalSpace(6),
                CenterTextUtils(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.activeBlue,
                  text: 'المعرض'.tr(),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: CenterTextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.destructiveRed,
            text: 'إلغاء'.tr(),
          ),
        ),
      );
    },
  );
}
