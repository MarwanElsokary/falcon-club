import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/presentation/widgets/subscription_paywall.dart';

/// Shown when a non-subscribed user taps a locked (paid) exercise.
///
/// It presents the app's canonical [SubscriptionPaywall] — the same design used
/// for the locked players roster and the locked ranking — with exercise-specific
/// copy. It was previously a bespoke, cut-down card built from scratch (no
/// feature checklist, no decorative corners); this reuses the real component so
/// every "subscribers only" surface reads as one design.
void showExerciseLockedSheet(BuildContext context, {required String title}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext sheetContext) => _ExerciseLockedSheet(
      exerciseTitle: title,
    ),
  );
}

class _ExerciseLockedSheet extends StatelessWidget {
  const _ExerciseLockedSheet({required this.exerciseTitle});

  final String exerciseTitle;

  @override
  Widget build(BuildContext context) {
    // Natural height — the original look. The paywall sizes to its content, sits
    // above the keyboard inset, and is NOT capped or forced into a half-screen
    // scrollable box (that was a wrong instruction, since reverted).
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        top: 24.h,
      ),
      child: SubscriptionPaywall(
        title: 'هذا التمرين مغلق',
        message: 'اشترك الآن للوصول إلى "$exerciseTitle" وجميع التمارين المدفوعة',
        features: const <String>[
          'الوصول إلى جميع التمارين',
          'مشاهدة الفيديوهات التوضيحية',
          'تفاصيل المعدات والتعليمات',
          'إحصائيات وأداء اللاعبين',
        ],
      ),
    );
  }
}
