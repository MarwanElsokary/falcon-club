import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../entities/password_reset_ticket.dart';
import '../repositories/password_reset_repository.dart';

final class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.ticket, required this.password});

  final PasswordResetTicket ticket;

  /// Already validated — see [Password.createConfirmed].
  final Password password;

  @override
  List<Object?> get props => [ticket, password];

  /// Never leak the ticket or the new secret.
  @override
  String toString() => 'ResetPasswordParams(ticket: $ticket)';
}

/// Step 3 — spends the ticket on a new password.
///
/// The password arrives as a [Password], so it has *already* satisfied every
/// [PasswordRule] and matched its confirmation. That happens in the domain, via
/// `Password.createConfirmed` — not in a widget, and not against a
/// `GlobalKey<FormState>`.
///
/// This is a **choosing** path, so it uses `Password.create`, not
/// `Password.trusted`. (Sign-in is the opposite: an existing password must be
/// accepted even if it fails today's rules, or the user is locked out of their
/// own account.)
@injectable
class ResetPassword implements UseCase<String, ResetPasswordParams> {
  const ResetPassword(this._repository);

  final PasswordResetRepository _repository;

  static const String _invalidTicketMessage =
      'انتهت صلاحية الجلسة، يرجى إعادة المحاولة';

  @override
  ResultFuture<String> call(ResetPasswordParams params) async {
    // A blank ticket cannot authorise anything. The legacy model declares
    // `resetToken` non-nullable and throws on a missing one; failing cleanly
    // here is the same guard, without the crash.
    if (!params.ticket.isUsable) {
      return const Left<Failure, String>(
        ValidationFailure(message: _invalidTicketMessage),
      );
    }
    return _repository.resetPassword(
      ticket: params.ticket,
      password: params.password,
    );
  }
}
