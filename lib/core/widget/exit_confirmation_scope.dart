import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'show_confirm_dialog.dart';

/// Asks before letting the device back button close the app.
///
/// Wraps a role shell's root. Back-press used to exit immediately with no
/// prompt, which is easy to do by accident on the home tab.
///
/// Only the *root* route reaches this: anything pushed on top pops normally, so
/// this never interferes with in-app back navigation.
///
/// [scaffoldKey] lets an open drawer take priority — with a drawer showing,
/// back should close it rather than offer to quit the app.
class ExitConfirmationScope extends StatelessWidget {
  const ExitConfirmationScope({
    super.key,
    required this.child,
    this.scaffoldKey,
  });

  final Widget child;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Never pop straight away; the dialog decides.
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        final ScaffoldState? scaffold = scaffoldKey?.currentState;
        if (scaffold?.isDrawerOpen ?? false) {
          scaffold!.closeDrawer();
          return;
        }
        if (scaffold?.isEndDrawerOpen ?? false) {
          scaffold!.closeEndDrawer();
          return;
        }

        showConfirmDialog(
          context: context,
          title: 'هل تريد الخروج من التطبيق؟'.tr(),
          // Not destructive: leaving loses nothing and reopening restores the
          // app. Same primary-colour confirm as the logout prompt.
          isDestructive: false,
          onConfirm: SystemNavigator.pop,
        );
      },
      child: child,
    );
  }
}
