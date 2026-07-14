import 'package:equatable/equatable.dart';

/// A training exercise (a "training" / "trial" in the current API's words).
///
/// One entity serves Club and Scout alike. The app currently maintains two
/// parallel stacks for this — `training` and `scout_training` — whose repos hit
/// the *same endpoint* and whose only real difference is a cubit name and a
/// route constant. Nothing about the exercise itself differs by role, so the
/// domain does not branch on role at all.
final class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.title,
    this.description,
    this.photoUrl,
    this.categoryId,
    this.requiredSkillNames = const <String>[],
    this.isPopular = false,
  });

  final String id;
  final String title;
  final String? description;
  final String? photoUrl;
  final String? categoryId;

  /// Skills this exercise is scored against.
  final List<String> requiredSkillNames;

  final bool isPopular;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    photoUrl,
    categoryId,
    requiredSkillNames,
    isPopular,
  ];
}
