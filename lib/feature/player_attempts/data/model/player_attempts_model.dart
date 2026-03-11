class PlayerAttemptsModel {
  final String message;
  final List<PlayerAttempt> data;

  PlayerAttemptsModel({required this.message, required this.data});

  factory PlayerAttemptsModel.fromJson(Map<String, dynamic> json) =>
      PlayerAttemptsModel(
        message: json['message'] ?? '',
        data: List<PlayerAttempt>.from(
          (json['data'] ?? []).map((x) => PlayerAttempt.fromJson(x)),
        ),
      );
}

class PlayerAttempt {
  final int id;
  final String? video;
  final String? date;
  final int isProcessed; // 0=قيد المراجعة, 1=مكتمل, 2=مرفوض
  final String? rejectedReason;
  final String? aiVideo;
  final String? visualizeVideo;
  final List<AttemptSkill> skills;

  PlayerAttempt({
    required this.id,
    this.video,
    this.date,
    required this.isProcessed,
    this.rejectedReason,
    this.aiVideo,
    this.visualizeVideo,
    required this.skills,
  });

  factory PlayerAttempt.fromJson(Map<String, dynamic> json) => PlayerAttempt(
    id: json['id'] ?? 0,
    video: json['video'],
    date: json['date'],
    isProcessed: json['isProcessed'] ?? 0,
    rejectedReason: json['rejectedReason'],
    aiVideo: json['aiVideo'],
    visualizeVideo: json['visualizeVideo'],
    skills: List<AttemptSkill>.from(
      (json['skills'] ?? []).map((x) => AttemptSkill.fromJson(x)),
    ),
  );
}

class AttemptSkill {
  final String skillName;
  final double score;

  AttemptSkill({required this.skillName, required this.score});

  factory AttemptSkill.fromJson(Map<String, dynamic> json) => AttemptSkill(
    skillName: json['skill'] ?? '',
    score: (json['score'] as num?)?.toDouble() ?? 0.0,
  );
}