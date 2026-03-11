class ClubExercisesModel {
  final String message;
  final List<ClubExercise> data;

  ClubExercisesModel({required this.message, required this.data});

  factory ClubExercisesModel.fromJson(Map<String, dynamic> json) =>
      ClubExercisesModel(
        message: json['message'] ?? '',
        data: List<ClubExercise>.from(
          (json['data'] ?? []).map((x) => ClubExercise.fromJson(x)),
        ),
      );
}

class ClubExercise {
  final int id;
  final String? photoPath;
  final String title;
  final String description;
  final List<String> skills;

  ClubExercise({
    required this.id,
    this.photoPath,
    required this.title,
    required this.description,
    required this.skills,
  });

  factory ClubExercise.fromJson(Map<String, dynamic> json) => ClubExercise(
    id: json['id'] ?? 0,
    photoPath: json['photoPath'],
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    skills: List<String>.from(json['skills'] ?? []),
  );
}