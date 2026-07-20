import '../../../../core/networking/json.dart';
import '../../domain/entities/digital_report.dart';

/// Maps one row of `Club/PlayerDigitalReports`.
///
/// The server sends `{ "id": 1019, "date": "20/07/2026", "name": "..." }` —
/// `date` is `dd/MM/yyyy`, which `DateTime.parse` rejects outright, so it is
/// split by hand. A date we cannot read is not an error: the row still has an
/// id and a name and is still downloadable, so [DigitalReport.rawDate] keeps
/// the original and the UI shows that instead.
abstract final class DigitalReportModel {
  static DigitalReport fromJson(Map<String, dynamic> json) {
    final String rawDate = Json.asString(json['date']) ?? '';

    return DigitalReport(
      id: Json.asInt(json['id']) ?? 0,
      playerName: Json.asString(json['name']) ?? '',
      rawDate: rawDate,
      date: parseSlashDate(rawDate),
    );
  }

  /// `dd/MM/yyyy` → [DateTime], or null when it is anything else.
  static DateTime? parseSlashDate(String value) {
    final List<String> parts = value.split('/');
    if (parts.length != 3) return null;

    final int? day = int.tryParse(parts[0]);
    final int? month = int.tryParse(parts[1]);
    final int? year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;

    final DateTime parsed = DateTime(year, month, day);
    // DateTime rolls 31/02 over into March rather than rejecting it; if the
    // round trip does not match, the input was not a real date.
    if (parsed.day != day || parsed.month != month || parsed.year != year) {
      return null;
    }
    return parsed;
  }
}
