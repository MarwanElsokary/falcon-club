import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/session_repository.dart';

/// Signs the user out.
///
/// Replaces logout being performed *inside widgets*: `club_profile_screen.dart`
/// (line 361) and `log_out_widget.dart` both clear secure storage directly from
/// a button callback, with no cubit and no use case between them.
@injectable
class LogOut implements UseCaseWithoutInput<void> {
  const LogOut(this._repository);

  final SessionRepository _repository;

  @override
  ResultVoid call() => _repository.clearSession();
}
