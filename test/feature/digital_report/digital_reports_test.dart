import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/error/exceptions.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/core/networking/json.dart';
import 'package:falconclubapp/feature/digital_report/data/datasources/digital_reports_remote_data_source.dart';
import 'package:falconclubapp/feature/digital_report/data/models/digital_report_model.dart';
import 'package:falconclubapp/feature/digital_report/data/repositories/digital_reports_repository_impl.dart';
import 'package:falconclubapp/feature/digital_report/domain/entities/digital_report.dart';
import 'package:falconclubapp/feature/digital_report/domain/entities/report_document.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

/// The captured response body, verbatim.
const List<Map<String, dynamic>> _captured = <Map<String, dynamic>>[
  <String, dynamic>{'id': 1019, 'date': '20/07/2026', 'name': 'bitso mosiman'},
  <String, dynamic>{'id': 1020, 'date': '20/07/2026', 'name': 'bitso mosiman'},
];

class _StubDataSource implements DigitalReportsRemoteDataSource {
  _StubDataSource({
    this.rows = const <Map<String, dynamic>>[],
    this.pdf,
    this.throws,
  });

  final List<Map<String, dynamic>> rows;
  final PdfPayload? pdf;
  final Object? throws;

  int? deletedId;

  @override
  Future<List<Map<String, dynamic>>> fetchReports(String playerId) async {
    final Object? error = throws;
    if (error != null) throw error;
    return rows;
  }

  @override
  Future<PdfPayload> fetchReportPdf(int reportId) async {
    final Object? error = throws;
    if (error != null) throw error;
    return pdf!;
  }

  @override
  Future<void> deleteReport(int reportId) async {
    final Object? error = throws;
    if (error != null) throw error;
    deletedId = reportId;
  }
}

DigitalReportsRepositoryImpl _repo(_StubDataSource source) =>
    DigitalReportsRepositoryImpl(source, const ErrorMapper());

