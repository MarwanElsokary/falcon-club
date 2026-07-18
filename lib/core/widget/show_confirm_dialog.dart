import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/extensions.dart';
import '../helpers/spacing.dart';
import '../thems/thems.dart';
import 'center_text_utils.dart';
import 'fav_icon_click.dart';
import 'slide_enimation_widget.dart';

/// The warning mark used for "are you sure?" prompts — present tense, unlike
/// `Rejected.json`, which reads as an outcome that already happened.
const String kConfirmAlertLottie = 'assets/lottie/Alert Icon Exclamation.json';

/// How long a dialog's entrance animation runs.
///
/// [SlideEnimationWidget] defaults to 2500ms, which reads as sluggish on a
/// confirm: the card and its buttons spend two and a half seconds sliding and
/// fading into place, so the dialog looks like it is still arriving while the
/// user is already deciding. 300ms matches the app's other transitions.
const Duration kDialogEntranceDuration = Duration(milliseconds: 300);

/// A yes/no confirmation in the app's own dialog language.
///
/// The two delete dialogs it replaces were bare Material [AlertDialog]s that
/// inherited nothing from the design system — default title, default body, two
/// text-only buttons — so they read as if they belonged to another app. This
/// mirrors `showLogoutDialog`, the pattern already used from four call sites
/// across both drawers: a transparent dialog whose visual is a white card, a
/// Lottie floating above it, a centred bold title, and two equal-width pills.
///
/// [onConfirm] runs *after* the dialog is dismissed, so callers never have to
/// reason about acting on a context that is already going away.
///
/// [isDestructive] fills the confirm button with [redClr] instead of
/// [mainColor]. Logout uses the primary colour for its own confirm; removing
/// someone from a team is less recoverable, so it is signalled differently
/// while keeping the geometry identical.
Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onConfirm,
  String lottiePath = kConfirmAlertLottie,
  String? confirmLabel,
  String? cancelLabel,
  bool isDestructive = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        actionsPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actions: <Widget>[
          SlideEnimationWidget(
            index: 0,
            duration: kDialogEntranceDuration,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 45.w),
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  width: context.displayWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      verticalSpace(60),
                      Align(
                        alignment: Alignment.center,
                        child: CenterTextUtils(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          maxlines: 3,
                          text: title,
                        ),
                      ),
                      verticalSpace(20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _DialogButton(
                                label: confirmLabel ?? 'نعم'.tr(),
                                background: isDestructive
                                    ? redClr
                                    : mainColor,
                                foreground: Colors.white,
                                onTap: () {
                                  Navigator.of(dialogContext).pop();
                                  onConfirm();
                                },
                              ),
                            ),
                            horizontalSpace(15),
                            Expanded(
                              child: _DialogButton(
                                label: cancelLabel ?? 'لا'.tr(),
                                background: primerymainColor,
                                foreground: Colors.black,
                                onTap: () => Navigator.of(dialogContext).pop(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(25),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: 0,
                  start: 0,
                  end: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: FavIconClick(
                        width: 100.w,
                        lottiePath: lottiePath,
                        start: true,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.w),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: CenterTextUtils(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: foreground,
          text: label,
        ),
      ),
    );
  }
}
