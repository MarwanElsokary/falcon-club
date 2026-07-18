import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Subscription.isActive', () {
    test('is false when never purchased', () {
      expect(Subscription.none.isActive, isFalse);
      expect(
        const Subscription(isPurchased: false, remainingDays: 30).isActive,
        isFalse,
      );
    });

    test('is true when purchased and days remain', () {
      expect(
        const Subscription(isPurchased: true, remainingDays: 1).isActive,
        isTrue,
      );
    });

    // package_screen.dart:146 checks only `isSubscribed` and would grant paid
    // access here. subscription_helper.dart checks the days and would not.
    test('is false when purchased but expired', () {
      const Subscription expired = Subscription(
        isPurchased: true,
        remainingDays: 0,
      );

      expect(expired.isActive, isFalse);
      expect(expired.hasExpired, isTrue);
    });

    test('falls back to the purchased flag when the backend omits days', () {
      expect(const Subscription(isPurchased: true).isActive, isTrue);
    });
  });

  group('UserRole', () {
    test('parses the backend strings', () {
      expect(UserRole.fromApiValue('Scout'), UserRole.scout);
      expect(UserRole.fromApiValue('MainClub'), UserRole.mainClub);
      expect(UserRole.fromApiValue('Club'), UserRole.club);
    });

    test('falls back to club for unknown or missing roles', () {
      expect(UserRole.fromApiValue(null), UserRole.club);
      expect(UserRole.fromApiValue('Player'), UserRole.club);
    });

    test('only the main club reviews join requests', () {
      expect(UserRole.mainClub.canReviewJoinRequests, isTrue);
      expect(UserRole.club.canReviewJoinRequests, isFalse);
      expect(UserRole.scout.canReviewJoinRequests, isFalse);
    });

    test('only scouts must pay for access', () {
      expect(UserRole.scout.requiresSubscription, isTrue);
      expect(UserRole.club.requiresSubscription, isFalse);
      expect(UserRole.mainClub.requiresSubscription, isFalse);
    });
  });

  group('Profile.canAccessPaidContent', () {
    Profile profileWith({
      required UserRole role,
      required Subscription subscription,
    }) => Profile(
      id: 'user-1',
      firstName: 'Test',
      lastName: 'User',
      role: role,
      subscription: subscription,
    );

    test('a club is entitled without any subscription', () {
      final Profile club = profileWith(
        role: UserRole.club,
        subscription: Subscription.none,
      );

      expect(club.canAccessPaidContent, isTrue);
    });

    test('a scout without a live subscription is not entitled', () {
      final Profile scout = profileWith(
        role: UserRole.scout,
        subscription: const Subscription(isPurchased: true, remainingDays: 0),
      );

      expect(scout.canAccessPaidContent, isFalse);
    });

    test('a scout with a live subscription is entitled', () {
      final Profile scout = profileWith(
        role: UserRole.scout,
        subscription: const Subscription(isPurchased: true, remainingDays: 5),
      );

      expect(scout.canAccessPaidContent, isTrue);
    });
  });
}