void main() {
  group('date parsing', () {
    test('reads the server\'s dd/MM/yyyy', () {
      expect(
        DigitalReportModel.parseSlashDate('20/07/2026'),
        DateTime(2026, 7, 20),
      );
    });

    test('day and month are not swapped', () {
      // The trap: 07/08 is 7 August, not 8 July. ISO parsing would read this
      // the other way round.
      final DateTime? parsed = DigitalReportModel.parseSlashDate('07/08/2026');

      expect(parsed?.day, 7);
      expect(parsed?.month, 8);
    });

    test('rejects a date that does not exist rather than rolling it over', () {
      // DateTime(2026, 2, 31) silently becomes 3 March.
      expect(DigitalReportModel.parseSlashDate('31/02/2026'), isNull);
    });

    test('returns null for shapes it cannot read', () {
      for (final String input in <String>[
        '',
        '2026-07-20',
        '20/07',
        'not/a/date',
      ]) {
        expect(
          DigitalReportModel.parseSlashDate(input),
          isNull,
          reason: input,
        );
      }
    });
  });

  group('row mapping', () {
    test('maps the captured payload', () {
      final DigitalReport report = DigitalReportModel.fromJson(_captured.first);

      expect(report.id, 1019);
      expect(report.playerName, 'bitso mosiman');
      expect(report.rawDate, '20/07/2026');
      expect(report.date, DateTime(2026, 7, 20));
      expect(report.displayDate, '20/07/2026');
    });

    test('an unreadable date still yields a usable row', () {
      // The report is still downloadable and deletable, so it must survive.
      final DigitalReport report = DigitalReportModel.fromJson(
        <String, dynamic>{'id': 7, 'date': 'yesterday', 'name': 'x'},
      );

      expect(report.id, 7);
      expect(report.date, isNull);
      expect(report.displayDate, 'yesterday');
    });
  });

  group('getReports', () {
    test('returns the mapped rows', () async {
      final Either<Failure, List<DigitalReport>> result = await _repo(
        _StubDataSource(rows: _captured),
      ).getReports('42');

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => <DigitalReport>[]).length, 2);
    });

    test('sorts newest first, keeping undated rows last', () async {
      final Either<Failure, List<DigitalReport>> result = await _repo(
        _StubDataSource(
          rows: <Map<String, dynamic>>[
            <String, dynamic>{'id': 1, 'date': '01/01/2026', 'name': 'old'},
            <String, dynamic>{'id': 2, 'date': 'unknown', 'name': 'undated'},
            <String, dynamic>{'id': 3, 'date': '05/03/2026', 'name': 'new'},
          ],
        ),
      ).getReports('42');

      final List<int> ids = result
          .getOrElse((_) => <DigitalReport>[])
          .map((DigitalReport r) => r.id)
          .toList();

      expect(ids, <int>[3, 1, 2]);
    });

    test('surfaces a failure instead of an empty list', () async {
      // The regression this guards: the old repository turned any unexpected
      // body into `success([])`, which the sheet rendered as "no previous
      // reports" — indistinguishable from a player who genuinely has none.
      final Either<Failure, List<DigitalReport>> result = await _repo(
        _StubDataSource(
          throws: const ServerException(message: 'unexpected shape'),
        ),
      ).getReports('42');

      expect(result.isLeft(), isTrue);
      expect(
        result.getOrElse((_) => <DigitalReport>[]),
        isEmpty,
        reason: 'a Left carries no rows',
      );
    });

    test('a non-list body is a contract violation, not an empty list', () {
      // This is what the data source does with the body before mapping.
      expect(
        () => Json.asObjectList(<String, dynamic>{'message': 'nope'}),
        throwsA(isA<ServerException>()),
      );
      expect(() => Json.asObjectList(null), throwsA(isA<ServerException>()));
    });
  });

  group('pdf endpoint URL', () {
    test('is absolute', () {
      // The shared Dio has no baseUrl — retrofit keeps the base in its own
      // annotation and combines it per call. A relative path here goes out
      // hostless as `Pdf/GetDigitalReportPlayerPdf?id=4` and dies as an
      // opaque DioExceptionType.unknown.
      final Uri url = Uri.parse(
        RetrofitDigitalReportsRemoteDataSource.pdfUrl,
      );

      expect(url.hasScheme, isTrue, reason: 'needs https://');
      expect(url.host, isNotEmpty, reason: 'needs a host');
      expect(url.toString(), contains('Pdf/GetDigitalReportPlayerPdf'));
      // The `/api` segment is part of the base and is easy to drop.
      expect(url.path, startsWith('/api/'));
    });
  });

  group('downloadReportPdf', () {
    const DigitalReport report = DigitalReport(
      id: 1019,
      playerName: 'bitso mosiman',
      rawDate: '20/07/2026',
    );

    test('prefers the filename the server sent', () async {
      final Either<Failure, ReportDocument> result = await _repo(
        _StubDataSource(
          pdf: const PdfPayload(
            bytes: <int>[1, 2, 3],
            fileName: 'PlayerDigitalReport_1019__20260720172859.pdf',
          ),
        ),
      ).downloadReportPdf(report);

      expect(
        result.getOrElse((_) => throw StateError('expected a document')).fileName,
        'PlayerDigitalReport_1019__20260720172859.pdf',
      );
    });

    test('falls back to id + player when no filename was sent', () async {
      final Either<Failure, ReportDocument> result = await _repo(
        _StubDataSource(pdf: const PdfPayload(bytes: <int>[1])),
      ).downloadReportPdf(report);

      final String name = result
          .getOrElse((_) => throw StateError('expected a document'))
          .fileName;

      expect(name, startsWith('PlayerDigitalReport_1019'));
      expect(name, endsWith('.pdf'));
      // Spaces would break the share sheet's filename on some platforms.
      expect(name.contains(' '), isFalse);
    });
  });

  group('deleteReport', () {
    test('passes the report id through', () async {
      final _StubDataSource source = _StubDataSource();

      final Either<Failure, Unit> result = await _repo(source).deleteReport(99);

      expect(result.isRight(), isTrue);
      expect(source.deletedId, 99);
    });

    test('maps a thrown error to a failure', () async {
      final Either<Failure, Unit> result = await _repo(
        _StubDataSource(throws: const ServerException(message: 'boom')),
      ).deleteReport(99);

      expect(result.isLeft(), isTrue);
    });
  });
}
