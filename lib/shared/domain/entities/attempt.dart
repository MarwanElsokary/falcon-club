import 'package:equatable/equatable.dart';

import 'skill.dart';

/// Where an uploaded attempt sits in the AI review pipeline.
///
/// The three codes are the backend's `isProcessed` field, documented in
/// `player_attempts_model.dart` and confirmed by `attempt_status_badge.dart`
/// and the summary row in `player_attempts_screen.dart`:
///
/// | code | meaning              |
/// |------|----------------------|
/// | 0    | قيد المراجعة (under review) |
/// | 1    | مكتمل (completed, scored)   |
/// | 2    | مرفوض (rejected)            |
///
/// OCP: the UI switches exhaustively over this enum instead of comparing raw
/// ints (`attempt.isProcessed == 1`). Adding a state becomes a compile error at
/// every call site that must handle it.
enum AttemptStatus {
  underReview(code: 0),
  completed(code: 1),
  rejected(code: 2);

  const AttemptStatus({required this.code});

  final int code;

  /// Unknown codes degrade to [underReview] — the safe, non-terminal state.
  /// Never invent a score for a status we do not understand.
  static AttemptStatus fromCode(int? code) => AttemptStatus.values.firstWhere(
    (AttemptStatus status) => status.code == code,
    orElse: () => AttemptStatus.underReview,
  );

  bool get isTerminal =>
      this == AttemptStatus.completed || this == AttemptStatus.rejected;

  bool get hasScore => this == AttemptStatus.completed;
}

/// One video submission by a player against an exercise.
final class Attempt extends Equatable {
  const Attempt({
    required this.id,
    required this.status,
    this.videoUrl,
    this.aiVideoUrl,
    this.visualizedVideoUrl,
    this.skills = const <Skill>[],
    this.rejectionReason,
    this.submittedLabel,
  });

  final String id;
  final AttemptStatus status;

  /// The raw video the coach uploaded.
  final String? videoUrl;

  /// The AI-annotated rendering, produced once the attempt is processed.
  /// Absent while [AttemptStatus.underReview], and on a rejected attempt.
  ///
  /// Always **absolute** here. The backend sends this one *relative*
  /// (`"Videos/HLS/AI/….m3u8"`, no scheme or host) while [videoUrl] is absolute —
  /// which is why the AI video used to sit on its loading spinner forever. It is
  /// now resolved against the media base in the data layer (`MediaUrl.resolve`),
  /// so the entity and every widget see a single, playable shape.
  final String? aiVideoUrl;

  /// The skeleton/pose visualisation. Same lifecycle as [aiVideoUrl].
  final String? visualizedVideoUrl;

  final List<Skill> skills;
  final String? rejectionReason;

  /// When the attempt was submitted, **as the backend phrases it**.
  ///
  /// This was originally a `DateTime?`, parsed with `DateTime.tryParse`. The
  /// live payload shows why that was wrong: `date` comes back as
  /// `"منذ 7 شهور"` — "7 months ago" — a **pre-formatted, localised, relative
  /// label**, not a timestamp. `tryParse` returned `null` for every attempt ever
  /// fetched, so the field was silently always empty.
  ///
  /// There is no timestamp to recover, so there is nothing to sort or format by;
  /// the backend has already made both decisions. The label is carried through
  /// verbatim, which is exactly what `attempt_card_widget.dart:111` and
  /// `player_attempt_detail_screen.dart:143` already do (`text: attempt.date`).
  final String? submittedLabel;

  /// Overall score for this attempt.
  ///
  /// Lifted from `attempt_card_widget.dart:160`, which computes it inside
  /// `build()` with a `reduce` that throws on an empty skill list. Here the
  /// empty case is handled once, in the domain (see [SkillScoring.averageScore]).
  double get overallScore => status.hasScore ? skills.averageScore : 0;

  bool get isPlayable => videoUrl != null && videoUrl!.isNotEmpty;

  /// The AI outputs only exist once processing has completed successfully.
  /// Asking the entity beats each widget re-deriving
  /// `isProcessed == 1 && aiVideo != null` for itself.
  bool get hasAnalysis =>
      status == AttemptStatus.completed && (aiVideoUrl?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [
    id,
    status,
    videoUrl,
    aiVideoUrl,
    visualizedVideoUrl,
    skills,
    rejectionReason,
    submittedLabel,
  ];
}

/// Roll-up used by the attempts screen header.
///
/// `player_attempts_screen.dart:210-213` recomputes these four counters inside
/// `build()` on every rebuild. Making it a domain value object means it is
/// computed once, and is unit-testable without pumping a widget.
final class AttemptTally extends Equatable {
  const AttemptTally({
    required this.total,
    required this.completed,
    required this.underReview,
    required this.rejected,
  });

  factory AttemptTally.of(List<Attempt> attempts) => AttemptTally(
    total: attempts.length,
    completed: attempts
        .where((Attempt attempt) => attempt.status == AttemptStatus.completed)
        .length,
    underReview: attempts
        .where((Attempt attempt) => attempt.status == AttemptStatus.underReview)
        .length,
    rejected: attempts
        .where((Attempt attempt) => attempt.status == AttemptStatus.rejected)
        .length,
  );

  final int total;
  final int completed;
  final int underReview;
  final int rejected;

  @override
  List<Object?> get props => [total, completed, underReview, rejected];
}
