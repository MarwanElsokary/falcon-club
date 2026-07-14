/// The backend's approval state for an account, from the login response's
/// `status` field.
///
/// OCP: replaces the magic-string gate `if (status != 'Accepted')` in
/// `LoginCubit.login()`. Callers switch on the enum; the wire spelling lives in
/// exactly one place ([apiValue]).
///
/// ## The account states, verified against live responses
///
/// An account moves through three states, and login answers differently at each:
///
/// | state | wire | meaning |
/// |---|---|---|
/// | phone not confirmed | **400** `{message: "لم يتم تأكيد رقم الجوال بعد."}` | never reaches this enum — it is a failure |
/// | confirmed, awaiting admin | **200** `{status: "Warning", role, ...}`, **no token** | [pendingApproval] |
/// | approved | **200** `{status: "Accepted", token, role, userId, ...}` | [accepted] |
///
/// Note [pendingApproval] arrives as a **200**, not an error — a successful
/// request whose answer is "not yet". Only [accepted] carries a token.
///
/// `'Warning'` is the backend's real spelling, captured live. `'Rejected'` is
/// **not** confirmed; it is modelled defensively and behaves like every other
/// non-accepted value.
///
/// Any unrecognised value maps to [unknown] and is refused — see [canSignIn].
enum AccountStatus {
  accepted(apiValue: 'Accepted'),

  /// Phone confirmed, admin approval outstanding. The server sends its own
  /// message ("طلب انضمامك للتطبيق قيد الانتظار"), which is what the user sees.
  pendingApproval(apiValue: 'Warning'),

  rejected(apiValue: 'Rejected'),
  unknown(apiValue: '');

  const AccountStatus({required this.apiValue});

  final String apiValue;

  static AccountStatus fromApiValue(String? value) {
    if (value == null || value.isEmpty) return AccountStatus.unknown;
    return AccountStatus.values.firstWhere(
      (AccountStatus status) => status.apiValue == value,
      orElse: () => AccountStatus.unknown,
    );
  }

  /// The single gate for "may this account enter the app?".
  ///
  /// Fail-closed: anything other than an explicit [accepted] is a no.
  bool get canSignIn => this == AccountStatus.accepted;
}
