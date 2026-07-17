import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/attempt.dart';
import '../../../../shared/domain/entities/skill.dart';

/// Parses `Club/GetPlayerAttempts`.
///
/// ## ✅ Verified against the live response
///
/// Three of the guesses this file originally made were **wrong**, and the real
/// payload corrected them:
///
/// * **`date`** was assumed to be ISO-8601. It is not: the backend sends
///   `"منذ 7 شهور"` — a pre-formatted, localised, *relative* label. `tryParse`
///   returned `null` for every attempt, so the field was always silently empty
///   and the "newest first" sort built on it sorted nothing. It is now carried
///   through verbatim as [Attempt.submittedLabel], which is what the two widgets
///   that display it were already doing.
/// * **`score`** was assumed to be 0..100. It is **0..10** — the live values are
///   `0.979`, `2.317`, `1.083`, `2.360`, and `attempt_card_widget.dart:162`
///   clamps the average to `0.0..10.0`. [Skill.maxScore] is corrected, which
///   matters because `Skill.ratio` divided by the wrong maximum.
/// * **`aiVideo`** is a **relative** path (`"Videos/HLS/AI/….m3u8"`) while
///   `video` is absolute (`"https://files.fteet.ai/…"`). It is stored as sent;
///   see [Attempt.aiVideoUrl].
///
/// Confirmed as guessed: `skills[].skill` really is the key (not `skillName`),
/// `isProcessed` really is 0/1/2, `rejectedReason` is a string or null, and
/// `visualizeVideo` can be null on a processed attempt.
///
/// One thing the payload reveals that nothing in the code anticipated: a single
/// attempt can list the **same skill more than once** — the sample returns
/// `Turn, Speed, Turn, Speed` for one attempt (one entry per run). Averaging
/// therefore averages over runs, not over distinct skills, which is what the
/// existing card already did.
abstract final class AttemptModel {
  const AttemptModel._();

  /// The `{message, data: [...]}` envelope.
  static List<Attempt> listFromJson(Map<String, dynamic> json) =>
      Json.asObjectList(json['data']).map(fromJson).toList(growable: false);

  static Attempt fromJson(Map<String, dynamic> json) => Attempt(
    id: json['id']?.toString() ?? '',
    status: AttemptStatus.fromCode(Json.asInt(json['isProcessed'])),
    videoUrl: Json.asString(json['video']),
    aiVideoUrl: Json.asString(json['aiVideo']),
    visualizedVideoUrl: Json.asString(json['visualizeVideo']),
    skills: _skillsOf(json['skills']),
    rejectionReason: Json.asString(json['rejectedReason']),
    // Carried through verbatim: the backend sends a formatted relative label
    // ("منذ 7 شهور"), not a timestamp. See [Attempt.submittedLabel].
    submittedLabel: Json.asString(json['date']),
  );

  static List<Skill> _skillsOf(Object? value) {
    if (value is! List) return const <Skill>[];
    return value
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .map(
          (Map<String, dynamic> json) => Skill.clamped(
            name: Json.asString(json['skill']) ?? '',
            // asNum, not asInt: a score of 8.7 must not truncate to 8.
            rawScore: Json.asNum(json['score']) ?? 0,
          ),
        )
        .toList(growable: false);
  }
}
