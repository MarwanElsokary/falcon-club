import 'package:equatable/equatable.dart';

/// A downloaded report PDF, in memory.
///
/// The domain deals in bytes and a name, not in file paths — where the bytes
/// end up (temp dir, share sheet, disk) is a presentation concern, and keeping
/// it out of here means the download is testable without a filesystem.
class ReportDocument extends Equatable {
  const ReportDocument({required this.fileName, required this.bytes});

  final String fileName;
  final List<int> bytes;

  @override
  List<Object?> get props => <Object?>[fileName, bytes.length];
}
