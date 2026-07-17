import 'package:flutter/material.dart';

import '../../../../shared/presentation/widgets/subscription_paywall.dart';

/// "القائمة الكاملة مغلقة" — the prompt shown under a truncated player roster.
///
/// Rendered by both the Scout and Club exercise-details screens (a Scout can
/// reach either, via the Exercise tab or Home → trials), so it lives in one
/// place rather than inside `scout_players_section` where it began.
///
/// It is only the players-specific copy: the design itself is
/// [SubscriptionPaywall], the app's single paywall card, so this and the
/// locked-exercise prompt and the ranking paywall cannot drift apart.
class ExercisePlayersPaywall extends StatelessWidget {
  const ExercisePlayersPaywall({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubscriptionPaywall(
      title: 'القائمة الكاملة مغلقة',
      message:
          'اشترك الآن للوصول إلى قائمة اللاعبين الكاملة ومشاهدة جميع المحاولات',
      features: <String>[
        'عرض جميع اللاعبين',
        'مشاهدة كل المحاولات',
        'تتبع أداء اللاعبين',
        'إحصائيات مفصلة',
      ],
    );
  }
}
