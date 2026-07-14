import '../../../core/routing/routes.dart';
import '../../domain/entities/user_role.dart';

/// The one place that maps a role to its home screen.
///
/// ## The bug this closes
///
/// Three separate places re-derived this mapping with raw string comparison,
/// and they **disagreed**:
///
/// | source | Club | MainClub | Scout |
/// |---|---|---|---|
/// | `splash_screen.dart:203` | clubMain | mainClub | scoutMain |
/// | `login_screen.dart:47` | clubMain | **clubMain** | scoutMain |
/// | `login_button_widget.dart:39` | **mainClub** | mainClub | scoutMain |
///
/// Worse, `LoginScreen`'s `BlocListener` and `LoginButtonWidget`'s
/// `BlocConsumer` both fired on the same success state, so two
/// `pushNamedAndRemoveUntil` calls raced on every login — and for a plain Club
/// user they pushed *different destinations*. Which shell you landed in
/// depended on listener ordering.
///
/// OCP: the mapping is now an exhaustive `switch` over [UserRole]. Adding a role
/// is a compile error here — not a silently-missed `else` branch in three files.
///
/// SRP: it answers "where does this role live?" and nothing else. It does not
/// navigate, read storage, or touch a `BuildContext`; the caller does the
/// pushing. That keeps it trivially unit-testable.
abstract final class RoleRouter {
  const RoleRouter._();

  /// The route a signed-in [role] should be sent to, replacing the whole stack.
  ///
  /// Matches `splash_screen.dart` — the only one of the three dispatchers that
  /// was correct for all three roles.
  static String homeRouteFor(UserRole role) => switch (role) {
    UserRole.club => AppRoute.clubMainScreen,
    UserRole.mainClub => AppRoute.mainClubScreen,
    UserRole.scout => AppRoute.scoutMainScreen,
  };

  /// Where an unauthenticated user goes.
  static const String signedOutRoute = AppRoute.loginScreen;
}
