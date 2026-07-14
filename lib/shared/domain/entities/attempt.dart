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
    this.skills = const <Skill>[],
    this.rejectionReason,
    this.submittedAt,
  });

  final String id;
  final AttemptStatus status;
  final String? videoUrl;
  final List<Skill> skills;
  final String? rejectionReason;
  final DateTime? submittedAt;

  /// Overall score for this attempt.
  ///
  /// Lifted from `attempt_card_widget.dart:160`, which computes it inside
  /// `build()` with a `reduce` that throws on an empty skill list. Here the
  /// empty case is handled once, in the domain (see [SkillScoring.averageScore]).
  double get overallScore => status.hasScore ? skills.averageScore : 0;

  bool get isPlayable => videoUrl != null && videoUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    status,
    videoUrl,
    skills,
    rejectionReason,
    submittedAt,
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
