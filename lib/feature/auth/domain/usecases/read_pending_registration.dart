import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/registration_credential.dart';
import '../repositories/pending_registration_repository.dart';

/// Is there a registration awaiting phone confirmation?
///
/// The login screen uses this to decide whether to offer "تأكيد رقم الجوال".
/// Note it does **not** check usability — the caller does, via
/// [RegistrationCredential.isUsable]. An expired credential must not produce a
/// button that is guaranteed to 401: the backend has no way to re-issue the
/// token, so once it lapses, delayed confirmation is genuinely impossible and
/// the honest thing is to show only the server's message.
@injectable
class ReadPendingRegistration
    implements UseCaseWithoutInput<RegistrationCredential?> {
  const ReadPendingRegistration(this._repository);

  final PendingRegistrationRepository _repository;

  @override
  ResultFuture<RegistrationCredential?> call() => _repository.read();
}
