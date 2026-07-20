import 'package:equatable/equatable.dart';

/// One entry in a player's digital-report history.
///
/// [date] is the parsed calendar date; [rawDate] is exactly what the server
/// sent. Both are kept because the server's format (`dd/MM/yyyy`) is not ISO
/// and a future change to it should degrade to "show what we were given"
/// rather than to a blank row.
class DigitalReport extends Equatable {
  const DigitalReport({
    required this.id,
    required this.playerName,
    required this.rawDate,
    this.date,
  });

  final int id;
  final String playerName;
  final String rawDate;
  final DateTime? date;

  /// What the row should show — the parsed date when it made sense, otherwise
  /// the server's own string.
  String get displayDate {
    final DateTime? parsed = date;
    if (parsed == null) return rawDate;
    final String day = parsed.day.toString().padLeft(2, '0');
    final String month = parsed.month.toString().padLeft(2, '0');
    return '$day/$month/${parsed.year}';
  }

  @override
  List<Object?> get props => <Object?>[id, playerName, rawDate, date];
}
