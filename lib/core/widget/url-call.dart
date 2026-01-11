import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'show_error_snack_bar.dart';

Future urlCall({required BuildContext context, required String url}) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (e) {
    // ignore: use_build_context_synchronously
    showErrorSnackBar(context: context, title: 'حدث خطأ ما'.tr());
  }
}
