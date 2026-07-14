import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/registration_credential.dart';
import '../../domain/usecases/log_in.dart';
import '../../domain/usecases/read_pending_registration.dart';
import 'sign_in_state.dart';

/// Drives the sign-in screen.
///
/// Depends on **two use cases** and nothing else. Contrast with `LoginCubit`
/// (589 lines), which owns two `GlobalKey<FormState>`s, twelve
/// `TextEditingController`s, JWT base64 decoding, image compression, temp-file
/// I/O, token persistence, and three registration flows.
///
/// It holds no Flutter types: no controllers, no keys, no `BuildContext`. The
/// screen owns its form state and hands this cubit plain strings, so every
/// branch here is testable without pumping a widget.
@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._logIn, this._readPendingRegistration)
    : super(const SignInState());

  final LogIn _logIn;
  final ReadPendingRegistration _readPendingRegistration;

  /// Looks for an account on this device whose phone was never confirmed.
  ///
  /// The screen used to do this itself with `getIt<ReadPendingRegistration>()`,
  /// which put a service locator in the widget layer. It belongs here.
  ///
  /// An **expired** credential is discarded rather than surfaced: the backend
  /// cannot re-issue the registration token, so a "تأكيد رقم الجوال" link built
  /// on a dead credential would only produce a 401.
  Future<void> loadPendingRegistration() async {
    final result = await _readPendingRegistration();
    result.fold(
      // A storage failure just means no retry link — never a blocked login.
      (Failure _) => emit(state.copyWith(clearPendingRegistration: true)),
      _rememberIfUsable,
    );
  }

  void _rememberIfUsable(RegistrationCredential? credential) {
    final bool isOffered = credential?.isUsable ?? false;
    emit(
      isOffered
          ? state.copyWith(pendingRegistration: credential)
          : state.copyWith(clearPendingRegistration: true),
    );
  }

  /// Validates the input, then signs in.
  ///
  /// Validation happens in the domain (via the value objects), not against a
  /// `GlobalKey<FormState>` reached into from the state layer — which is what
  /// `LoginCubit.login()` does at line 65.
  Future<void> signIn({
    required String phone,
    required String password,
  }) async {
    final Either<ValidationFailure, LoginCredentials> credentials =
        _credentialsFrom(phone: phone, password: password);

    await credentials.fold(
      (ValidationFailure failure) async => _emitAttempt(
        SignInFailed(failure.message),
      ),
      _attemptSignIn,
    );
  }

  Future<void> _attemptSignIn(LoginCredentials credentials) async {
    _emitAttempt(const SignInInProgress());
    final result = await _logIn(credentials);
    _emitAttempt(
      result.fold(
        (Failure failure) => SignInFailed(failure.message),
        (AuthSession session) => SignInSucceeded(session),
      ),
    );
  }

  /// Changes only the operation, leaving [SignInState.pendingRegistration]
  /// intact — a failed sign-in must not hide the retry link.
  void _emitAttempt(SignInAttempt attempt) =>
      emit(state.copyWith(attempt: attempt));

  /// Builds the credentials, short-circuiting on the first invalid field.
  ///
  /// Both fields are checked **leniently, on purpose**:
  ///
  /// * [PhoneNumber.permissive] — *not* `forSaudiRegistration`. At sign-in the
  ///   phone is a lookup key the **server** matches against an account.
  ///   Applying the strict Saudi format here would lock out any account whose
  ///   stored number predates that rule.
  /// * [Password.trusted] — *not* `Password.create`. An existing account may
  ///   hold a password that fails today's strength rules; rejecting it
  ///   client-side would lock the user out of their own account.
  ///
  /// Registration is strict on both. The asymmetry is deliberate — read the
  /// [PhoneNumber] class doc before "fixing" it into consistency.
  Either<ValidationFailure, LoginCredentials> _credentialsFrom({
    required String phone,
    required String password,
  }) {
    if (password.isEmpty) {
      return const Left(ValidationFailure(message: _passwordRequiredMessage));
    }
    return PhoneNumber.permissive(phone).map(
      (PhoneNumber number) => LoginCredentials(
        phone: number,
        password: Password.trusted(password),
      ),
    );
  }

  static const String _passwordRequiredMessage = 'كلمة المرور مطلوبة';
}
