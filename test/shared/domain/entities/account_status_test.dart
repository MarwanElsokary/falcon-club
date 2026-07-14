import 'package:falconclubapp/shared/domain/entities/account_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountStatus', () {
    test('parses the one status confirmed by a live response', () {
      expect(AccountStatus.fromApiValue('Accepted'), AccountStatus.accepted);
    });

    // The live pending-approval response sends status "Warning" — NOT "Pending".
    // It arrives as a 200 with a role and no token: phone confirmed, admin
    // approval outstanding.
    test('maps the real pending-approval status, "Warning"', () {
      expect(
        AccountStatus.fromApiValue('Warning'),
        AccountStatus.pendingApproval,
      );
    });

    test('degrades unrecognised, empty, and null statuses to unknown', () {
      expect(AccountStatus.fromApiValue('Banned'), AccountStatus.unknown);
      expect(AccountStatus.fromApiValue(''), AccountStatus.unknown);
      expect(AccountStatus.fromApiValue(null), AccountStatus.unknown);
    });

    // Fail-closed. This is the security-relevant property: an unexpected or
    // unparseable status must never grant access. It preserves exactly the
    // behaviour of the current `if (status != 'Accepted')` gate.
    test('only Accepted may sign in — everything else is refused', () {
      expect(AccountStatus.accepted.canSignIn, isTrue);
      expect(AccountStatus.pendingApproval.canSignIn, isFalse);
      expect(AccountStatus.rejected.canSignIn, isFalse);
      expect(AccountStatus.unknown.canSignIn, isFalse);
    });
  });
}
