import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/gender.dart';

/// A player's AI bio-scan measurements. Every field is optional — the live
/// roster commonly returns them all `null` (no scan has run yet).
final class BodyMeasurements extends Equatable {
  const BodyMeasurements({
    this.height,
    this.shoulderWidth,
    this.armLength,
    this.avgLegAngle,
  });

  final double? height;
  final double? shoulderWidth;
  final double? armLength;
  final double? avgLegAngle;

  bool get hasAny =>
      height != null ||
      shoulderWidth != null ||
      armLength != null ||
      avgLegAngle != null;

  @override
  List<Object?> get props => [height, shoulderWidth, armLength, avgLegAngle];
}

/// A player as shown on their profile — read-only, viewed by a Club/Scout/
/// MainClub. This app never holds a player session, so a player is only ever
/// *viewed*, never the current user.
///
/// Distinct from `Profile` (the session user, with a role and subscription) and
/// from `ExercisePlayer` (a player on one exercise's roster, with an attempt
/// count). This is the rich `Player/GetProfileById` shape: identity + physical
/// attributes + club + measurements. Skills are fetched separately (`Skill` /
/// getSkills) and are deliberately not modelled here.
final class PlayerProfile extends Equatable {
  const PlayerProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.gender,
    this.preferredFoot,
    this.positionName,
    this.birthDateLabel,
    this.height,
    this.weight,
    this.measurements = const BodyMeasurements(),
    this.measurementsImageUrl,
    this.measurementsDate,
    this.clubName,
    this.clubImageUrl,
    this.tps,
    this.isProfileCompleted = false,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  /// `null` when unknown/unrecognised — never assumed male. See [Gender].
  final Gender? gender;

  /// Preferred foot — the backend's Arabic label ("يمين"/"يسار"), shown verbatim.
  /// Kept as a raw string because it is display-only, so there is no enum to
  /// guess at with only one sample value.
  final String? preferredFoot;

  final String? positionName;

  /// Birth date **as the backend formats it** ("04/02/2016"). Not parsed to a
  /// `DateTime`, and no age is derived (deferred) — carried through as a label.
  final String? birthDateLabel;

  final int? height;
  final int? weight;

  final BodyMeasurements measurements;
  final String? measurementsImageUrl;

  /// The scan date **as the backend formats it**, shown under the measurements
  /// image ("تاريخ القياسات: …"). Carried through verbatim like [birthDateLabel];
  /// `null` when no scan date is present (the common case).
  final String? measurementsDate;

  final String? clubName;
  final String? clubImageUrl;

  /// The player's talent-performance score.
  final double? tps;

  final bool isProfileCompleted;

  String get fullName => '$firstName $lastName'.trim();
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;
  bool get hasClub => clubName != null && clubName!.isNotEmpty;
  bool get hasMeasurementsImage =>
      measurementsImageUrl != null && measurementsImageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    photoUrl,
    gender,
    preferredFoot,
    positionName,
    birthDateLabel,
    height,
    weight,
    measurements,
    measurementsImageUrl,
    measurementsDate,
    clubName,
    clubImageUrl,
    tps,
    isProfileCompleted,
  ];
}
