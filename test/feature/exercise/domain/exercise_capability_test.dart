import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

/// The two product invariants of this whole feature area:
///
///   1. A Scout may NEVER upload an attempt.
///   2. A Club may NEVER see a paywall.
///
/// Both are confirmed product decisions, not incidental behaviour. These tests
/// exist so that a future refactor that "simplifies" the capability types into a
/// pair of booleans has to delete an explicit assertion to do it.
void main() {
  const Subscription active = Subscription(
    isPurchased: true,
    remainingDays: 30,
  );
  const Subscription expired = Subscription(
    isPurchased: true,
    remainingDays: 0,
  );
  const Subscription never = Subscription.none;

  group('a Scout can never upload', () {
    test('read-only regardless of subscription state', () {
      for (final Subscription subscription in <Subscription>[
        active,
        expired,
        never,
      ]) {
        final ExerciseCapability capability = ScoutCapability(subscription);

        expect(capability.rowAction, isA<ViewAttemptsAction>());
        expect(capability.canUploadAttempt, isFalse);
      }
    });

    test('paying does not buy the ability to upload', () {
      // The paywall gates *visibility*, not write access. A subscribed scout
      // sees the full roster and still cannot upload.
      const ExerciseCapability subscribed = ScoutCapability(active);

      expect(subscribed.isPaywalled, isFalse);
      expect(subscribed.canUploadAttempt, isFalse);
    });

    test('the role mapping never hands a Scout an upload action', () {
      final ExerciseCapability capability = ExerciseCapability.forRole(
        UserRole.scout,
        active,
      );

      expect(capability, isA<ScoutCapability>());
      expect(capability.canUploadAttempt, isFalse);
    });
  });

  group('a Club is never paywalled', () {
    test('a coach managing their own squad is not paid content', () {
      const ExerciseCapability capability = CoachCapability();

      expect(capability.isPaywalled, isFalse);
      expect(capability.rowAction, isA<UploadAttemptAction>());
      expect(capability.canUploadAttempt, isTrue);
    });

    test('no subscription state can paywall a Club', () {
      for (final Subscription subscription in <Subscription>[
        active,
        expired,
        never,
      ]) {
        final ExerciseCapability capability = ExerciseCapability.forRole(
          UserRole.club,
          subscription,
        );

        expect(capability.isPaywalled, isFalse);
        expect(capability.canUploadAttempt, isTrue);
      }
    });
  });

  group('the Scout paywall follows the subscription entity', () {
    test('an active subscription lifts it', () {
      expect(const ScoutCapability(active).isPaywalled, isFalse);
    });

    test('never subscribing raises it', () {
      expect(const ScoutCapability(never).isPaywalled, isTrue);
    });

    // `package_screen.dart` checks only `isSubscribed` and would let this
    // through; `Subscription.isActive` checks the remaining days too.
    test('an EXPIRED subscription raises it — purchased is not enough', () {
      expect(expired.isPurchased, isTrue);
      expect(const ScoutCapability(expired).isPaywalled, isTrue);
    });
  });

  group('MainClub', () {
    // Deliberately read-only pending confirmation — it fails closed rather than
    // granting a write capability nobody asked for. If this test starts failing
    // because MainClub became a CoachCapability, that was a product decision and
    // this test should be updated, not deleted.
    test('is read-only and unpaywalled', () {
      final ExerciseCapability capability = ExerciseCapability.forRole(
        UserRole.mainClub,
        never,
      );

      expect(capability, isA<MainClubCapability>());
      expect(capability.canUploadAttempt, isFalse);
      expect(capability.isPaywalled, isFalse);
    });
  });
}
