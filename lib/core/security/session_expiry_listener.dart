import 'dart:async';

import 'package:flutter/material.dart';

import '../di/dependency_injection.dart';
import '../routing/routes.dart';
import '../widget/show_error_snack_bar.dart';
import '../../feature/auth/domain/usecases/log_out.dart';
import 'auth_events.dart';

/// The app's single navigator, so code with no `BuildContext` — the Dio
/// interceptors — can still cause navigation.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Turns "the session died" into "sign the user out and show the login screen".
///
/// Deliberately separate from the interceptor that detects it: the network
/// layer reports a fact, this decides the reaction. That split is what lets the
/// reaction be changed (or tested) without touching transport code.
///
/// Mounted once, above [MaterialApp]'s navigator.
class SessionExpiryListener extends StatefulWidget {
  const SessionExpiryListener({super.key, required this.child});

  final Widget child;

  @override
  State<SessionExpiryListener> createState() => _SessionExpiryListenerState();
}

class _SessionExpiryListenerState extends State<SessionExpiryListener> {
  StreamSubscription<void>? _subscription;

  /// A burst of in-flight requests all 401 at once. Without this they would each
  /// sign out and push the login route again.
  bool _handling = false;

  @override
  void initState() {
    super.initState();
    _subscription = getIt<AuthEvents>().sessionExpired.listen((_) {
      _handleExpiry();
    });
  }

  Future<void> _handleExpiry() async {
    if (_handling) return;
    _handling = true;

    // The same use case the logout button runs, so a session is torn down one
    // way only — no second definition of "clear a session".
    await getIt<LogOut>()();

    final NavigatorState? navigator = appNavigatorKey.currentState;
    if (navigator == null) {
      _handling = false;
      return;
    }

    navigator.pushNamedAndRemoveUntil(
      AppRoute.loginScreen,
      (Route<dynamic> route) => false,
    );

    final BuildContext? navContext = appNavigatorKey.currentContext;
    if (navContext != null) {
      showErrorSnackBar(
        context: navContext,
        title: 'انتهت جلستك، من فضلك سجّل الدخول مرة أخرى',
      );
    }

    _handling = false;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
