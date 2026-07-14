import 'package:equatable/equatable.dart';

/// A city in the signup cascade (city → club).
///
/// Named `City`, not `Country` or `University`. The backend calls this endpoint
/// `Player/GetCountries` and the widget that renders it is `SelectUniWidget` —
/// both are leftovers from a university app. The user-facing label has always
/// been `المدينة` (city), and the validation message in `LoginCubit` says so
/// too. The domain uses the honest name; the data layer keeps the wire name.
///
/// [id] is a `String` held **verbatim**. The existing `CountiesList.id` is
/// typed `dynamic`, and the value is passed straight back to the backend as the
/// `countryId` query param. Parsing it into an `int` would risk altering what
/// goes on the wire for no benefit — the app never does arithmetic on it.
final class City extends Equatable {
  const City({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
