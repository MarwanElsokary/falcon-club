import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/gender.dart';

/// A player on the coach's favourites list (`Club/GetFavPlayers`).
///
/// A lean, read-only view — the favourites grid shows identity + position +
/// foot + score, and lets the coach un-favourite. Distinct from `ClubPlayer`
/// (the team-management shape with reports/assign/delete actions) and from
/// `PlayerProfile` (the full viewed-player record).
///
/// [name] is the backend's single full-name field (this endpoint does not split
/// first/last). [foot] is the Arabic label ("يمين"/"يسار"), display-only. The
/// payload also carries `accountNumber`/`direction` which the UI does not use.
final class FavoritePlayer extends Equatable {
  const FavoritePlayer({
    required this.id,
    required this.name,
    this.photoUrl,
    this.position,
    this.foot,
    this.tps,
    this.age,
    this.gender,
  });

  final String id;
  final String name;
  final String? photoUrl;
  final String? position;
  final String? foot;
  final double? tps;
  final int? age;
  final Gender? gender;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    photoUrl,
    position,
    foot,
    tps,
    age,
    gender,
  ];
}
