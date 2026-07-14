import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/session_repository.dart';

/// Answers "is anyone signed in, and as what?" — returns `null` when not.
///
/// This is what the splash screen will consume in Phase 3. Today the splash
/// screen reads the token and the role out of storage itself
/// (`splash_screen.dart:188-197`) and then re-derives the role→route mapping,
/// which is one of the three contradictory dispatchers that disagree for
/// `Club`.
@injectable
class ReadSession implements UseCaseWithoutInput<AuthSession?> {
  const ReadSession(this._repository);

  final SessionRepository _repository;

  @override
  ResultFuture<AuthSession?> call() => _repository.readSession();
}
