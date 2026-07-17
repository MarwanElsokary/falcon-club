import 'package:flutter/material.dart';

import '../../../../shared/domain/entities/attempt.dart';

/// The one place an [AttemptStatus] maps to how it looks.
///
/// The colour/label/icon for the three states used to be re-derived from the raw
/// `isProcessed` int in three separate widgets (`attempt_status_badge`,
/// `attempt_card_widget._statusColor`, and the summary row). Centralising it here
/// means a colour changes in one place, and the exhaustive `switch` over the enum
/// makes adding a state a compile error at each site (OCP).
extension AttemptStatusVisuals on AttemptStatus {
  Color get color => switch (this) {
    AttemptStatus.underReview => const Color(0xFFF39C12),
    AttemptStatus.completed => const Color(0xFF27AE60),
    AttemptStatus.rejected => const Color(0xFFE74C3C),
  };

  String get label => switch (this) {
    AttemptStatus.underReview => 'قيد المراجعة',
    AttemptStatus.completed => 'مكتمل',
    AttemptStatus.rejected => 'مرفوض',
  };

  IconData get icon => switch (this) {
    AttemptStatus.underReview => Icons.hourglass_top_rounded,
    AttemptStatus.completed => Icons.check_circle_rounded,
    AttemptStatus.rejected => Icons.cancel_rounded,
  };
}
