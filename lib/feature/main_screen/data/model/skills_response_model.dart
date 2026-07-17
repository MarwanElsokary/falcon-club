/// Response model for `Player/ProfileFeature` (the player's rated skills).
///
/// Relocated here in Phase 8a. It previously lived inside the exercise-details
/// DTO in `training_details/`, which was unrelated coupling — `getSkills` is a
/// profile-feature read, consumed by `main_repo`/`main_cubit` and rendered on the
/// player profile. That exercise DTO was deleted when the exercise-details screen
/// migrated to the domain; this model moved out first so nothing broke.
class SkillsResponse {
  final String message;
  final List<Skill> data;

  SkillsResponse({required this.message, required this.data});

  factory SkillsResponse.fromJson(Map<String, dynamic> json) => SkillsResponse(
    message: json["message"] ?? '',
    data: List<Skill>.from(
      (json["data"] as List?)?.map((x) => Skill.fromJson(x)) ?? [],
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

/// One rated skill (name + 0–10 score) as returned by `Player/ProfileFeature`.
class Skill {
  final String skillName;
  final double score;

  Skill({required this.skillName, required this.score});

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    skillName: json["skillName"] ?? '',
    score: (json["score"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {"skillName": skillName, "score": score};

  @override
  String toString() => 'Skill(skillName: "$skillName", score: $score)';
}
